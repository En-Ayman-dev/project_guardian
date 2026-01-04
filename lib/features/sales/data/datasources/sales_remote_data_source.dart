import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice_entity.dart';
import '../models/invoice_model.dart';

abstract class SalesRemoteDataSource {
  Future<List<InvoiceModel>> getInvoices();
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

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final snapshot = await _firestore
          .collection(_invoicesCollection)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => InvoiceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addInvoice(InvoiceModel invoice) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // --- PHASE 1: READ ---
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

        // --- PHASE 2: CALCULATE ---

        // 1. Calculate Stock Impact
        final stockUpdates = _calculateStockUpdates(
          invoice: invoice,
          productSnapshots: productSnapshots,
          isRevert: false,
        );

        // 2. Calculate Client Balance Impact
        double? newClientBalance;
        if (clientSnapshot != null && clientSnapshot.exists) {
          // التصحيح هنا: تحويل صريح إلى double
          final currentBal =
              ((clientSnapshot.data() as Map<String, dynamic>)['balance']
                      as num?)
                  ?.toDouble() ??
              0.0;

          newClientBalance = _calculateClientBalance(
            currentBalance: currentBal,
            invoice: invoice,
            isRevert: false,
          );
        }

        // --- PHASE 3: WRITE ---

        // 1. Update Products
        for (final update in stockUpdates.entries) {
          transaction.update(update.key, {'stock': update.value});
        }

        // 2. Update Client Balance
        if (newClientBalance != null && clientSnapshot != null) {
          transaction.update(clientSnapshot.reference, {
            'balance': newClientBalance,
          });
        }

        // 3. Save Invoice
        final invoiceRef = _firestore
            .collection(_invoicesCollection)
            .doc(invoice.id);
        transaction.set(invoiceRef, invoice.toJson());
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteInvoice(InvoiceModel invoice) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // --- PHASE 1: READ ---
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

        // --- PHASE 2: CALCULATE ---

        // 1. Revert Stock
        final stockUpdates = _calculateStockUpdates(
          invoice: invoice,
          productSnapshots: productSnapshots,
          isRevert: true,
        );

        // 2. Revert Client Balance
        double? newClientBalance;
        if (clientSnapshot != null && clientSnapshot.exists) {
          // التصحيح هنا: تحويل صريح إلى double
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

        // --- PHASE 3: WRITE ---

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
        // --- PHASE 1: READ EVERYTHING ---

        // 1. Read Old Invoice
        final invoiceRef = _firestore
            .collection(_invoicesCollection)
            .doc(newInvoice.id);
        final invoiceSnapshot = await transaction.get(invoiceRef);

        if (!invoiceSnapshot.exists) {
          throw ServerFailure("Invoice to update not found!");
        }
        final oldInvoice = InvoiceModel.fromFirestore(invoiceSnapshot);

        // 2. Read Products (Old + New)
        final allItems = [...oldInvoice.items, ...newInvoice.items];
        final productSnapshots = await _readProducts(transaction, allItems);

        // 3. Read Client
        DocumentSnapshot? clientSnapshot;
        if (newInvoice.clientId.isNotEmpty) {
          final clientRef = _firestore
              .collection(_clientsCollection)
              .doc(newInvoice.clientId);
          clientSnapshot = await transaction.get(clientRef);
        }

        // --- PHASE 2: CALCULATE NET IMPACT ---

        final tempStock = <String, double>{};

        // Helper to get current stock safely as double
        double getCurrentStock(String pid) {
          if (tempStock.containsKey(pid)) return tempStock[pid]!;
          final snap = productSnapshots[pid];
          // التصحيح هنا: تحويل صريح إلى double
          return (snap != null && snap.exists)
              ? ((snap.data() as Map<String, dynamic>)['stock'] as num?)
                        ?.toDouble() ??
                    0.0
              : 0.0;
        }

        // Revert Old
        for (final item in oldInvoice.items) {
          final current = getCurrentStock(item.productId);
          final change = _calculateSingleItemChange(
            item,
            oldInvoice.type,
            isRevert: true,
          );
          tempStock[item.productId] = current + change;
        }

        // Apply New
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

        // B. Client Balance Calculation
        double? finalClientBalance;
        if (clientSnapshot != null && clientSnapshot.exists) {
          // التصحيح هنا: تحويل صريح إلى double
          double currentBalance =
              ((clientSnapshot.data() as Map<String, dynamic>)['balance']
                      as num?)
                  ?.toDouble() ??
              0.0;

          // Revert Old Balance Impact
          currentBalance = _calculateNewBalanceFromBase(
            currentBalance,
            oldInvoice,
            isRevert: true,
          );

          // Apply New Balance Impact
          finalClientBalance = _calculateNewBalanceFromBase(
            currentBalance,
            newInvoice,
            isRevert: false,
          );
        }

        // --- PHASE 3: WRITE ---

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

  // --- Helper Methods ---

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

      // التصحيح هنا: تحويل صريح إلى double
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
