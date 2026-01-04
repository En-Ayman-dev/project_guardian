import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch products'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(String barcode) async {
    try {
      final model = await _remoteDataSource.getProductByBarcode(barcode);
      return Right(model?.toEntity());
    } catch (e) {
      return const Left(ServerFailure('Failed to search product'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductEntity product) async {
    try {
      await _remoteDataSource.addProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to add product'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductEntity product) async {
    try {
      await _remoteDataSource.updateProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to update product'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _remoteDataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to delete product'));
    }
  }
}