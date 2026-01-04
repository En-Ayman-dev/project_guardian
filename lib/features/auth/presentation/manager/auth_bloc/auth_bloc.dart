import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _userSubscription;

  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<_AuthCheckRequested>(_onAuthCheckRequested);
    on<_SignedOut>(_onSignedOut);
    on<_UserChanged>(_onUserChanged); // تسجيل معالج الحدث الجديد
  }

  Future<void> _onAuthCheckRequested(
    _AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // إلغاء الاشتراك السابق إن وجد لتفادي التكرار
    await _userSubscription?.cancel();
    
    // البدء بالاستماع المباشر للتغيرات
    _userSubscription = _authRepository.getUserStream().listen((user) {
      add(AuthEvent.userChanged(user));
    });
  }

  Future<void> _onUserChanged(
    _UserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignedOut(
    _SignedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    // لا نحتاج لعمل emit هنا يدوياً، لأن الـ Stream سيشعر بالخروج ويطلق حدث userChanged(null)
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}