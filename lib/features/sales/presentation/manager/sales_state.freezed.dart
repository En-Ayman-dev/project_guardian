// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalesState {

 bool get isLoading;// البيانات المرجعية (Reference Data)
 List<ProductEntity> get products; List<ClientSupplierEntity> get clients;// بيانات العملية الحالية (Transaction Data)
 InvoiceType get invoiceType;// نوع الفاتورة الحالي
 List<InvoiceItemEntity> get cartItems;// الحسابات المالية (Financials)
 double get subTotal; double get discount;// الخصم
 double get tax; double get totalAmount; double get paidAmount;// المبلغ المدفوع (للآجل/النقدي)
// حالة التحكم (Control State)
 String? get errorMessage; bool get isSuccess;
/// Create a copy of SalesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesStateCopyWith<SalesState> get copyWith => _$SalesStateCopyWithImpl<SalesState>(this as SalesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.clients, clients)&&(identical(other.invoiceType, invoiceType) || other.invoiceType == invoiceType)&&const DeepCollectionEquality().equals(other.cartItems, cartItems)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(clients),invoiceType,const DeepCollectionEquality().hash(cartItems),subTotal,discount,tax,totalAmount,paidAmount,errorMessage,isSuccess);

@override
String toString() {
  return 'SalesState(isLoading: $isLoading, products: $products, clients: $clients, invoiceType: $invoiceType, cartItems: $cartItems, subTotal: $subTotal, discount: $discount, tax: $tax, totalAmount: $totalAmount, paidAmount: $paidAmount, errorMessage: $errorMessage, isSuccess: $isSuccess)';
}


}

/// @nodoc
abstract mixin class $SalesStateCopyWith<$Res>  {
  factory $SalesStateCopyWith(SalesState value, $Res Function(SalesState) _then) = _$SalesStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<ProductEntity> products, List<ClientSupplierEntity> clients, InvoiceType invoiceType, List<InvoiceItemEntity> cartItems, double subTotal, double discount, double tax, double totalAmount, double paidAmount, String? errorMessage, bool isSuccess
});




}
/// @nodoc
class _$SalesStateCopyWithImpl<$Res>
    implements $SalesStateCopyWith<$Res> {
  _$SalesStateCopyWithImpl(this._self, this._then);

  final SalesState _self;
  final $Res Function(SalesState) _then;

/// Create a copy of SalesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? products = null,Object? clients = null,Object? invoiceType = null,Object? cartItems = null,Object? subTotal = null,Object? discount = null,Object? tax = null,Object? totalAmount = null,Object? paidAmount = null,Object? errorMessage = freezed,Object? isSuccess = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,clients: null == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as List<ClientSupplierEntity>,invoiceType: null == invoiceType ? _self.invoiceType : invoiceType // ignore: cast_nullable_to_non_nullable
as InvoiceType,cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<InvoiceItemEntity>,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesState].
extension SalesStatePatterns on SalesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesState value)  $default,){
final _that = this;
switch (_that) {
case _SalesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesState value)?  $default,){
final _that = this;
switch (_that) {
case _SalesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<ProductEntity> products,  List<ClientSupplierEntity> clients,  InvoiceType invoiceType,  List<InvoiceItemEntity> cartItems,  double subTotal,  double discount,  double tax,  double totalAmount,  double paidAmount,  String? errorMessage,  bool isSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesState() when $default != null:
return $default(_that.isLoading,_that.products,_that.clients,_that.invoiceType,_that.cartItems,_that.subTotal,_that.discount,_that.tax,_that.totalAmount,_that.paidAmount,_that.errorMessage,_that.isSuccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<ProductEntity> products,  List<ClientSupplierEntity> clients,  InvoiceType invoiceType,  List<InvoiceItemEntity> cartItems,  double subTotal,  double discount,  double tax,  double totalAmount,  double paidAmount,  String? errorMessage,  bool isSuccess)  $default,) {final _that = this;
switch (_that) {
case _SalesState():
return $default(_that.isLoading,_that.products,_that.clients,_that.invoiceType,_that.cartItems,_that.subTotal,_that.discount,_that.tax,_that.totalAmount,_that.paidAmount,_that.errorMessage,_that.isSuccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<ProductEntity> products,  List<ClientSupplierEntity> clients,  InvoiceType invoiceType,  List<InvoiceItemEntity> cartItems,  double subTotal,  double discount,  double tax,  double totalAmount,  double paidAmount,  String? errorMessage,  bool isSuccess)?  $default,) {final _that = this;
switch (_that) {
case _SalesState() when $default != null:
return $default(_that.isLoading,_that.products,_that.clients,_that.invoiceType,_that.cartItems,_that.subTotal,_that.discount,_that.tax,_that.totalAmount,_that.paidAmount,_that.errorMessage,_that.isSuccess);case _:
  return null;

}
}

}

/// @nodoc


class _SalesState implements SalesState {
  const _SalesState({this.isLoading = false, final  List<ProductEntity> products = const [], final  List<ClientSupplierEntity> clients = const [], this.invoiceType = InvoiceType.sales, final  List<InvoiceItemEntity> cartItems = const [], this.subTotal = 0.0, this.discount = 0.0, this.tax = 0.0, this.totalAmount = 0.0, this.paidAmount = 0.0, this.errorMessage, this.isSuccess = false}): _products = products,_clients = clients,_cartItems = cartItems;
  

@override@JsonKey() final  bool isLoading;
// البيانات المرجعية (Reference Data)
 final  List<ProductEntity> _products;
// البيانات المرجعية (Reference Data)
@override@JsonKey() List<ProductEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<ClientSupplierEntity> _clients;
@override@JsonKey() List<ClientSupplierEntity> get clients {
  if (_clients is EqualUnmodifiableListView) return _clients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clients);
}

// بيانات العملية الحالية (Transaction Data)
@override@JsonKey() final  InvoiceType invoiceType;
// نوع الفاتورة الحالي
 final  List<InvoiceItemEntity> _cartItems;
// نوع الفاتورة الحالي
@override@JsonKey() List<InvoiceItemEntity> get cartItems {
  if (_cartItems is EqualUnmodifiableListView) return _cartItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartItems);
}

// الحسابات المالية (Financials)
@override@JsonKey() final  double subTotal;
@override@JsonKey() final  double discount;
// الخصم
@override@JsonKey() final  double tax;
@override@JsonKey() final  double totalAmount;
@override@JsonKey() final  double paidAmount;
// المبلغ المدفوع (للآجل/النقدي)
// حالة التحكم (Control State)
@override final  String? errorMessage;
@override@JsonKey() final  bool isSuccess;

/// Create a copy of SalesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesStateCopyWith<_SalesState> get copyWith => __$SalesStateCopyWithImpl<_SalesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._clients, _clients)&&(identical(other.invoiceType, invoiceType) || other.invoiceType == invoiceType)&&const DeepCollectionEquality().equals(other._cartItems, _cartItems)&&(identical(other.subTotal, subTotal) || other.subTotal == subTotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_clients),invoiceType,const DeepCollectionEquality().hash(_cartItems),subTotal,discount,tax,totalAmount,paidAmount,errorMessage,isSuccess);

@override
String toString() {
  return 'SalesState(isLoading: $isLoading, products: $products, clients: $clients, invoiceType: $invoiceType, cartItems: $cartItems, subTotal: $subTotal, discount: $discount, tax: $tax, totalAmount: $totalAmount, paidAmount: $paidAmount, errorMessage: $errorMessage, isSuccess: $isSuccess)';
}


}

/// @nodoc
abstract mixin class _$SalesStateCopyWith<$Res> implements $SalesStateCopyWith<$Res> {
  factory _$SalesStateCopyWith(_SalesState value, $Res Function(_SalesState) _then) = __$SalesStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<ProductEntity> products, List<ClientSupplierEntity> clients, InvoiceType invoiceType, List<InvoiceItemEntity> cartItems, double subTotal, double discount, double tax, double totalAmount, double paidAmount, String? errorMessage, bool isSuccess
});




}
/// @nodoc
class __$SalesStateCopyWithImpl<$Res>
    implements _$SalesStateCopyWith<$Res> {
  __$SalesStateCopyWithImpl(this._self, this._then);

  final _SalesState _self;
  final $Res Function(_SalesState) _then;

/// Create a copy of SalesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? products = null,Object? clients = null,Object? invoiceType = null,Object? cartItems = null,Object? subTotal = null,Object? discount = null,Object? tax = null,Object? totalAmount = null,Object? paidAmount = null,Object? errorMessage = freezed,Object? isSuccess = null,}) {
  return _then(_SalesState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,clients: null == clients ? _self._clients : clients // ignore: cast_nullable_to_non_nullable
as List<ClientSupplierEntity>,invoiceType: null == invoiceType ? _self.invoiceType : invoiceType // ignore: cast_nullable_to_non_nullable
as InvoiceType,cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<InvoiceItemEntity>,subTotal: null == subTotal ? _self.subTotal : subTotal // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
