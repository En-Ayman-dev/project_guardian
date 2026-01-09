// [phase_3] correction - File 3/4
// file: lib/features/clients_suppliers/data/datasources/client_supplier_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/enums/client_type.dart';
import '../models/client_supplier_model.dart';

abstract class ClientSupplierRemoteDataSource {
  Future<List<ClientSupplierModel>> getClientsSuppliers(ClientType type);
  Future<void> addClientSupplier(ClientSupplierModel model);
  Future<void> updateClientSupplier(ClientSupplierModel model);
  Future<void> deleteClientSupplier(String id);
  // [FIX] إضافة الدالة الناقصة
  Future<ClientSupplierModel> getClientById(String id);
}

@LazySingleton(as: ClientSupplierRemoteDataSource)
class ClientSupplierRemoteDataSourceImpl implements ClientSupplierRemoteDataSource {
  final FirebaseFirestore _firestore;

  ClientSupplierRemoteDataSourceImpl(this._firestore);

  // اسم المجموعة في قاعدة البيانات
  static const String _collectionName = 'clients_suppliers';

  @override
  Future<List<ClientSupplierModel>> getClientsSuppliers(ClientType type) async {
    try {
      // نحول الـ Enum إلى String للمقارنة في Firestore (client أو supplier)
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('type', isEqualTo: type.name) 
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ClientSupplierModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addClientSupplier(ClientSupplierModel model) async {
    try {
      // نستخدم toJson لحفظ البيانات، Firestore سينشئ ID تلقائي
      await _firestore.collection(_collectionName).add(model.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateClientSupplier(ClientSupplierModel model) async {
    try {
      if (model.id == null || model.id!.isEmpty) {
        throw const ServerFailure("Invalid ID for update");
      }
      await _firestore.collection(_collectionName).doc(model.id).update(model.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteClientSupplier(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // [FIX] تنفيذ الدالة الناقصة
  @override
  Future<ClientSupplierModel> getClientById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();
      if (doc.exists) {
        return ClientSupplierModel.fromFirestore(doc);
      } else {
        throw const ServerFailure("Client not found");
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}