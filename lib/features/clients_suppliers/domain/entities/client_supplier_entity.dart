import 'package:equatable/equatable.dart';
import 'enums/client_type.dart';

class ClientSupplierEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? taxNumber; // الرقم الضريبي (مهم للفواتير)
  final ClientType type;
  final double balance; // الرصيد (موجب = لنا، سالب = علينا)
  final DateTime createdAt;

  const ClientSupplierEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.taxNumber,
    required this.type,
    this.balance = 0.0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, phone, email, address, taxNumber, type, balance, createdAt];
}