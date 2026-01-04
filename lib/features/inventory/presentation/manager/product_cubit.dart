import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  ProductCubit(
    this._getProductsUseCase,
    this._addProductUseCase,
    this._updateProductUseCase,
    this._deleteProductUseCase,
  ) : super(const ProductState());

  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true, errorMessage: null,isActionSuccess: false));
    
    final result = await _getProductsUseCase();
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) => emit(state.copyWith(isLoading: false, products: products)),
    );
  }
Future<void> addProduct(ProductEntity product) async {
    // 1. تصفير الحالة السابقة
    emit(state.copyWith(isLoading: true, isActionSuccess: false, errorMessage: null));
    
    final result = await _addProductUseCase(product);
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        // 2. إصدار حالة النجاح فقط، ولا نستدعي loadProducts هنا لأن الصفحة ستغلق
        emit(state.copyWith(isLoading: false, isActionSuccess: true));
      },
    );
  }

  Future<void> updateProduct(ProductEntity product) async {
    emit(state.copyWith(isLoading: true, isActionSuccess: false, errorMessage: null));

    final result = await _updateProductUseCase(product);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        // نفس الشيء، لا نحتاج لإعادة التحميل هنا
        emit(state.copyWith(isLoading: false, isActionSuccess: true));
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    emit(state.copyWith(isLoading: true, isActionSuccess: false, errorMessage: null));

    final result = await _deleteProductUseCase(id);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isActionSuccess: true));
        loadProducts();
      },
    );
  }

  void resetActionState() {
    emit(state.copyWith(isActionSuccess: false, errorMessage: null));
  }
}