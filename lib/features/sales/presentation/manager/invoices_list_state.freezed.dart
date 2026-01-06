// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoices_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoicesListState {

 bool get isLoading; List<InvoiceEntity> get allInvoices;// المصدر الرئيسي
 List<InvoiceEntity> get filteredInvoices;// المعروض
 InvoiceType get filterType;// التبويب
 String get searchQuery;// [NEW] نص البحث
 String? get errorMessage;
/// Create a copy of InvoicesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicesListStateCopyWith<InvoicesListState> get copyWith => _$InvoicesListStateCopyWithImpl<InvoicesListState>(this as InvoicesListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicesListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.allInvoices, allInvoices)&&const DeepCollectionEquality().equals(other.filteredInvoices, filteredInvoices)&&(identical(other.filterType, filterType) || other.filterType == filterType)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(allInvoices),const DeepCollectionEquality().hash(filteredInvoices),filterType,searchQuery,errorMessage);

@override
String toString() {
  return 'InvoicesListState(isLoading: $isLoading, allInvoices: $allInvoices, filteredInvoices: $filteredInvoices, filterType: $filterType, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $InvoicesListStateCopyWith<$Res>  {
  factory $InvoicesListStateCopyWith(InvoicesListState value, $Res Function(InvoicesListState) _then) = _$InvoicesListStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<InvoiceEntity> allInvoices, List<InvoiceEntity> filteredInvoices, InvoiceType filterType, String searchQuery, String? errorMessage
});




}
/// @nodoc
class _$InvoicesListStateCopyWithImpl<$Res>
    implements $InvoicesListStateCopyWith<$Res> {
  _$InvoicesListStateCopyWithImpl(this._self, this._then);

  final InvoicesListState _self;
  final $Res Function(InvoicesListState) _then;

/// Create a copy of InvoicesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? allInvoices = null,Object? filteredInvoices = null,Object? filterType = null,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,allInvoices: null == allInvoices ? _self.allInvoices : allInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,filteredInvoices: null == filteredInvoices ? _self.filteredInvoices : filteredInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,filterType: null == filterType ? _self.filterType : filterType // ignore: cast_nullable_to_non_nullable
as InvoiceType,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoicesListState].
extension InvoicesListStatePatterns on InvoicesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicesListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicesListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicesListState value)  $default,){
final _that = this;
switch (_that) {
case _InvoicesListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicesListState value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicesListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<InvoiceEntity> allInvoices,  List<InvoiceEntity> filteredInvoices,  InvoiceType filterType,  String searchQuery,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicesListState() when $default != null:
return $default(_that.isLoading,_that.allInvoices,_that.filteredInvoices,_that.filterType,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<InvoiceEntity> allInvoices,  List<InvoiceEntity> filteredInvoices,  InvoiceType filterType,  String searchQuery,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _InvoicesListState():
return $default(_that.isLoading,_that.allInvoices,_that.filteredInvoices,_that.filterType,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<InvoiceEntity> allInvoices,  List<InvoiceEntity> filteredInvoices,  InvoiceType filterType,  String searchQuery,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _InvoicesListState() when $default != null:
return $default(_that.isLoading,_that.allInvoices,_that.filteredInvoices,_that.filterType,_that.searchQuery,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _InvoicesListState implements InvoicesListState {
  const _InvoicesListState({this.isLoading = false, final  List<InvoiceEntity> allInvoices = const [], final  List<InvoiceEntity> filteredInvoices = const [], this.filterType = InvoiceType.sales, this.searchQuery = '', this.errorMessage}): _allInvoices = allInvoices,_filteredInvoices = filteredInvoices;
  

@override@JsonKey() final  bool isLoading;
 final  List<InvoiceEntity> _allInvoices;
@override@JsonKey() List<InvoiceEntity> get allInvoices {
  if (_allInvoices is EqualUnmodifiableListView) return _allInvoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allInvoices);
}

// المصدر الرئيسي
 final  List<InvoiceEntity> _filteredInvoices;
// المصدر الرئيسي
@override@JsonKey() List<InvoiceEntity> get filteredInvoices {
  if (_filteredInvoices is EqualUnmodifiableListView) return _filteredInvoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredInvoices);
}

// المعروض
@override@JsonKey() final  InvoiceType filterType;
// التبويب
@override@JsonKey() final  String searchQuery;
// [NEW] نص البحث
@override final  String? errorMessage;

/// Create a copy of InvoicesListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicesListStateCopyWith<_InvoicesListState> get copyWith => __$InvoicesListStateCopyWithImpl<_InvoicesListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicesListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._allInvoices, _allInvoices)&&const DeepCollectionEquality().equals(other._filteredInvoices, _filteredInvoices)&&(identical(other.filterType, filterType) || other.filterType == filterType)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_allInvoices),const DeepCollectionEquality().hash(_filteredInvoices),filterType,searchQuery,errorMessage);

@override
String toString() {
  return 'InvoicesListState(isLoading: $isLoading, allInvoices: $allInvoices, filteredInvoices: $filteredInvoices, filterType: $filterType, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$InvoicesListStateCopyWith<$Res> implements $InvoicesListStateCopyWith<$Res> {
  factory _$InvoicesListStateCopyWith(_InvoicesListState value, $Res Function(_InvoicesListState) _then) = __$InvoicesListStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<InvoiceEntity> allInvoices, List<InvoiceEntity> filteredInvoices, InvoiceType filterType, String searchQuery, String? errorMessage
});




}
/// @nodoc
class __$InvoicesListStateCopyWithImpl<$Res>
    implements _$InvoicesListStateCopyWith<$Res> {
  __$InvoicesListStateCopyWithImpl(this._self, this._then);

  final _InvoicesListState _self;
  final $Res Function(_InvoicesListState) _then;

/// Create a copy of InvoicesListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? allInvoices = null,Object? filteredInvoices = null,Object? filterType = null,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_InvoicesListState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,allInvoices: null == allInvoices ? _self._allInvoices : allInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,filteredInvoices: null == filteredInvoices ? _self._filteredInvoices : filteredInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,filterType: null == filterType ? _self.filterType : filterType // ignore: cast_nullable_to_non_nullable
as InvoiceType,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
