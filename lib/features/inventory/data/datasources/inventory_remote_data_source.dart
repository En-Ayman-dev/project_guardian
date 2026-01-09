// [phase_3] correction - File 2/4
// file: lib/features/inventory/data/datasources/inventory_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../models/category_model.dart';
import '../models/unit_model.dart';
import '../models/product_model.dart'; // [FIX] Import ProductModel

abstract class InventoryRemoteDataSource {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(CategoryModel category);

  // Units
  Future<List<UnitModel>> getUnits();
  Future<void> addUnit(UnitModel unit);
  Future<void> deleteUnit(String id);
  Future<void> updateUnit(UnitModel unit);

  // Products [FIX] تمت إضافة هذه الدالة
  Future<List<ProductModel>> getAllProducts();
}

@LazySingleton(as: InventoryRemoteDataSource)
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  InventoryRemoteDataSourceImpl(this._firestore);

  // أسماء المجموعات في Firestore
  static const String _categoriesCollection = 'categories';
  static const String _unitsCollection = 'units';
  static const String _productsCollection = 'products'; // [FIX] اسم الكولكشن

  // --- Categories Impl ---
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection(_categoriesCollection)
          .orderBy('name')
          .get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      await _firestore.collection(_categoriesCollection).add(category.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection(_categoriesCollection).doc(id).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection(_categoriesCollection)
          .doc(category.id)
          .update(category.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // --- Units Impl ---
  @override
  Future<List<UnitModel>> getUnits() async {
    try {
      final snapshot = await _firestore
          .collection(_unitsCollection)
          .orderBy('name')
          .get();
      return snapshot.docs.map((doc) => UnitModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addUnit(UnitModel unit) async {
    try {
      await _firestore.collection(_unitsCollection).add(unit.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteUnit(String id) async {
    try {
      await _firestore.collection(_unitsCollection).doc(id).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateUnit(UnitModel unit) async {
    try {
      await _firestore
          .collection(_unitsCollection)
          .doc(unit.id)
          .update(unit.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // --- Products Impl [FIX] ---
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _firestore.collection(_productsCollection).get();
      // نفترض أن ProductModel يحتوي على fromFirestore مثل باقي الموديلات
      // إذا كان اسمه fromSnapshot يرجى تعديله هنا
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}