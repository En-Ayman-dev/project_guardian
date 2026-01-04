part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckRequested() = _AuthCheckRequested;
  const factory AuthEvent.signedOut() = _SignedOut;
  /// حدث داخلي يتم إطلاقه عند تغير حالة المستخدم من الـ Stream
  const factory AuthEvent.userChanged(UserEntity? user) = _UserChanged;
}