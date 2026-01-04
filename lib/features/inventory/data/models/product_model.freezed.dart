// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

@JsonKey(includeFromJson: false, includeToJson: false) String? get id; String get name; String? get description;// --- التعديل 1: إضافة حقل الباركود ---
 String? get barcode; String get categoryId; String get categoryName;// القائمة الجديدة
 List<ProductUnitModel> get units; double get stock; int get minStockAlert;@TimestampConverter() DateTime get createdAt;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other.units, units)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.minStockAlert, minStockAlert) || other.minStockAlert == minStockAlert)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,barcode,categoryId,categoryName,const DeepCollectionEquality().hash(units),stock,minStockAlert,createdAt);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, barcode: $barcode, categoryId: $categoryId, categoryName: $categoryName, units: $units, stock: $stock, minStockAlert: $minStockAlert, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String name, String? description, String? barcode, String categoryId, String categoryName, List<ProductUnitModel> units, double stock, int minStockAlert,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? barcode = freezed,Object? categoryId = null,Object? categoryName = null,Object? units = null,Object? stock = null,Object? minStockAlert = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<ProductUnitModel>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,minStockAlert: null == minStockAlert ? _self.minStockAlert : minStockAlert // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String name,  String? description,  String? barcode,  String categoryId,  String categoryName,  List<ProductUnitModel> units,  double stock,  int minStockAlert, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.barcode,_that.categoryId,_that.categoryName,_that.units,_that.stock,_that.minStockAlert,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String name,  String? description,  String? barcode,  String categoryId,  String categoryName,  List<ProductUnitModel> units,  double stock,  int minStockAlert, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.description,_that.barcode,_that.categoryId,_that.categoryName,_that.units,_that.stock,_that.minStockAlert,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String name,  String? description,  String? barcode,  String categoryId,  String categoryName,  List<ProductUnitModel> units,  double stock,  int minStockAlert, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.barcode,_that.categoryId,_that.categoryName,_that.units,_that.stock,_that.minStockAlert,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ProductModel extends ProductModel {
  const _ProductModel({@JsonKey(includeFromJson: false, includeToJson: false) this.id, required this.name, this.description, this.barcode, required this.categoryId, required this.categoryName, required final  List<ProductUnitModel> units, this.stock = 0.0, this.minStockAlert = 5, @TimestampConverter() required this.createdAt}): _units = units,super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? id;
@override final  String name;
@override final  String? description;
// --- التعديل 1: إضافة حقل الباركود ---
@override final  String? barcode;
@override final  String categoryId;
@override final  String categoryName;
// القائمة الجديدة
 final  List<ProductUnitModel> _units;
// القائمة الجديدة
@override List<ProductUnitModel> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

@override@JsonKey() final  double stock;
@override@JsonKey() final  int minStockAlert;
@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other._units, _units)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.minStockAlert, minStockAlert) || other.minStockAlert == minStockAlert)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,barcode,categoryId,categoryName,const DeepCollectionEquality().hash(_units),stock,minStockAlert,createdAt);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, barcode: $barcode, categoryId: $categoryId, categoryName: $categoryName, units: $units, stock: $stock, minStockAlert: $minStockAlert, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String name, String? description, String? barcode, String categoryId, String categoryName, List<ProductUnitModel> units, double stock, int minStockAlert,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = freezed,Object? barcode = freezed,Object? categoryId = null,Object? categoryName = null,Object? units = null,Object? stock = null,Object? minStockAlert = null,Object? createdAt = null,}) {
  return _then(_ProductModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<ProductUnitModel>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,minStockAlert: null == minStockAlert ? _self.minStockAlert : minStockAlert // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
