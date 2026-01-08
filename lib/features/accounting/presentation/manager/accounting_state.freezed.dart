// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountingState()';
}


}

/// @nodoc
class $AccountingStateCopyWith<$Res>  {
$AccountingStateCopyWith(AccountingState _, $Res Function(AccountingState) __);
}


/// Adds pattern-matching-related methods to [AccountingState].
extension AccountingStatePatterns on AccountingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,TResult Function( _InvoiceLookupLoading value)?  invoiceLookupLoading,TResult Function( _InvoiceLookupSuccess value)?  invoiceLookupSuccess,TResult Function( _InvoiceLookupError value)?  invoiceLookupError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _InvoiceLookupLoading() when invoiceLookupLoading != null:
return invoiceLookupLoading(_that);case _InvoiceLookupSuccess() when invoiceLookupSuccess != null:
return invoiceLookupSuccess(_that);case _InvoiceLookupError() when invoiceLookupError != null:
return invoiceLookupError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,required TResult Function( _InvoiceLookupLoading value)  invoiceLookupLoading,required TResult Function( _InvoiceLookupSuccess value)  invoiceLookupSuccess,required TResult Function( _InvoiceLookupError value)  invoiceLookupError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _InvoiceLookupLoading():
return invoiceLookupLoading(_that);case _InvoiceLookupSuccess():
return invoiceLookupSuccess(_that);case _InvoiceLookupError():
return invoiceLookupError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,TResult? Function( _InvoiceLookupLoading value)?  invoiceLookupLoading,TResult? Function( _InvoiceLookupSuccess value)?  invoiceLookupSuccess,TResult? Function( _InvoiceLookupError value)?  invoiceLookupError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _InvoiceLookupLoading() when invoiceLookupLoading != null:
return invoiceLookupLoading(_that);case _InvoiceLookupSuccess() when invoiceLookupSuccess != null:
return invoiceLookupSuccess(_that);case _InvoiceLookupError() when invoiceLookupError != null:
return invoiceLookupError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function( List<VoucherEntity> vouchers)?  loaded,TResult Function( String message)?  error,TResult Function()?  invoiceLookupLoading,TResult Function( double remainingAmount,  String invoiceNumber)?  invoiceLookupSuccess,TResult Function( String message)?  invoiceLookupError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success();case _Loaded() when loaded != null:
return loaded(_that.vouchers);case _Error() when error != null:
return error(_that.message);case _InvoiceLookupLoading() when invoiceLookupLoading != null:
return invoiceLookupLoading();case _InvoiceLookupSuccess() when invoiceLookupSuccess != null:
return invoiceLookupSuccess(_that.remainingAmount,_that.invoiceNumber);case _InvoiceLookupError() when invoiceLookupError != null:
return invoiceLookupError(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function( List<VoucherEntity> vouchers)  loaded,required TResult Function( String message)  error,required TResult Function()  invoiceLookupLoading,required TResult Function( double remainingAmount,  String invoiceNumber)  invoiceLookupSuccess,required TResult Function( String message)  invoiceLookupError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success();case _Loaded():
return loaded(_that.vouchers);case _Error():
return error(_that.message);case _InvoiceLookupLoading():
return invoiceLookupLoading();case _InvoiceLookupSuccess():
return invoiceLookupSuccess(_that.remainingAmount,_that.invoiceNumber);case _InvoiceLookupError():
return invoiceLookupError(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( List<VoucherEntity> vouchers)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  invoiceLookupLoading,TResult? Function( double remainingAmount,  String invoiceNumber)?  invoiceLookupSuccess,TResult? Function( String message)?  invoiceLookupError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success();case _Loaded() when loaded != null:
return loaded(_that.vouchers);case _Error() when error != null:
return error(_that.message);case _InvoiceLookupLoading() when invoiceLookupLoading != null:
return invoiceLookupLoading();case _InvoiceLookupSuccess() when invoiceLookupSuccess != null:
return invoiceLookupSuccess(_that.remainingAmount,_that.invoiceNumber);case _InvoiceLookupError() when invoiceLookupError != null:
return invoiceLookupError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AccountingState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountingState.initial()';
}


}




/// @nodoc


class _Loading implements AccountingState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountingState.loading()';
}


}




/// @nodoc


class _Success implements AccountingState {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountingState.success()';
}


}




/// @nodoc


class _Loaded implements AccountingState {
  const _Loaded(final  List<VoucherEntity> vouchers): _vouchers = vouchers;
  

 final  List<VoucherEntity> _vouchers;
 List<VoucherEntity> get vouchers {
  if (_vouchers is EqualUnmodifiableListView) return _vouchers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vouchers);
}


/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._vouchers, _vouchers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_vouchers));

@override
String toString() {
  return 'AccountingState.loaded(vouchers: $vouchers)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $AccountingStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<VoucherEntity> vouchers
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? vouchers = null,}) {
  return _then(_Loaded(
null == vouchers ? _self._vouchers : vouchers // ignore: cast_nullable_to_non_nullable
as List<VoucherEntity>,
  ));
}


}

/// @nodoc


class _Error implements AccountingState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AccountingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AccountingStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InvoiceLookupLoading implements AccountingState {
  const _InvoiceLookupLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceLookupLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountingState.invoiceLookupLoading()';
}


}




/// @nodoc


class _InvoiceLookupSuccess implements AccountingState {
  const _InvoiceLookupSuccess(this.remainingAmount, this.invoiceNumber);
  

 final  double remainingAmount;
 final  String invoiceNumber;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceLookupSuccessCopyWith<_InvoiceLookupSuccess> get copyWith => __$InvoiceLookupSuccessCopyWithImpl<_InvoiceLookupSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceLookupSuccess&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber));
}


@override
int get hashCode => Object.hash(runtimeType,remainingAmount,invoiceNumber);

@override
String toString() {
  return 'AccountingState.invoiceLookupSuccess(remainingAmount: $remainingAmount, invoiceNumber: $invoiceNumber)';
}


}

/// @nodoc
abstract mixin class _$InvoiceLookupSuccessCopyWith<$Res> implements $AccountingStateCopyWith<$Res> {
  factory _$InvoiceLookupSuccessCopyWith(_InvoiceLookupSuccess value, $Res Function(_InvoiceLookupSuccess) _then) = __$InvoiceLookupSuccessCopyWithImpl;
@useResult
$Res call({
 double remainingAmount, String invoiceNumber
});




}
/// @nodoc
class __$InvoiceLookupSuccessCopyWithImpl<$Res>
    implements _$InvoiceLookupSuccessCopyWith<$Res> {
  __$InvoiceLookupSuccessCopyWithImpl(this._self, this._then);

  final _InvoiceLookupSuccess _self;
  final $Res Function(_InvoiceLookupSuccess) _then;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remainingAmount = null,Object? invoiceNumber = null,}) {
  return _then(_InvoiceLookupSuccess(
null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double,null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InvoiceLookupError implements AccountingState {
  const _InvoiceLookupError(this.message);
  

 final  String message;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceLookupErrorCopyWith<_InvoiceLookupError> get copyWith => __$InvoiceLookupErrorCopyWithImpl<_InvoiceLookupError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceLookupError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AccountingState.invoiceLookupError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$InvoiceLookupErrorCopyWith<$Res> implements $AccountingStateCopyWith<$Res> {
  factory _$InvoiceLookupErrorCopyWith(_InvoiceLookupError value, $Res Function(_InvoiceLookupError) _then) = __$InvoiceLookupErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$InvoiceLookupErrorCopyWithImpl<$Res>
    implements _$InvoiceLookupErrorCopyWith<$Res> {
  __$InvoiceLookupErrorCopyWithImpl(this._self, this._then);

  final _InvoiceLookupError _self;
  final $Res Function(_InvoiceLookupError) _then;

/// Create a copy of AccountingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_InvoiceLookupError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
