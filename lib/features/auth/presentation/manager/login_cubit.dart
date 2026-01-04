import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  Future<void> loginSubmitted({required String email, required String password}) async {
    // 1. بدء التحميل
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    // 2. استدعاء الـ UseCase
    final result = await _loginUseCase(email, password);

    // 3. معالجة النتيجة
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      },
    );
  }
}