import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../models/category_model.dart';
import '../models/unit_model.dart';

abstract class InventoryRemoteDataSource {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(CategoryModel category); // أضف هذا

  // Units
  Future<List<UnitModel>> getUnits();
  Future<void> addUnit(UnitModel unit);
  Future<void> deleteUnit(String id);
  Future<void> updateUnit(UnitModel unit); // أضف هذا
}

@LazySingleton(as: InventoryRemoteDataSource)
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  InventoryRemoteDataSourceImpl(this._firestore);

  // أسماء المجموعات في Firestore
  static const String _categoriesCollection = 'categories';
  static const String _unitsCollection = 'units';

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

  // Implementation for Unit Update
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
}
