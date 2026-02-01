// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_balances_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneralBalancesState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GeneralBalancesState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GeneralBalancesState()';
  }
}

/// @nodoc
class $GeneralBalancesStateCopyWith<$Res> {
  $GeneralBalancesStateCopyWith(
      GeneralBalancesState _, $Res Function(GeneralBalancesState) __);
}

/// Adds pattern-matching-related methods to [GeneralBalancesState].
extension GeneralBalancesStatePatterns on GeneralBalancesState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _Loaded() when loaded != null:
        return loaded(_that);
      case _Error() when error != null:
        return error(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Loading():
        return loading(_that);
      case _Loaded():
        return loaded(_that);
      case _Error():
        return error(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _Loaded() when loaded != null:
        return loaded(_that);
      case _Error() when error != null:
        return error(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ClientSupplierEntity> allEntities,
            List<ClientSupplierEntity> filteredEntities,
            double totalReceivables,
            double totalPayables)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _Loaded() when loaded != null:
        return loaded(_that.allEntities, _that.filteredEntities,
            _that.totalReceivables, _that.totalPayables);
      case _Error() when error != null:
        return error(_that.message);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ClientSupplierEntity> allEntities,
            List<ClientSupplierEntity> filteredEntities,
            double totalReceivables,
            double totalPayables)
        loaded,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Loading():
        return loading();
      case _Loaded():
        return loaded(_that.allEntities, _that.filteredEntities,
            _that.totalReceivables, _that.totalPayables);
      case _Error():
        return error(_that.message);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ClientSupplierEntity> allEntities,
            List<ClientSupplierEntity> filteredEntities,
            double totalReceivables,
            double totalPayables)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _Loaded() when loaded != null:
        return loaded(_that.allEntities, _that.filteredEntities,
            _that.totalReceivables, _that.totalPayables);
      case _Error() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements GeneralBalancesState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GeneralBalancesState.initial()';
  }
}

/// @nodoc

class _Loading implements GeneralBalancesState {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GeneralBalancesState.loading()';
  }
}

/// @nodoc

class _Loaded implements GeneralBalancesState {
  const _Loaded(
      {required final List<ClientSupplierEntity> allEntities,
      required final List<ClientSupplierEntity> filteredEntities,
      required this.totalReceivables,
      required this.totalPayables})
      : _allEntities = allEntities,
        _filteredEntities = filteredEntities;

  final List<ClientSupplierEntity> _allEntities;
  List<ClientSupplierEntity> get allEntities {
    if (_allEntities is EqualUnmodifiableListView) return _allEntities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allEntities);
  }

  final List<ClientSupplierEntity> _filteredEntities;
  List<ClientSupplierEntity> get filteredEntities {
    if (_filteredEntities is EqualUnmodifiableListView)
      return _filteredEntities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredEntities);
  }

  final double totalReceivables;
// إجمالي المديونيات (لنا)
  final double totalPayables;

  /// Create a copy of GeneralBalancesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadedCopyWith<_Loaded> get copyWith =>
      __$LoadedCopyWithImpl<_Loaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Loaded &&
            const DeepCollectionEquality()
                .equals(other._allEntities, _allEntities) &&
            const DeepCollectionEquality()
                .equals(other._filteredEntities, _filteredEntities) &&
            (identical(other.totalReceivables, totalReceivables) ||
                other.totalReceivables == totalReceivables) &&
            (identical(other.totalPayables, totalPayables) ||
                other.totalPayables == totalPayables));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allEntities),
      const DeepCollectionEquality().hash(_filteredEntities),
      totalReceivables,
      totalPayables);

  @override
  String toString() {
    return 'GeneralBalancesState.loaded(allEntities: $allEntities, filteredEntities: $filteredEntities, totalReceivables: $totalReceivables, totalPayables: $totalPayables)';
  }
}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res>
    implements $GeneralBalancesStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) =
      __$LoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<ClientSupplierEntity> allEntities,
      List<ClientSupplierEntity> filteredEntities,
      double totalReceivables,
      double totalPayables});
}

/// @nodoc
class __$LoadedCopyWithImpl<$Res> implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

  /// Create a copy of GeneralBalancesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? allEntities = null,
    Object? filteredEntities = null,
    Object? totalReceivables = null,
    Object? totalPayables = null,
  }) {
    return _then(_Loaded(
      allEntities: null == allEntities
          ? _self._allEntities
          : allEntities // ignore: cast_nullable_to_non_nullable
              as List<ClientSupplierEntity>,
      filteredEntities: null == filteredEntities
          ? _self._filteredEntities
          : filteredEntities // ignore: cast_nullable_to_non_nullable
              as List<ClientSupplierEntity>,
      totalReceivables: null == totalReceivables
          ? _self.totalReceivables
          : totalReceivables // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayables: null == totalPayables
          ? _self.totalPayables
          : totalPayables // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _Error implements GeneralBalancesState {
  const _Error(this.message);

  final String message;

  /// Create a copy of GeneralBalancesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'GeneralBalancesState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $GeneralBalancesStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of GeneralBalancesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Error(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
