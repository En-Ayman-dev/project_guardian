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

 bool get isLoading; bool get isMoreLoading;// [NEW] تحميل المزيد
 bool get hasReachedMax;// [NEW] هل وصلنا للنهاية؟
 bool get isSearching;// [NEW] هل نحن في وضع البحث؟
 List<InvoiceEntity> get allInvoices;// القائمة المتراكمة (Pagination)
 List<InvoiceEntity> get searchResults;// نتائج البحث (Search)
 List<InvoiceEntity> get filteredInvoices;// المعروض في الواجهة
 InvoiceType get filterType; String get searchQuery; String? get errorMessage;
/// Create a copy of InvoicesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicesListStateCopyWith<InvoicesListState> get copyWith => _$InvoicesListStateCopyWithImpl<InvoicesListState>(this as InvoicesListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicesListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isMoreLoading, isMoreLoading) || other.isMoreLoading == isMoreLoading)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other.allInvoices, allInvoices)&&const DeepCollectionEquality().equals(other.searchResults, searchResults)&&const DeepCollectionEquality().equals(other.filteredInvoices, filteredInvoices)&&(identical(other.filterType, filterType) || other.filterType == filterType)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isMoreLoading,hasReachedMax,isSearching,const DeepCollectionEquality().hash(allInvoices),const DeepCollectionEquality().hash(searchResults),const DeepCollectionEquality().hash(filteredInvoices),filterType,searchQuery,errorMessage);

@override
String toString() {
  return 'InvoicesListState(isLoading: $isLoading, isMoreLoading: $isMoreLoading, hasReachedMax: $hasReachedMax, isSearching: $isSearching, allInvoices: $allInvoices, searchResults: $searchResults, filteredInvoices: $filteredInvoices, filterType: $filterType, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $InvoicesListStateCopyWith<$Res>  {
  factory $InvoicesListStateCopyWith(InvoicesListState value, $Res Function(InvoicesListState) _then) = _$InvoicesListStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isMoreLoading, bool hasReachedMax, bool isSearching, List<InvoiceEntity> allInvoices, List<InvoiceEntity> searchResults, List<InvoiceEntity> filteredInvoices, InvoiceType filterType, String searchQuery, String? errorMessage
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
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isMoreLoading = null,Object? hasReachedMax = null,Object? isSearching = null,Object? allInvoices = null,Object? searchResults = null,Object? filteredInvoices = null,Object? filterType = null,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isMoreLoading: null == isMoreLoading ? _self.isMoreLoading : isMoreLoading // ignore: cast_nullable_to_non_nullable
as bool,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,allInvoices: null == allInvoices ? _self.allInvoices : allInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,searchResults: null == searchResults ? _self.searchResults : searchResults // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isMoreLoading,  bool hasReachedMax,  bool isSearching,  List<InvoiceEntity> allInvoices,  List<InvoiceEntity> searchResults,  List<InvoiceEntity> filteredInvoices,  InvoiceType filterType,  String searchQuery,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicesListState() when $default != null:
return $default(_that.isLoading,_that.isMoreLoading,_that.hasReachedMax,_that.isSearching,_that.allInvoices,_that.searchResults,_that.filteredInvoices,_that.filterType,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isMoreLoading,  bool hasReachedMax,  bool isSearching,  List<InvoiceEntity> allInvoices,  List<InvoiceEntity> searchResults,  List<InvoiceEntity> filteredInvoices,  InvoiceType filterType,  String searchQuery,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _InvoicesListState():
return $default(_that.isLoading,_that.isMoreLoading,_that.hasReachedMax,_that.isSearching,_that.allInvoices,_that.searchResults,_that.filteredInvoices,_that.filterType,_that.searchQuery,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isMoreLoading,  bool hasReachedMax,  bool isSearching,  List<InvoiceEntity> allInvoices,  List<InvoiceEntity> searchResults,  List<InvoiceEntity> filteredInvoices,  InvoiceType filterType,  String searchQuery,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _InvoicesListState() when $default != null:
return $default(_that.isLoading,_that.isMoreLoading,_that.hasReachedMax,_that.isSearching,_that.allInvoices,_that.searchResults,_that.filteredInvoices,_that.filterType,_that.searchQuery,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _InvoicesListState implements InvoicesListState {
  const _InvoicesListState({this.isLoading = false, this.isMoreLoading = false, this.hasReachedMax = false, this.isSearching = false, final  List<InvoiceEntity> allInvoices = const [], final  List<InvoiceEntity> searchResults = const [], final  List<InvoiceEntity> filteredInvoices = const [], this.filterType = InvoiceType.sales, this.searchQuery = '', this.errorMessage}): _allInvoices = allInvoices,_searchResults = searchResults,_filteredInvoices = filteredInvoices;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isMoreLoading;
// [NEW] تحميل المزيد
@override@JsonKey() final  bool hasReachedMax;
// [NEW] هل وصلنا للنهاية؟
@override@JsonKey() final  bool isSearching;
// [NEW] هل نحن في وضع البحث؟
 final  List<InvoiceEntity> _allInvoices;
// [NEW] هل نحن في وضع البحث؟
@override@JsonKey() List<InvoiceEntity> get allInvoices {
  if (_allInvoices is EqualUnmodifiableListView) return _allInvoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allInvoices);
}

// القائمة المتراكمة (Pagination)
 final  List<InvoiceEntity> _searchResults;
// القائمة المتراكمة (Pagination)
@override@JsonKey() List<InvoiceEntity> get searchResults {
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResults);
}

// نتائج البحث (Search)
 final  List<InvoiceEntity> _filteredInvoices;
// نتائج البحث (Search)
@override@JsonKey() List<InvoiceEntity> get filteredInvoices {
  if (_filteredInvoices is EqualUnmodifiableListView) return _filteredInvoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredInvoices);
}

// المعروض في الواجهة
@override@JsonKey() final  InvoiceType filterType;
@override@JsonKey() final  String searchQuery;
@override final  String? errorMessage;

/// Create a copy of InvoicesListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicesListStateCopyWith<_InvoicesListState> get copyWith => __$InvoicesListStateCopyWithImpl<_InvoicesListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicesListState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isMoreLoading, isMoreLoading) || other.isMoreLoading == isMoreLoading)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other._allInvoices, _allInvoices)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&const DeepCollectionEquality().equals(other._filteredInvoices, _filteredInvoices)&&(identical(other.filterType, filterType) || other.filterType == filterType)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isMoreLoading,hasReachedMax,isSearching,const DeepCollectionEquality().hash(_allInvoices),const DeepCollectionEquality().hash(_searchResults),const DeepCollectionEquality().hash(_filteredInvoices),filterType,searchQuery,errorMessage);

@override
String toString() {
  return 'InvoicesListState(isLoading: $isLoading, isMoreLoading: $isMoreLoading, hasReachedMax: $hasReachedMax, isSearching: $isSearching, allInvoices: $allInvoices, searchResults: $searchResults, filteredInvoices: $filteredInvoices, filterType: $filterType, searchQuery: $searchQuery, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$InvoicesListStateCopyWith<$Res> implements $InvoicesListStateCopyWith<$Res> {
  factory _$InvoicesListStateCopyWith(_InvoicesListState value, $Res Function(_InvoicesListState) _then) = __$InvoicesListStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isMoreLoading, bool hasReachedMax, bool isSearching, List<InvoiceEntity> allInvoices, List<InvoiceEntity> searchResults, List<InvoiceEntity> filteredInvoices, InvoiceType filterType, String searchQuery, String? errorMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isMoreLoading = null,Object? hasReachedMax = null,Object? isSearching = null,Object? allInvoices = null,Object? searchResults = null,Object? filteredInvoices = null,Object? filterType = null,Object? searchQuery = null,Object? errorMessage = freezed,}) {
  return _then(_InvoicesListState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isMoreLoading: null == isMoreLoading ? _self.isMoreLoading : isMoreLoading // ignore: cast_nullable_to_non_nullable
as bool,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,allInvoices: null == allInvoices ? _self._allInvoices : allInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,searchResults: null == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,filteredInvoices: null == filteredInvoices ? _self._filteredInvoices : filteredInvoices // ignore: cast_nullable_to_non_nullable
as List<InvoiceEntity>,filterType: null == filterType ? _self.filterType : filterType // ignore: cast_nullable_to_non_nullable
as InvoiceType,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
