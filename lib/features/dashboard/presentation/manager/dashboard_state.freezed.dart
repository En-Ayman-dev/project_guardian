// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardState {
  bool get isLoading;
  double get totalSales; // إجمالي المبيعات
  int get lowStockCount; // عدد المنتجات التي وصلت للحد الأدنى
  int get clientsCount; // عدد العملاء
  int get invoiceCount; // عدد الفواتير
  String? get errorMessage;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      _$DashboardStateCopyWithImpl<DashboardState>(
          this as DashboardState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.lowStockCount, lowStockCount) ||
                other.lowStockCount == lowStockCount) &&
            (identical(other.clientsCount, clientsCount) ||
                other.clientsCount == clientsCount) &&
            (identical(other.invoiceCount, invoiceCount) ||
                other.invoiceCount == invoiceCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, totalSales,
      lowStockCount, clientsCount, invoiceCount, errorMessage);

  @override
  String toString() {
    return 'DashboardState(isLoading: $isLoading, totalSales: $totalSales, lowStockCount: $lowStockCount, clientsCount: $clientsCount, invoiceCount: $invoiceCount, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) _then) =
      _$DashboardStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      double totalSales,
      int lowStockCount,
      int clientsCount,
      int invoiceCount,
      String? errorMessage});
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? totalSales = null,
    Object? lowStockCount = null,
    Object? clientsCount = null,
    Object? invoiceCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSales: null == totalSales
          ? _self.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockCount: null == lowStockCount
          ? _self.lowStockCount
          : lowStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      clientsCount: null == clientsCount
          ? _self.clientsCount
          : clientsCount // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceCount: null == invoiceCount
          ? _self.invoiceCount
          : invoiceCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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
    TResult Function(_DashboardState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardState() when $default != null:
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
    TResult Function(_DashboardState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardState():
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
    TResult? Function(_DashboardState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardState() when $default != null:
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
    TResult Function(bool isLoading, double totalSales, int lowStockCount,
            int clientsCount, int invoiceCount, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardState() when $default != null:
        return $default(_that.isLoading, _that.totalSales, _that.lowStockCount,
            _that.clientsCount, _that.invoiceCount, _that.errorMessage);
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
    TResult Function(bool isLoading, double totalSales, int lowStockCount,
            int clientsCount, int invoiceCount, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardState():
        return $default(_that.isLoading, _that.totalSales, _that.lowStockCount,
            _that.clientsCount, _that.invoiceCount, _that.errorMessage);
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
    TResult? Function(bool isLoading, double totalSales, int lowStockCount,
            int clientsCount, int invoiceCount, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardState() when $default != null:
        return $default(_that.isLoading, _that.totalSales, _that.lowStockCount,
            _that.clientsCount, _that.invoiceCount, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DashboardState implements DashboardState {
  const _DashboardState(
      {this.isLoading = true,
      this.totalSales = 0.0,
      this.lowStockCount = 0,
      this.clientsCount = 0,
      this.invoiceCount = 0,
      this.errorMessage});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final double totalSales;
// إجمالي المبيعات
  @override
  @JsonKey()
  final int lowStockCount;
// عدد المنتجات التي وصلت للحد الأدنى
  @override
  @JsonKey()
  final int clientsCount;
// عدد العملاء
  @override
  @JsonKey()
  final int invoiceCount;
// عدد الفواتير
  @override
  final String? errorMessage;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardStateCopyWith<_DashboardState> get copyWith =>
      __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.lowStockCount, lowStockCount) ||
                other.lowStockCount == lowStockCount) &&
            (identical(other.clientsCount, clientsCount) ||
                other.clientsCount == clientsCount) &&
            (identical(other.invoiceCount, invoiceCount) ||
                other.invoiceCount == invoiceCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, totalSales,
      lowStockCount, clientsCount, invoiceCount, errorMessage);

  @override
  String toString() {
    return 'DashboardState(isLoading: $isLoading, totalSales: $totalSales, lowStockCount: $lowStockCount, clientsCount: $clientsCount, invoiceCount: $invoiceCount, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(
          _DashboardState value, $Res Function(_DashboardState) _then) =
      __$DashboardStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      double totalSales,
      int lowStockCount,
      int clientsCount,
      int invoiceCount,
      String? errorMessage});
}

/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? totalSales = null,
    Object? lowStockCount = null,
    Object? clientsCount = null,
    Object? invoiceCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_DashboardState(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSales: null == totalSales
          ? _self.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockCount: null == lowStockCount
          ? _self.lowStockCount
          : lowStockCount // ignore: cast_nullable_to_non_nullable
              as int,
      clientsCount: null == clientsCount
          ? _self.clientsCount
          : clientsCount // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceCount: null == invoiceCount
          ? _self.invoiceCount
          : invoiceCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
