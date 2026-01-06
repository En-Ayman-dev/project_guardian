import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../models/invoice_model.dart';

abstract class SalesRemoteDataSource {
  // [MODIFIED] دالة الجلب الآن تدعم التقسيم (Pagination)
  Future<List<InvoiceModel>> getInvoices({
    required int limit,
    InvoiceModel? startAfter, String? invoiceType,
  });

  // [NEW] دالة بحث خاصة بالسيرفر
  Future<List<InvoiceModel>> searchInvoices(String query);

  Future<InvoiceModel> getInvoiceByNumber(String invoiceNumber);
  Future<void> addInvoice(InvoiceModel invoice);
  Future<void> deleteInvoice(InvoiceModel invoice);
  Future<void> updateInvoice(InvoiceModel invoice);
}

@LazySingleton(as: SalesRemoteDataSource)
class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final FirebaseFirestore _firestore;

  SalesRemoteDataSourceImpl(this._firestore);

  static const String _invoicesCollection = 'invoices';
  static const String _productsCollection = 'products';
  static const String _clientsCollection = 'clients_suppliers';
  static const String _countersCollection = 'settings';
  static const String _countersDoc = 'counters';

  // في الدالة getInvoices، نضيف معامل type
  @override
  Future<List<InvoiceModel>> getInvoices({
    required int limit,
    InvoiceModel? startAfter,
    String? invoiceType, // [NEW] إضافة نوع الفاتورة
  }) async {
    try {
      var query = _firestore
          .collection(_invoicesCollection)
          .orderBy('date', descending: true)
          .orderBy(FieldPath.documentId, descending: true)
          .limit(limit);

      // [NEW] إذا تم تحديد نوع، نضيف شرط الفلترة
      if (invoiceType != null) {
        query = query.where('type', isEqualTo: invoiceType);
      }

      if (startAfter != null) {
        final values = [Timestamp.fromDate(startAfter.date), startAfter.id];
        query = query.startAfter(values);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => InvoiceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<InvoiceModel>> searchInvoices(String query) async {
    try {
      // بحث برقم الفاتورة (مطابقة تامة عادةً للأرقام)
      final numberQuery = _firestore
          .collection(_invoicesCollection)
          .where('invoiceNumber', isEqualTo: query)
          .get();

      // بحث باسم العميل (بحث بالبادئة Prefix Search)
      // ملاحظة: Firestore حساس لحالة الأحرف، هذا البحث يعمل إذا كان الاسم مطابقاً في البداية
      final nameQuery = _firestore
          .collection(_invoicesCollection)
          .where('clientName', isGreaterThanOrEqualTo: query)
          .where(
            'clientName',
            isLessThan: '$query\uf8ff',
          ) // \uf8ff هو آخر حرف في اليونيكود
          .get();

      // تنفيذ الطلبين بالتوازي
      final results = await Future.wait([numberQuery, nameQuery]);

      // دمج النتائج
      final allDocs = [...results[0].docs, ...results[1].docs];

      // إزالة التكرار (Deduplication) باستخدام Map أو Set
      final uniqueMap = <String, InvoiceModel>{};
      for (var doc in allDocs) {
        if (!uniqueMap.containsKey(doc.id)) {
          uniqueMap[doc.id] = InvoiceModel.fromFirestore(doc);
        }
      }

      // إعادة ترتيب النتائج حسب التاريخ (الأحدث أولاً)
      final models = uniqueMap.values.toList();
      models.sort((a, b) => b.date.compareTo(a.date));

      return models;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // --- بقية الدوال كما هي دون تغيير ---

  @override
  Future<InvoiceModel> getInvoiceByNumber(String invoiceNumber) async {
    try {
      final snapshot = await _firestore
          .collection(_invoicesCollection)
          .where('invoiceNumber', isEqualTo: invoiceNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw ServerFailure("الفاتورة رقم $invoiceNumber غير موجودة");
      }

      return InvoiceModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addInvoice(InvoiceModel invoice) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final counterRef = _firestore
            .collection(_countersCollection)
            .doc(_countersDoc);
        final counterSnapshot = await transaction.get(counterRef);

        final productSnapshots = await _readProducts(
          transaction,
          invoice.items,
        );

        DocumentSnapshot? clientSnapshot;
        if (invoice.clientId.isNotEmpty) {
          final clientRef = _firestore
              .collection(_clientsCollection)
              .doc(invoice.clientId);
          clientSnapshot = await transaction.get(clientRef);
        }

        int nextNumber = 1;
        String fieldName = _getCounterFieldName(invoice.type);

        if (counterSnapshot.exists) {
          final data = counterSnapshot.data() as Map<String, dynamic>;
          final current = data[fieldName] as int? ?? 0;
          nextNumber = current + 1;
        }

        final invoiceWithNumber = invoice.copyWith(
          invoiceNumber: nextNumber.toString(),
        );

        final stockUpdates = _calculateStockUpdates(
          invoice: invoiceWithNumber,
          productSnapshots: productSnapshots,
          isRevert: false,
        );

        double? newClientBalance;
        if (clientSnapshot != null && clientSnapshot.exists) {
          if (invoice.paymentType == InvoicePaymentType.credit) {
            final currentBal =
                ((clientSnapshot.data() as Map<String, dynamic>)['balance']
                        as num?)
                    ?.toDouble() ??
                0.0;
            newClientBalance = _calculateClientBalance(
              currentBalance: currentBal,
              invoice: invoiceWithNumber,
              isRevert: false,
            );
          }
        }

        if (counterSnapshot.exists) {
          transaction.update(counterRef, {fieldName: nextNumber});
        } else {
          transaction.set(counterRef, {fieldName: 1});
        }

        for (final update in stockUpdates.entries) {
          transaction.update(update.key, {'stock': update.value});
        }

        if (newClientBalance != null && clientSnapshot != null) {
          transaction.update(clientSnapshot.reference, {
            'balance': newClientBalance,
          });
        }

        final invoiceRef = _firestore
            .collection(_invoicesCollection)
            .doc(invoiceWithNumber.id);
        transaction.set(invoiceRef, invoiceWithNumber.toJson());
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteInvoice(InvoiceModel invoice) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final productSnapshots = await _readProducts(
          transaction,
          invoice.items,
        );

        DocumentSnapshot? clientSnapshot;
        if (invoice.clientId.isNotEmpty) {
          final clientRef = _firestore
              .collection(_clientsCollection)
              .doc(invoice.clientId);
          clientSnapshot = await transaction.get(clientRef);
        }

        final stockUpdates = _calculateStockUpdates(
          invoice: invoice,
          productSnapshots: productSnapshots,
          isRevert: true,
        );

        double? newClientBalance;
        if (clientSnapshot != null && clientSnapshot.exists) {
          if (invoice.paymentType == InvoicePaymentType.credit) {
            final currentBal =
                ((clientSnapshot.data() as Map<String, dynamic>)['balance']
                        as num?)
                    ?.toDouble() ??
                0.0;
            newClientBalance = _calculateClientBalance(
              currentBalance: currentBal,
              invoice: invoice,
              isRevert: true,
            );
          }
        }

        for (final update in stockUpdates.entries) {
          transaction.update(update.key, {'stock': update.value});
        }

        if (newClientBalance != null && clientSnapshot != null) {
          transaction.update(clientSnapshot.reference, {
            'balance': newClientBalance,
          });
        }

        final invoiceRef = _firestore
            .collection(_invoicesCollection)
            .doc(invoice.id);
        transaction.delete(invoiceRef);
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateInvoice(InvoiceModel newInvoice) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final invoiceRef = _firestore
            .collection(_invoicesCollection)
            .doc(newInvoice.id);
        final invoiceSnapshot = await transaction.get(invoiceRef);

        if (!invoiceSnapshot.exists) {
          throw ServerFailure("Invoice to update not found!");
        }
        final oldInvoice = InvoiceModel.fromFirestore(invoiceSnapshot);

        final allItems = [...oldInvoice.items, ...newInvoice.items];
        final productSnapshots = await _readProducts(transaction, allItems);

        DocumentSnapshot? clientSnapshot;
        if (newInvoice.clientId.isNotEmpty) {
          final clientRef = _firestore
              .collection(_clientsCollection)
              .doc(newInvoice.clientId);
          clientSnapshot = await transaction.get(clientRef);
        }

        final tempStock = <String, double>{};

        double getCurrentStock(String pid) {
          if (tempStock.containsKey(pid)) return tempStock[pid]!;
          final snap = productSnapshots[pid];
          return (snap != null && snap.exists)
              ? ((snap.data() as Map<String, dynamic>)['stock'] as num?)
                        ?.toDouble() ??
                    0.0
              : 0.0;
        }

        for (final item in oldInvoice.items) {
          final current = getCurrentStock(item.productId);
          final change = _calculateSingleItemChange(
            item,
            oldInvoice.type,
            isRevert: true,
          );
          tempStock[item.productId] = current + change;
        }

        for (final item in newInvoice.items) {
          final current = getCurrentStock(item.productId);
          final change = _calculateSingleItemChange(
            item,
            newInvoice.type,
            isRevert: false,
          );
          if (change < 0 && (current + change) < 0) {
            throw ServerFailure(
              "Insufficient stock for product: ${item.productName}",
            );
          }
          tempStock[item.productId] = current + change;
        }

        double? finalClientBalance;
        if (clientSnapshot != null && clientSnapshot.exists) {
          double currentBalance =
              ((clientSnapshot.data() as Map<String, dynamic>)['balance']
                      as num?)
                  ?.toDouble() ??
              0.0;
          if (oldInvoice.paymentType == InvoicePaymentType.credit) {
            currentBalance = _calculateNewBalanceFromBase(
              currentBalance,
              oldInvoice,
              isRevert: true,
            );
          }
          if (newInvoice.paymentType == InvoicePaymentType.credit) {
            finalClientBalance = _calculateNewBalanceFromBase(
              currentBalance,
              newInvoice,
              isRevert: false,
            );
          } else {
            finalClientBalance = currentBalance;
          }
        }

        for (final entry in tempStock.entries) {
          final snap = productSnapshots[entry.key];
          if (snap != null && snap.exists) {
            transaction.update(snap.reference, {'stock': entry.value});
          }
        }

        if (finalClientBalance != null && clientSnapshot != null) {
          transaction.update(clientSnapshot.reference, {
            'balance': finalClientBalance,
          });
        }

        transaction.update(invoiceRef, newInvoice.toJson());
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // --- Helper Methods (Internal) ---

  String _getCounterFieldName(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return 'sales_counter';
      case InvoiceType.purchase:
        return 'purchase_counter';
      case InvoiceType.salesReturn:
        return 'sales_return_counter';
      case InvoiceType.purchaseReturn:
        return 'purchase_return_counter';
    }
  }

  Future<Map<String, DocumentSnapshot>> _readProducts(
    Transaction t,
    List<dynamic> items,
  ) async {
    final snapshots = <String, DocumentSnapshot>{};
    final uniqueIds = items.map((e) => e.productId).toSet();
    for (final pid in uniqueIds) {
      final ref = _firestore.collection(_productsCollection).doc(pid);
      snapshots[pid] = await t.get(ref);
    }
    return snapshots;
  }

  Map<DocumentReference, double> _calculateStockUpdates({
    required InvoiceModel invoice,
    required Map<String, DocumentSnapshot> productSnapshots,
    required bool isRevert,
  }) {
    final updates = <DocumentReference, double>{};
    for (final item in invoice.items) {
      final snapshot = productSnapshots[item.productId];
      if (snapshot == null || !snapshot.exists) {
        if (isRevert) continue;
        throw ServerFailure("Product ${item.productName} not found!");
      }
      final currentStock =
          ((snapshot.data() as Map<String, dynamic>)['stock'] as num?)
              ?.toDouble() ??
          0.0;
      final change = _calculateSingleItemChange(
        item,
        invoice.type,
        isRevert: isRevert,
      );
      final newStock = currentStock + change;
      if (newStock < 0) {
        throw ServerFailure(
          "Insufficient stock for product: ${item.productName}. Available: $currentStock",
        );
      }
      updates[snapshot.reference] = newStock;
    }
    return updates;
  }

  double _calculateSingleItemChange(
    dynamic item,
    InvoiceType type, {
    required bool isRevert,
  }) {
    final qty = item.quantity * item.conversionFactor;
    bool isStockOut =
        (type == InvoiceType.sales || type == InvoiceType.purchaseReturn);
    if (isRevert) isStockOut = !isStockOut;
    return isStockOut ? -qty : qty;
  }

  double _calculateClientBalance({
    required double currentBalance,
    required InvoiceModel invoice,
    required bool isRevert,
  }) {
    return _calculateNewBalanceFromBase(
      currentBalance,
      invoice,
      isRevert: isRevert,
    );
  }

  double _calculateNewBalanceFromBase(
    double baseBalance,
    InvoiceModel invoice, {
    required bool isRevert,
  }) {
    final remaining = invoice.totalAmount - invoice.paidAmount;
    if (remaining == 0) return baseBalance;
    double impact = remaining;
    if (invoice.type == InvoiceType.sales) {
      impact = remaining;
    } else if (invoice.type == InvoiceType.salesReturn) {
      impact = -remaining;
    } else if (invoice.type == InvoiceType.purchase) {
      impact = -remaining;
    } else if (invoice.type == InvoiceType.purchaseReturn) {
      impact = remaining;
    }
    if (isRevert) impact = -impact;
    return baseBalance + impact;
  }
}
