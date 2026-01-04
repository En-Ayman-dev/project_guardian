import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  
  // دالة للبحث عن منتج معين عبر الباركود (مهمة لنقطة البيع لاحقاً)
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(String barcode);

  Future<Either<Failure, void>> addProduct(ProductEntity product);
  
  Future<Either<Failure, void>> updateProduct(ProductEntity product);
  
  Future<Either<Failure, void>> deleteProduct(String id);
}