import 'package:equatable/equatable.dart';

class UnitEntity extends Equatable {
  final String id;
  final String name;

  const UnitEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}