// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../models/invoice_model.dart';

abstract class SalesRemoteDataSource {
  Future<List<InvoiceModel>> getInvoices();
  Future<void> addInvoice(InvoiceModel invoice);
}

@LazySingleton(as: SalesRemoteDataSource)
class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final FirebaseFirestore _firestore;

  SalesRemoteDataSourceImpl(this._firestore);

  static const String _invoicesCollection = 'invoices';
  static const String _productsCollection = 'products';
  static const String _clientsCollection = 'clients_suppliers'; // لتحديث رصيد العميل لاحقاً إن أردت

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final snapshot = await _firestore
          .collection(_invoicesCollection)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => InvoiceModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addInvoice(InvoiceModel invoice) async {
    try {
      // نستخدم Transaction لضمان تزامن حفظ الفاتورة مع خصم المخزون
      await _firestore.runTransaction((transaction) async {
        
        // 1. الخصم من المخزون لكل منتج في الفاتورة
        for (final item in invoice.items) {
          final productRef = _firestore.collection(_productsCollection).doc(item.productId);
          final productSnapshot = await transaction.get(productRef);

          if (!productSnapshot.exists) {
            throw ServerFailure("Product ${item.productName} not found!");
          }

          // قراءة المخزون الحالي
          final currentStock = (productSnapshot.data()?['stock'] as num?)?.toDouble() ?? 0.0;
          
          // حساب الكمية المباعة بالوحدة الأساسية
          // الكمية * معامل التحويل (مثلاً 2 كرتون * 24 = 48 حبة)
          final qtyToDeduct = item.quantity * item.conversionFactor;

          final newStock = currentStock - qtyToDeduct;

          // تحديث المخزون في الترانزاكشن
          transaction.update(productRef, {'stock': newStock});
        }

        // 2. حفظ الفاتورة نفسها
        // نستخدم invoice.toJson() الذي سيحول العناصر تلقائياً بفضل explicitToJson
        final invoiceRef = _firestore.collection(_invoicesCollection).doc(); // Auto ID
        transaction.set(invoiceRef, invoice.toJson());
        
        // (اختياري مستقبلاً: هنا يمكن إضافة كود لتحديث رصيد العميل أيضاً)
      });
    } catch (e) {
      // تحويل أي خطأ داخل الترانزاكشن إلى Failure
      throw ServerFailure(e.toString());
    }
  }
}