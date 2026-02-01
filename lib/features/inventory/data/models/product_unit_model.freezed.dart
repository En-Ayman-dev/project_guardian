// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductUnitModel {
  String get unitId;
  String get unitName;
  double get conversionFactor;
  double get buyPrice;
  double get sellPrice;
  String? get barcode;

  /// Create a copy of ProductUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductUnitModelCopyWith<ProductUnitModel> get copyWith =>
      _$ProductUnitModelCopyWithImpl<ProductUnitModel>(
          this as ProductUnitModel, _$identity);

  /// Serializes this ProductUnitModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductUnitModel &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.unitName, unitName) ||
                other.unitName == unitName) &&
            (identical(other.conversionFactor, conversionFactor) ||
                other.conversionFactor == conversionFactor) &&
            (identical(other.buyPrice, buyPrice) ||
                other.buyPrice == buyPrice) &&
            (identical(other.sellPrice, sellPrice) ||
                other.sellPrice == sellPrice) &&
            (identical(other.barcode, barcode) || other.barcode == barcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unitId, unitName,
      conversionFactor, buyPrice, sellPrice, barcode);

  @override
  String toString() {
    return 'ProductUnitModel(unitId: $unitId, unitName: $unitName, conversionFactor: $conversionFactor, buyPrice: $buyPrice, sellPrice: $sellPrice, barcode: $barcode)';
  }
}

/// @nodoc
abstract mixin class $ProductUnitModelCopyWith<$Res> {
  factory $ProductUnitModelCopyWith(
          ProductUnitModel value, $Res Function(ProductUnitModel) _then) =
      _$ProductUnitModelCopyWithImpl;
  @useResult
  $Res call(
      {String unitId,
      String unitName,
      double conversionFactor,
      double buyPrice,
      double sellPrice,
      String? barcode});
}

/// @nodoc
class _$ProductUnitModelCopyWithImpl<$Res>
    implements $ProductUnitModelCopyWith<$Res> {
  _$ProductUnitModelCopyWithImpl(this._self, this._then);

  final ProductUnitModel _self;
  final $Res Function(ProductUnitModel) _then;

  /// Create a copy of ProductUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unitId = null,
    Object? unitName = null,
    Object? conversionFactor = null,
    Object? buyPrice = null,
    Object? sellPrice = null,
    Object? barcode = freezed,
  }) {
    return _then(_self.copyWith(
      unitId: null == unitId
          ? _self.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String,
      unitName: null == unitName
          ? _self.unitName
          : unitName // ignore: cast_nullable_to_non_nullable
              as String,
      conversionFactor: null == conversionFactor
          ? _self.conversionFactor
          : conversionFactor // ignore: cast_nullable_to_non_nullable
              as double,
      buyPrice: null == buyPrice
          ? _self.buyPrice
          : buyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellPrice: null == sellPrice
          ? _self.sellPrice
          : sellPrice // ignore: cast_nullable_to_non_nullable
              as double,
      barcode: freezed == barcode
          ? _self.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductUnitModel].
extension ProductUnitModelPatterns on ProductUnitModel {
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
    TResult Function(_ProductUnitModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductUnitModel() when $default != null:
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
    TResult Function(_ProductUnitModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductUnitModel():
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
    TResult? Function(_ProductUnitModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductUnitModel() when $default != null:
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
    TResult Function(String unitId, String unitName, double conversionFactor,
            double buyPrice, double sellPrice, String? barcode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductUnitModel() when $default != null:
        return $default(_that.unitId, _that.unitName, _that.conversionFactor,
            _that.buyPrice, _that.sellPrice, _that.barcode);
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
    TResult Function(String unitId, String unitName, double conversionFactor,
            double buyPrice, double sellPrice, String? barcode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductUnitModel():
        return $default(_that.unitId, _that.unitName, _that.conversionFactor,
            _that.buyPrice, _that.sellPrice, _that.barcode);
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
    TResult? Function(String unitId, String unitName, double conversionFactor,
            double buyPrice, double sellPrice, String? barcode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductUnitModel() when $default != null:
        return $default(_that.unitId, _that.unitName, _that.conversionFactor,
            _that.buyPrice, _that.sellPrice, _that.barcode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductUnitModel extends ProductUnitModel {
  const _ProductUnitModel(
      {required this.unitId,
      required this.unitName,
      required this.conversionFactor,
      required this.buyPrice,
      required this.sellPrice,
      this.barcode})
      : super._();
  factory _ProductUnitModel.fromJson(Map<String, dynamic> json) =>
      _$ProductUnitModelFromJson(json);

  @override
  final String unitId;
  @override
  final String unitName;
  @override
  final double conversionFactor;
  @override
  final double buyPrice;
  @override
  final double sellPrice;
  @override
  final String? barcode;

  /// Create a copy of ProductUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductUnitModelCopyWith<_ProductUnitModel> get copyWith =>
      __$ProductUnitModelCopyWithImpl<_ProductUnitModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductUnitModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductUnitModel &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.unitName, unitName) ||
                other.unitName == unitName) &&
            (identical(other.conversionFactor, conversionFactor) ||
                other.conversionFactor == conversionFactor) &&
            (identical(other.buyPrice, buyPrice) ||
                other.buyPrice == buyPrice) &&
            (identical(other.sellPrice, sellPrice) ||
                other.sellPrice == sellPrice) &&
            (identical(other.barcode, barcode) || other.barcode == barcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unitId, unitName,
      conversionFactor, buyPrice, sellPrice, barcode);

  @override
  String toString() {
    return 'ProductUnitModel(unitId: $unitId, unitName: $unitName, conversionFactor: $conversionFactor, buyPrice: $buyPrice, sellPrice: $sellPrice, barcode: $barcode)';
  }
}

/// @nodoc
abstract mixin class _$ProductUnitModelCopyWith<$Res>
    implements $ProductUnitModelCopyWith<$Res> {
  factory _$ProductUnitModelCopyWith(
          _ProductUnitModel value, $Res Function(_ProductUnitModel) _then) =
      __$ProductUnitModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String unitId,
      String unitName,
      double conversionFactor,
      double buyPrice,
      double sellPrice,
      String? barcode});
}

/// @nodoc
class __$ProductUnitModelCopyWithImpl<$Res>
    implements _$ProductUnitModelCopyWith<$Res> {
  __$ProductUnitModelCopyWithImpl(this._self, this._then);

  final _ProductUnitModel _self;
  final $Res Function(_ProductUnitModel) _then;

  /// Create a copy of ProductUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? unitId = null,
    Object? unitName = null,
    Object? conversionFactor = null,
    Object? buyPrice = null,
    Object? sellPrice = null,
    Object? barcode = freezed,
  }) {
    return _then(_ProductUnitModel(
      unitId: null == unitId
          ? _self.unitId
          : unitId // ignore: cast_nullable_to_non_nullable
              as String,
      unitName: null == unitName
          ? _self.unitName
          : unitName // ignore: cast_nullable_to_non_nullable
              as String,
      conversionFactor: null == conversionFactor
          ? _self.conversionFactor
          : conversionFactor // ignore: cast_nullable_to_non_nullable
              as double,
      buyPrice: null == buyPrice
          ? _self.buyPrice
          : buyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellPrice: null == sellPrice
          ? _self.sellPrice
          : sellPrice // ignore: cast_nullable_to_non_nullable
              as double,
      barcode: freezed == barcode
          ? _self.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
