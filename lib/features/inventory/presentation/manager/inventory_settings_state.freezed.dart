// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventorySettingsState {
  bool get isLoading;
  List<CategoryEntity> get categories;
  List<UnitEntity> get units;
  String?
      get errorMessage; // متغير لتنبيه الواجهة بأن عملية (إضافة/حذف) تمت بنجاح لعرض رسالة
  bool get isActionSuccess;

  /// Create a copy of InventorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventorySettingsStateCopyWith<InventorySettingsState> get copyWith =>
      _$InventorySettingsStateCopyWithImpl<InventorySettingsState>(
          this as InventorySettingsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventorySettingsState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality().equals(other.units, units) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isActionSuccess, isActionSuccess) ||
                other.isActionSuccess == isActionSuccess));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(units),
      errorMessage,
      isActionSuccess);

  @override
  String toString() {
    return 'InventorySettingsState(isLoading: $isLoading, categories: $categories, units: $units, errorMessage: $errorMessage, isActionSuccess: $isActionSuccess)';
  }
}

/// @nodoc
abstract mixin class $InventorySettingsStateCopyWith<$Res> {
  factory $InventorySettingsStateCopyWith(InventorySettingsState value,
          $Res Function(InventorySettingsState) _then) =
      _$InventorySettingsStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      List<CategoryEntity> categories,
      List<UnitEntity> units,
      String? errorMessage,
      bool isActionSuccess});
}

/// @nodoc
class _$InventorySettingsStateCopyWithImpl<$Res>
    implements $InventorySettingsStateCopyWith<$Res> {
  _$InventorySettingsStateCopyWithImpl(this._self, this._then);

  final InventorySettingsState _self;
  final $Res Function(InventorySettingsState) _then;

  /// Create a copy of InventorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? categories = null,
    Object? units = null,
    Object? errorMessage = freezed,
    Object? isActionSuccess = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryEntity>,
      units: null == units
          ? _self.units
          : units // ignore: cast_nullable_to_non_nullable
              as List<UnitEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isActionSuccess: null == isActionSuccess
          ? _self.isActionSuccess
          : isActionSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [InventorySettingsState].
extension InventorySettingsStatePatterns on InventorySettingsState {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventorySettingsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InventorySettingsState() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_InventorySettingsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventorySettingsState():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventorySettingsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventorySettingsState() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool isLoading, List<CategoryEntity> categories,
            List<UnitEntity> units, String? errorMessage, bool isActionSuccess)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InventorySettingsState() when $default != null:
        return $default(_that.isLoading, _that.categories, _that.units,
            _that.errorMessage, _that.isActionSuccess);
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
  TResult when<TResult extends Object?>(
    TResult Function(bool isLoading, List<CategoryEntity> categories,
            List<UnitEntity> units, String? errorMessage, bool isActionSuccess)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventorySettingsState():
        return $default(_that.isLoading, _that.categories, _that.units,
            _that.errorMessage, _that.isActionSuccess);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool isLoading, List<CategoryEntity> categories,
            List<UnitEntity> units, String? errorMessage, bool isActionSuccess)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InventorySettingsState() when $default != null:
        return $default(_that.isLoading, _that.categories, _that.units,
            _that.errorMessage, _that.isActionSuccess);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InventorySettingsState implements InventorySettingsState {
  const _InventorySettingsState(
      {this.isLoading = false,
      final List<CategoryEntity> categories = const [],
      final List<UnitEntity> units = const [],
      this.errorMessage,
      this.isActionSuccess = false})
      : _categories = categories,
        _units = units;

  @override
  @JsonKey()
  final bool isLoading;
  final List<CategoryEntity> _categories;
  @override
  @JsonKey()
  List<CategoryEntity> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<UnitEntity> _units;
  @override
  @JsonKey()
  List<UnitEntity> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  @override
  final String? errorMessage;
// متغير لتنبيه الواجهة بأن عملية (إضافة/حذف) تمت بنجاح لعرض رسالة
  @override
  @JsonKey()
  final bool isActionSuccess;

  /// Create a copy of InventorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventorySettingsStateCopyWith<_InventorySettingsState> get copyWith =>
      __$InventorySettingsStateCopyWithImpl<_InventorySettingsState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventorySettingsState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._units, _units) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isActionSuccess, isActionSuccess) ||
                other.isActionSuccess == isActionSuccess));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_units),
      errorMessage,
      isActionSuccess);

  @override
  String toString() {
    return 'InventorySettingsState(isLoading: $isLoading, categories: $categories, units: $units, errorMessage: $errorMessage, isActionSuccess: $isActionSuccess)';
  }
}

/// @nodoc
abstract mixin class _$InventorySettingsStateCopyWith<$Res>
    implements $InventorySettingsStateCopyWith<$Res> {
  factory _$InventorySettingsStateCopyWith(_InventorySettingsState value,
          $Res Function(_InventorySettingsState) _then) =
      __$InventorySettingsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<CategoryEntity> categories,
      List<UnitEntity> units,
      String? errorMessage,
      bool isActionSuccess});
}

/// @nodoc
class __$InventorySettingsStateCopyWithImpl<$Res>
    implements _$InventorySettingsStateCopyWith<$Res> {
  __$InventorySettingsStateCopyWithImpl(this._self, this._then);

  final _InventorySettingsState _self;
  final $Res Function(_InventorySettingsState) _then;

  /// Create a copy of InventorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? categories = null,
    Object? units = null,
    Object? errorMessage = freezed,
    Object? isActionSuccess = null,
  }) {
    return _then(_InventorySettingsState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<CategoryEntity>,
      units: null == units
          ? _self._units
          : units // ignore: cast_nullable_to_non_nullable
              as List<UnitEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isActionSuccess: null == isActionSuccess
          ? _self.isActionSuccess
          : isActionSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
