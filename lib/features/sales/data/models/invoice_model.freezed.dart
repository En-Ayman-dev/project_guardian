// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceModel {

@JsonKey(includeFromJson: false, includeToJson: false) String? get id; String get invoiceNumber; String get clientId; String get clientName;@TimestampConverter() DateTime get date;// القائمة التي تسبب المشكلة إذا لم يكن explicitToJson مفعلاً
 List<InvoiceItemModel> get items; double get subTotal; double get discount; double get tax; double get totalAmount;
/// Create a copy of InvoiceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceModelCopyWith<InvoiceModel> get copyWith => _$InvoiceModelCopyWithImpl<InvoiceModel>(this as InvoiceModel, _$identity);

  /// Serializes this InvoiceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceNumber,clientId,clientName,date,const DeepCollectionEquality().hash(items),subTotal,discount,tax,totalAmount);

@override
String toString() {
  return 'InvoiceModel(id: $id, invoiceNumber: $invoiceNumber, clientId: $clientId, clientName: $clientName, date: $date, items: $items, subTotal: $subTotal, discount: $discount, tax: $tax, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class $InvoiceModelCopyWith<$Res>  {
  factory $InvoiceModelCopyWith(InvoiceModel value, $Res Function(InvoiceModel) _then) = _$InvoiceModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String invoiceNumber, String clientId, String clientName,@TimestampConverter() DateTime date, List<InvoiceItemModel> items, double subTotal, double discount, double tax, double totalAmount
});




}
/// @nodoc
class _$InvoiceModelCopyWithImpl<$Res>
    implements $InvoiceModelCopyWith<$Res> {
  _$InvoiceModelCopyWithImpl(this._self, this._then);

  final InvoiceModel _self;
  final $Res Function(InvoiceModel) _then;

/// Create a copy of InvoiceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? invoiceNumber = null,Object? clientId = null,Object? clientName = null,Object? date = null,Object? items = null,Object? subTotal = null,Object? discount = null,Object? tax = null,Object? totalAmount = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItemModel>,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceModel].
extension InvoiceModelPatterns on InvoiceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceModel value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceModel value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String invoiceNumber,  String clientId,  String clientName, @TimestampConverter()  DateTime date,  List<InvoiceItemModel> items,  double subTotal,  double discount,  double tax,  double totalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceModel() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.clientId,_that.clientName,_that.date,_that.items,_that.subTotal,_that.discount,_that.tax,_that.totalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String invoiceNumber,  String clientId,  String clientName, @TimestampConverter()  DateTime date,  List<InvoiceItemModel> items,  double subTotal,  double discount,  double tax,  double totalAmount)  $default,) {final _that = this;
switch (_that) {
case _InvoiceModel():
return $default(_that.id,_that.invoiceNumber,_that.clientId,_that.clientName,_that.date,_that.items,_that.subTotal,_that.discount,_that.tax,_that.totalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String invoiceNumber,  String clientId,  String clientName, @TimestampConverter()  DateTime date,  List<InvoiceItemModel> items,  double subTotal,  double discount,  double tax,  double totalAmount)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceModel() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.clientId,_that.clientName,_that.date,_that.items,_that.subTotal,_that.discount,_that.tax,_that.totalAmount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InvoiceModel extends InvoiceModel {
  const _InvoiceModel({@JsonKey(includeFromJson: false, includeToJson: false) this.id, required this.invoiceNumber, required this.clientId, required this.clientName, @TimestampConverter() required this.date, required final  List<InvoiceItemModel> items, required this.subTotal, this.discount = 0.0, this.tax = 0.0, required this.totalAmount}): _items = items,super._();
  factory _InvoiceModel.fromJson(Map<String, dynamic> json) => _$InvoiceModelFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? id;
@override final  String invoiceNumber;
@override final  String clientId;
@override final  String clientName;
@override@TimestampConverter() final  DateTime date;
// القائمة التي تسبب المشكلة إذا لم يكن explicitToJson مفعلاً
 final  List<InvoiceItemModel> _items;
// القائمة التي تسبب المشكلة إذا لم يكن explicitToJson مفعلاً
@override List<InvoiceItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double subTotal;
@override@JsonKey() final  double discount;
@override@JsonKey() final  double tax;
@override final  double totalAmount;

/// Create a copy of InvoiceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceModelCopyWith<_InvoiceModel> get copyWith => __$InvoiceModelCopyWithImpl<_InvoiceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceNumber,clientId,clientName,date,const DeepCollectionEquality().hash(_items),subTotal,discount,tax,totalAmount);

@override
String toString() {
  return 'InvoiceModel(id: $id, invoiceNumber: $invoiceNumber, clientId: $clientId, clientName: $clientName, date: $date, items: $items, subTotal: $subTotal, discount: $discount, tax: $tax, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class _$InvoiceModelCopyWith<$Res> implements $InvoiceModelCopyWith<$Res> {
  factory _$InvoiceModelCopyWith(_InvoiceModel value, $Res Function(_InvoiceModel) _then) = __$InvoiceModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String invoiceNumber, String clientId, String clientName,@TimestampConverter() DateTime date, List<InvoiceItemModel> items, double subTotal, double discount, double tax, double totalAmount
});




}
/// @nodoc
class __$InvoiceModelCopyWithImpl<$Res>
    implements _$InvoiceModelCopyWith<$Res> {
  __$InvoiceModelCopyWithImpl(this._self, this._then);

  final _InvoiceModel _self;
  final $Res Function(_InvoiceModel) _then;

/// Create a copy of InvoiceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? invoiceNumber = null,Object? clientId = null,Object? clientName = null,Object? date = null,Object? items = null,Object? subTotal = null,Object? discount = null,Object? tax = null,Object? totalAmount = null,}) {
  return _then(_InvoiceModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItemModel>,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
