// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_supplier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientSupplierModel {

@JsonKey(includeFromJson: false, includeToJson: false) String? get id; String get name; String get phone; String? get email; String? get address; String? get taxNumber; ClientType get type; double get balance;@TimestampConverter() DateTime get createdAt;
/// Create a copy of ClientSupplierModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSupplierModelCopyWith<ClientSupplierModel> get copyWith => _$ClientSupplierModelCopyWithImpl<ClientSupplierModel>(this as ClientSupplierModel, _$identity);

  /// Serializes this ClientSupplierModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSupplierModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.taxNumber, taxNumber) || other.taxNumber == taxNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,address,taxNumber,type,balance,createdAt);

@override
String toString() {
  return 'ClientSupplierModel(id: $id, name: $name, phone: $phone, email: $email, address: $address, taxNumber: $taxNumber, type: $type, balance: $balance, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ClientSupplierModelCopyWith<$Res>  {
  factory $ClientSupplierModelCopyWith(ClientSupplierModel value, $Res Function(ClientSupplierModel) _then) = _$ClientSupplierModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String name, String phone, String? email, String? address, String? taxNumber, ClientType type, double balance,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$ClientSupplierModelCopyWithImpl<$Res>
    implements $ClientSupplierModelCopyWith<$Res> {
  _$ClientSupplierModelCopyWithImpl(this._self, this._then);

  final ClientSupplierModel _self;
  final $Res Function(ClientSupplierModel) _then;

/// Create a copy of ClientSupplierModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? taxNumber = freezed,Object? type = null,Object? balance = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,taxNumber: freezed == taxNumber ? _self.taxNumber : taxNumber // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ClientType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSupplierModel].
extension ClientSupplierModelPatterns on ClientSupplierModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSupplierModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSupplierModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSupplierModel value)  $default,){
final _that = this;
switch (_that) {
case _ClientSupplierModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSupplierModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSupplierModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String name,  String phone,  String? email,  String? address,  String? taxNumber,  ClientType type,  double balance, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSupplierModel() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.address,_that.taxNumber,_that.type,_that.balance,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String name,  String phone,  String? email,  String? address,  String? taxNumber,  ClientType type,  double balance, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ClientSupplierModel():
return $default(_that.id,_that.name,_that.phone,_that.email,_that.address,_that.taxNumber,_that.type,_that.balance,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String name,  String phone,  String? email,  String? address,  String? taxNumber,  ClientType type,  double balance, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ClientSupplierModel() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.address,_that.taxNumber,_that.type,_that.balance,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSupplierModel extends ClientSupplierModel {
  const _ClientSupplierModel({@JsonKey(includeFromJson: false, includeToJson: false) this.id, required this.name, required this.phone, this.email, this.address, this.taxNumber, required this.type, this.balance = 0.0, @TimestampConverter() required this.createdAt}): super._();
  factory _ClientSupplierModel.fromJson(Map<String, dynamic> json) => _$ClientSupplierModelFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? id;
@override final  String name;
@override final  String phone;
@override final  String? email;
@override final  String? address;
@override final  String? taxNumber;
@override final  ClientType type;
@override@JsonKey() final  double balance;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of ClientSupplierModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSupplierModelCopyWith<_ClientSupplierModel> get copyWith => __$ClientSupplierModelCopyWithImpl<_ClientSupplierModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSupplierModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSupplierModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.taxNumber, taxNumber) || other.taxNumber == taxNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,address,taxNumber,type,balance,createdAt);

@override
String toString() {
  return 'ClientSupplierModel(id: $id, name: $name, phone: $phone, email: $email, address: $address, taxNumber: $taxNumber, type: $type, balance: $balance, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ClientSupplierModelCopyWith<$Res> implements $ClientSupplierModelCopyWith<$Res> {
  factory _$ClientSupplierModelCopyWith(_ClientSupplierModel value, $Res Function(_ClientSupplierModel) _then) = __$ClientSupplierModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String name, String phone, String? email, String? address, String? taxNumber, ClientType type, double balance,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$ClientSupplierModelCopyWithImpl<$Res>
    implements _$ClientSupplierModelCopyWith<$Res> {
  __$ClientSupplierModelCopyWithImpl(this._self, this._then);

  final _ClientSupplierModel _self;
  final $Res Function(_ClientSupplierModel) _then;

/// Create a copy of ClientSupplierModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? taxNumber = freezed,Object? type = null,Object? balance = null,Object? createdAt = null,}) {
  return _then(_ClientSupplierModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,taxNumber: freezed == taxNumber ? _self.taxNumber : taxNumber // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ClientType,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
