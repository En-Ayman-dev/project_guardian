// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceItemModel {
  String get productId;
  String get productName;
  String get unitId;
  String get unitName;
  double get conversionFactor;
  int get quantity;
  double get price;
  double get total;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InvoiceItemModelCopyWith<InvoiceItemModel> get copyWith =>
      _$InvoiceItemModelCopyWithImpl<InvoiceItemModel>(
          this as InvoiceItemModel, _$identity);

  /// Serializes this InvoiceItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InvoiceItemModel &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.unitName, unitName) ||
                other.unitName == unitName) &&
            (identical(other.conversionFactor, conversionFactor) ||
                other.conversionFactor == conversionFactor) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, unitId,
      unitName, conversionFactor, quantity, price, total);

  @override
  String toString() {
    return 'InvoiceItemModel(productId: $productId, productName: $productName, unitId: $unitId, unitName: $unitName, conversionFactor: $conversionFactor, quantity: $quantity, price: $price, total: $total)';
  }
}

/// @nodoc
abstract mixin class $InvoiceItemModelCopyWith<$Res> {
  factory $InvoiceItemModelCopyWith(
          InvoiceItemModel value, $Res Function(InvoiceItemModel) _then) =
      _$InvoiceItemModelCopyWithImpl;
  @useResult
  $Res call(
      {String productId,
      String productName,
      String unitId,
      String unitName,
      double conversionFactor,
      int quantity,
      double price,
      double total});
}

/// @nodoc
class _$InvoiceItemModelCopyWithImpl<$Res>
    implements $InvoiceItemModelCopyWith<$Res> {
  _$InvoiceItemModelCopyWithImpl(this._self, this._then);

  final InvoiceItemModel _self;
  final $Res Function(InvoiceItemModel) _then;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? unitId = null,
    Object? unitName = null,
    Object? conversionFactor = null,
    Object? quantity = null,
    Object? price = null,
    Object? total = null,
  }) {
    return _then(_self.copyWith(
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
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
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [InvoiceItemModel].
extension InvoiceItemModelPatterns on InvoiceItemModel {
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
    TResult Function(_InvoiceItemModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceItemModel() when $default != null:
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
    TResult Function(_InvoiceItemModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceItemModel():
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
    TResult? Function(_InvoiceItemModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceItemModel() when $default != null:
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
    TResult Function(
            String productId,
            String productName,
            String unitId,
            String unitName,
            double conversionFactor,
            int quantity,
            double price,
            double total)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceItemModel() when $default != null:
        return $default(
            _that.productId,
            _that.productName,
            _that.unitId,
            _that.unitName,
            _that.conversionFactor,
            _that.quantity,
            _that.price,
            _that.total);
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
    TResult Function(
            String productId,
            String productName,
            String unitId,
            String unitName,
            double conversionFactor,
            int quantity,
            double price,
            double total)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceItemModel():
        return $default(
            _that.productId,
            _that.productName,
            _that.unitId,
            _that.unitName,
            _that.conversionFactor,
            _that.quantity,
            _that.price,
            _that.total);
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
    TResult? Function(
            String productId,
            String productName,
            String unitId,
            String unitName,
            double conversionFactor,
            int quantity,
            double price,
            double total)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceItemModel() when $default != null:
        return $default(
            _that.productId,
            _that.productName,
            _that.unitId,
            _that.unitName,
            _that.conversionFactor,
            _that.quantity,
            _that.price,
            _that.total);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _InvoiceItemModel extends InvoiceItemModel {
  const _InvoiceItemModel(
      {required this.productId,
      required this.productName,
      required this.unitId,
      required this.unitName,
      required this.conversionFactor,
      required this.quantity,
      required this.price,
      required this.total})
      : super._();
  factory _InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final String unitId;
  @override
  final String unitName;
  @override
  final double conversionFactor;
  @override
  final int quantity;
  @override
  final double price;
  @override
  final double total;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InvoiceItemModelCopyWith<_InvoiceItemModel> get copyWith =>
      __$InvoiceItemModelCopyWithImpl<_InvoiceItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InvoiceItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvoiceItemModel &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.unitId, unitId) || other.unitId == unitId) &&
            (identical(other.unitName, unitName) ||
                other.unitName == unitName) &&
            (identical(other.conversionFactor, conversionFactor) ||
                other.conversionFactor == conversionFactor) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, unitId,
      unitName, conversionFactor, quantity, price, total);

  @override
  String toString() {
    return 'InvoiceItemModel(productId: $productId, productName: $productName, unitId: $unitId, unitName: $unitName, conversionFactor: $conversionFactor, quantity: $quantity, price: $price, total: $total)';
  }
}

/// @nodoc
abstract mixin class _$InvoiceItemModelCopyWith<$Res>
    implements $InvoiceItemModelCopyWith<$Res> {
  factory _$InvoiceItemModelCopyWith(
          _InvoiceItemModel value, $Res Function(_InvoiceItemModel) _then) =
      __$InvoiceItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      String unitId,
      String unitName,
      double conversionFactor,
      int quantity,
      double price,
      double total});
}

/// @nodoc
class __$InvoiceItemModelCopyWithImpl<$Res>
    implements _$InvoiceItemModelCopyWith<$Res> {
  __$InvoiceItemModelCopyWithImpl(this._self, this._then);

  final _InvoiceItemModel _self;
  final $Res Function(_InvoiceItemModel) _then;

  /// Create a copy of InvoiceItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? unitId = null,
    Object? unitName = null,
    Object? conversionFactor = null,
    Object? quantity = null,
    Object? price = null,
    Object? total = null,
  }) {
    return _then(_InvoiceItemModel(
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
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
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
