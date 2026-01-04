import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.login(email, password);
      return Right(userModel.toEntity());
    } on ServerFailure catch (e) {
      return Left(e); 
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Logout Failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      if (userModel != null) {
        return Right(userModel.toEntity());
      } else {
        return const Left(AuthFailure('No user logged in'));
      }
    } catch (e) {
      return const Left(ServerFailure('Failed to get current user'));
    }
  }

  // التعديل الجديد
  @override
  Stream<UserEntity?> getUserStream() {
    return _remoteDataSource.getUserStream().map((userModel) {
      return userModel?.toEntity();
    });
  }
}