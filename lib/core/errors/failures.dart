import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// أخطاء السيرفر (Firebase)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// أخطاء الاتصال
class NetworkFailure extends Failure {
  const NetworkFailure() : super('No Internet Connection');
}

// أخطاء المصادقة
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// أخطاء البيانات المحلية / الكاش
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}