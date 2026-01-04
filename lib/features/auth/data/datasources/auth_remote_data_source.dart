import 'dart:developer'; // للإستخدام log
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  /// Stream to listen to auth state changes in real-time
  Stream<UserModel?> getUserStream(); 
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    log('1. [AuthDataSource] Attempting login for: $email');
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      log('2. [AuthDataSource] Firebase responded. User: ${userCredential.user?.uid}');

      if (userCredential.user == null) {
        throw const ServerFailure('User not found after login');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      log('X. [AuthDataSource] Firebase Exception: ${e.code} - ${e.message}');
      throw ServerFailure(_mapFirebaseError(e.code));
    } catch (e) {
      log('X. [AuthDataSource] General Exception: $e');
      throw const ServerFailure('Unexpected Error');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  @override
  Stream<UserModel?> getUserStream() {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'auth/user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'auth/wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
      case 'auth/invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
      case 'auth/user-disabled':
        return 'This user has been disabled.';
      case 'invalid-credential':
      case 'auth/invalid-credential':
        return 'Invalid credentials provided.'; 
      default:
        return 'Authentication Error: $code';
    }
  }
}