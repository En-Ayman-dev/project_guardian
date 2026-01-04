import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String role; // admin, accountant, viewer

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.role = 'user',
  });

  @override
  List<Object?> get props => [uid, email, name, role];
}