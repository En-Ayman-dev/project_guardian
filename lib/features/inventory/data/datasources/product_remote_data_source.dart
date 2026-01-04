import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductByBarcode(String barcode);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSourceImpl(this._firestore);

  static const String _collection = 'products';

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return ProductModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection(_collection).add(product.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      if (product.id == null || product.id!.isEmpty) {
        throw const ServerFailure("Invalid ID for update");
      }
      await _firestore.collection(_collection).doc(product.id).update(product.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}