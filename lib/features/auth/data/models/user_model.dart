import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._(); // مطلوب لإضافة دوال أو خصائص مخصصة

  const factory UserModel({
    required String uid,
    required String email,
    required String name,
    @Default('user') String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Factory لتحويل FirebaseUser مباشرة إلى UserModel
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'No Name',
      role: 'user', // سنقوم بجلب الدور لاحقاً من Firestore إذا لزم الأمر
    );
  }

  // دالة التحويل إلى Entity (التي تستخدمها طبقة الـ Domain)
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      role: role,
    );
  }
}