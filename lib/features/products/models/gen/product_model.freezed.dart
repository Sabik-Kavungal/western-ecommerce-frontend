// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get shopPrice => throw _privateConstructorUsedError;
  double get websiteCommission => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get isSoldOut => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  List<ColorVariant>? get variants =>
      throw _privateConstructorUsedError; // Keep these for backward compatibility if needed, but they might be null/empty
  String? get color => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  List<String>? get availableSizes => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String? image,
    List<String> images,
    double price,
    double shopPrice,
    double websiteCommission,
    bool isFeatured,
    bool isAvailable,
    bool isSoldOut,
    bool isActive,
    String? categoryId,
    String? categoryName,
    List<ColorVariant>? variants,
    String? color,
    int? quantity,
    List<String>? availableSizes,
    String? parentId,
    String? status,
  });
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? image = freezed,
    Object? images = null,
    Object? price = null,
    Object? shopPrice = null,
    Object? websiteCommission = null,
    Object? isFeatured = null,
    Object? isAvailable = null,
    Object? isSoldOut = null,
    Object? isActive = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? variants = freezed,
    Object? color = freezed,
    Object? quantity = freezed,
    Object? availableSizes = freezed,
    Object? parentId = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            shopPrice: null == shopPrice
                ? _value.shopPrice
                : shopPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            websiteCommission: null == websiteCommission
                ? _value.websiteCommission
                : websiteCommission // ignore: cast_nullable_to_non_nullable
                      as double,
            isFeatured: null == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSoldOut: null == isSoldOut
                ? _value.isSoldOut
                : isSoldOut // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryName: freezed == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String?,
            variants: freezed == variants
                ? _value.variants
                : variants // ignore: cast_nullable_to_non_nullable
                      as List<ColorVariant>?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            availableSizes: freezed == availableSizes
                ? _value.availableSizes
                : availableSizes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String? image,
    List<String> images,
    double price,
    double shopPrice,
    double websiteCommission,
    bool isFeatured,
    bool isAvailable,
    bool isSoldOut,
    bool isActive,
    String? categoryId,
    String? categoryName,
    List<ColorVariant>? variants,
    String? color,
    int? quantity,
    List<String>? availableSizes,
    String? parentId,
    String? status,
  });
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? image = freezed,
    Object? images = null,
    Object? price = null,
    Object? shopPrice = null,
    Object? websiteCommission = null,
    Object? isFeatured = null,
    Object? isAvailable = null,
    Object? isSoldOut = null,
    Object? isActive = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? variants = freezed,
    Object? color = freezed,
    Object? quantity = freezed,
    Object? availableSizes = freezed,
    Object? parentId = freezed,
    Object? status = freezed,
  }) {
    return _then(
      _$ProductModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        shopPrice: null == shopPrice
            ? _value.shopPrice
            : shopPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        websiteCommission: null == websiteCommission
            ? _value.websiteCommission
            : websiteCommission // ignore: cast_nullable_to_non_nullable
                  as double,
        isFeatured: null == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSoldOut: null == isSoldOut
            ? _value.isSoldOut
            : isSoldOut // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryName: freezed == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String?,
        variants: freezed == variants
            ? _value._variants
            : variants // ignore: cast_nullable_to_non_nullable
                  as List<ColorVariant>?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        availableSizes: freezed == availableSizes
            ? _value._availableSizes
            : availableSizes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required final List<String> images,
    required this.price,
    this.shopPrice = 0,
    this.websiteCommission = 0,
    this.isFeatured = false,
    this.isAvailable = true,
    this.isSoldOut = false,
    this.isActive = true,
    this.categoryId,
    this.categoryName,
    final List<ColorVariant>? variants,
    this.color,
    this.quantity,
    final List<String>? availableSizes,
    this.parentId,
    this.status,
  }) : _images = images,
       _variants = variants,
       _availableSizes = availableSizes;

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? image;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final double price;
  @override
  @JsonKey()
  final double shopPrice;
  @override
  @JsonKey()
  final double websiteCommission;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool isSoldOut;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? categoryId;
  @override
  final String? categoryName;
  final List<ColorVariant>? _variants;
  @override
  List<ColorVariant>? get variants {
    final value = _variants;
    if (value == null) return null;
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Keep these for backward compatibility if needed, but they might be null/empty
  @override
  final String? color;
  @override
  final int? quantity;
  final List<String>? _availableSizes;
  @override
  List<String>? get availableSizes {
    final value = _availableSizes;
    if (value == null) return null;
    if (_availableSizes is EqualUnmodifiableListView) return _availableSizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? parentId;
  @override
  final String? status;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, image: $image, images: $images, price: $price, shopPrice: $shopPrice, websiteCommission: $websiteCommission, isFeatured: $isFeatured, isAvailable: $isAvailable, isSoldOut: $isSoldOut, isActive: $isActive, categoryId: $categoryId, categoryName: $categoryName, variants: $variants, color: $color, quantity: $quantity, availableSizes: $availableSizes, parentId: $parentId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.shopPrice, shopPrice) ||
                other.shopPrice == shopPrice) &&
            (identical(other.websiteCommission, websiteCommission) ||
                other.websiteCommission == websiteCommission) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isSoldOut, isSoldOut) ||
                other.isSoldOut == isSoldOut) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality().equals(
              other._availableSizes,
              _availableSizes,
            ) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    image,
    const DeepCollectionEquality().hash(_images),
    price,
    shopPrice,
    websiteCommission,
    isFeatured,
    isAvailable,
    isSoldOut,
    isActive,
    categoryId,
    categoryName,
    const DeepCollectionEquality().hash(_variants),
    color,
    quantity,
    const DeepCollectionEquality().hash(_availableSizes),
    parentId,
    status,
  ]);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel({
    required final String id,
    required final String name,
    required final String description,
    final String? image,
    required final List<String> images,
    required final double price,
    final double shopPrice,
    final double websiteCommission,
    final bool isFeatured,
    final bool isAvailable,
    final bool isSoldOut,
    final bool isActive,
    final String? categoryId,
    final String? categoryName,
    final List<ColorVariant>? variants,
    final String? color,
    final int? quantity,
    final List<String>? availableSizes,
    final String? parentId,
    final String? status,
  }) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get image;
  @override
  List<String> get images;
  @override
  double get price;
  @override
  double get shopPrice;
  @override
  double get websiteCommission;
  @override
  bool get isFeatured;
  @override
  bool get isAvailable;
  @override
  bool get isSoldOut;
  @override
  bool get isActive;
  @override
  String? get categoryId;
  @override
  String? get categoryName;
  @override
  List<ColorVariant>? get variants; // Keep these for backward compatibility if needed, but they might be null/empty
  @override
  String? get color;
  @override
  int? get quantity;
  @override
  List<String>? get availableSizes;
  @override
  String? get parentId;
  @override
  String? get status;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ColorVariant _$ColorVariantFromJson(Map<String, dynamic> json) {
  return _ColorVariant.fromJson(json);
}

/// @nodoc
mixin _$ColorVariant {
  String? get id => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  List<SizeVariant> get sizes => throw _privateConstructorUsedError;

  /// Serializes this ColorVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ColorVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ColorVariantCopyWith<ColorVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorVariantCopyWith<$Res> {
  factory $ColorVariantCopyWith(
    ColorVariant value,
    $Res Function(ColorVariant) then,
  ) = _$ColorVariantCopyWithImpl<$Res, ColorVariant>;
  @useResult
  $Res call({
    String? id,
    String color,
    List<String> images,
    String image,
    List<SizeVariant> sizes,
  });
}

/// @nodoc
class _$ColorVariantCopyWithImpl<$Res, $Val extends ColorVariant>
    implements $ColorVariantCopyWith<$Res> {
  _$ColorVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ColorVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? color = null,
    Object? images = null,
    Object? image = null,
    Object? sizes = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            sizes: null == sizes
                ? _value.sizes
                : sizes // ignore: cast_nullable_to_non_nullable
                      as List<SizeVariant>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ColorVariantImplCopyWith<$Res>
    implements $ColorVariantCopyWith<$Res> {
  factory _$$ColorVariantImplCopyWith(
    _$ColorVariantImpl value,
    $Res Function(_$ColorVariantImpl) then,
  ) = __$$ColorVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String color,
    List<String> images,
    String image,
    List<SizeVariant> sizes,
  });
}

/// @nodoc
class __$$ColorVariantImplCopyWithImpl<$Res>
    extends _$ColorVariantCopyWithImpl<$Res, _$ColorVariantImpl>
    implements _$$ColorVariantImplCopyWith<$Res> {
  __$$ColorVariantImplCopyWithImpl(
    _$ColorVariantImpl _value,
    $Res Function(_$ColorVariantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ColorVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? color = null,
    Object? images = null,
    Object? image = null,
    Object? sizes = null,
  }) {
    return _then(
      _$ColorVariantImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        sizes: null == sizes
            ? _value._sizes
            : sizes // ignore: cast_nullable_to_non_nullable
                  as List<SizeVariant>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ColorVariantImpl implements _ColorVariant {
  const _$ColorVariantImpl({
    this.id,
    required this.color,
    final List<String> images = const [],
    required this.image,
    required final List<SizeVariant> sizes,
  }) : _images = images,
       _sizes = sizes;

  factory _$ColorVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColorVariantImplFromJson(json);

  @override
  final String? id;
  @override
  final String color;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String image;
  final List<SizeVariant> _sizes;
  @override
  List<SizeVariant> get sizes {
    if (_sizes is EqualUnmodifiableListView) return _sizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sizes);
  }

  @override
  String toString() {
    return 'ColorVariant(id: $id, color: $color, images: $images, image: $image, sizes: $sizes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColorVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality().equals(other._sizes, _sizes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    color,
    const DeepCollectionEquality().hash(_images),
    image,
    const DeepCollectionEquality().hash(_sizes),
  );

  /// Create a copy of ColorVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ColorVariantImplCopyWith<_$ColorVariantImpl> get copyWith =>
      __$$ColorVariantImplCopyWithImpl<_$ColorVariantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ColorVariantImplToJson(this);
  }
}

abstract class _ColorVariant implements ColorVariant {
  const factory _ColorVariant({
    final String? id,
    required final String color,
    final List<String> images,
    required final String image,
    required final List<SizeVariant> sizes,
  }) = _$ColorVariantImpl;

  factory _ColorVariant.fromJson(Map<String, dynamic> json) =
      _$ColorVariantImpl.fromJson;

  @override
  String? get id;
  @override
  String get color;
  @override
  List<String> get images;
  @override
  String get image;
  @override
  List<SizeVariant> get sizes;

  /// Create a copy of ColorVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ColorVariantImplCopyWith<_$ColorVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SizeVariant _$SizeVariantFromJson(Map<String, dynamic> json) {
  return _SizeVariant.fromJson(json);
}

/// @nodoc
mixin _$SizeVariant {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get shopPrice => throw _privateConstructorUsedError;
  double get websiteCommission => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this SizeVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SizeVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SizeVariantCopyWith<SizeVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SizeVariantCopyWith<$Res> {
  factory $SizeVariantCopyWith(
    SizeVariant value,
    $Res Function(SizeVariant) then,
  ) = _$SizeVariantCopyWithImpl<$Res, SizeVariant>;
  @useResult
  $Res call({
    String id,
    String name,
    String size,
    double price,
    double shopPrice,
    double websiteCommission,
    int stock,
    bool isAvailable,
    bool isActive,
    String? status,
  });
}

/// @nodoc
class _$SizeVariantCopyWithImpl<$Res, $Val extends SizeVariant>
    implements $SizeVariantCopyWith<$Res> {
  _$SizeVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SizeVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? size = null,
    Object? price = null,
    Object? shopPrice = null,
    Object? websiteCommission = null,
    Object? stock = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? status = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            shopPrice: null == shopPrice
                ? _value.shopPrice
                : shopPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            websiteCommission: null == websiteCommission
                ? _value.websiteCommission
                : websiteCommission // ignore: cast_nullable_to_non_nullable
                      as double,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SizeVariantImplCopyWith<$Res>
    implements $SizeVariantCopyWith<$Res> {
  factory _$$SizeVariantImplCopyWith(
    _$SizeVariantImpl value,
    $Res Function(_$SizeVariantImpl) then,
  ) = __$$SizeVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String size,
    double price,
    double shopPrice,
    double websiteCommission,
    int stock,
    bool isAvailable,
    bool isActive,
    String? status,
  });
}

/// @nodoc
class __$$SizeVariantImplCopyWithImpl<$Res>
    extends _$SizeVariantCopyWithImpl<$Res, _$SizeVariantImpl>
    implements _$$SizeVariantImplCopyWith<$Res> {
  __$$SizeVariantImplCopyWithImpl(
    _$SizeVariantImpl _value,
    $Res Function(_$SizeVariantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SizeVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? size = null,
    Object? price = null,
    Object? shopPrice = null,
    Object? websiteCommission = null,
    Object? stock = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? status = freezed,
  }) {
    return _then(
      _$SizeVariantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        shopPrice: null == shopPrice
            ? _value.shopPrice
            : shopPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        websiteCommission: null == websiteCommission
            ? _value.websiteCommission
            : websiteCommission // ignore: cast_nullable_to_non_nullable
                  as double,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SizeVariantImpl implements _SizeVariant {
  const _$SizeVariantImpl({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    this.shopPrice = 0,
    this.websiteCommission = 0,
    required this.stock,
    this.isAvailable = true,
    this.isActive = true,
    this.status,
  });

  factory _$SizeVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$SizeVariantImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String size;
  @override
  final double price;
  @override
  @JsonKey()
  final double shopPrice;
  @override
  @JsonKey()
  final double websiteCommission;
  @override
  final int stock;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? status;

  @override
  String toString() {
    return 'SizeVariant(id: $id, name: $name, size: $size, price: $price, shopPrice: $shopPrice, websiteCommission: $websiteCommission, stock: $stock, isAvailable: $isAvailable, isActive: $isActive, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SizeVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.shopPrice, shopPrice) ||
                other.shopPrice == shopPrice) &&
            (identical(other.websiteCommission, websiteCommission) ||
                other.websiteCommission == websiteCommission) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    size,
    price,
    shopPrice,
    websiteCommission,
    stock,
    isAvailable,
    isActive,
    status,
  );

  /// Create a copy of SizeVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SizeVariantImplCopyWith<_$SizeVariantImpl> get copyWith =>
      __$$SizeVariantImplCopyWithImpl<_$SizeVariantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SizeVariantImplToJson(this);
  }
}

abstract class _SizeVariant implements SizeVariant {
  const factory _SizeVariant({
    required final String id,
    required final String name,
    required final String size,
    required final double price,
    final double shopPrice,
    final double websiteCommission,
    required final int stock,
    final bool isAvailable,
    final bool isActive,
    final String? status,
  }) = _$SizeVariantImpl;

  factory _SizeVariant.fromJson(Map<String, dynamic> json) =
      _$SizeVariantImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get size;
  @override
  double get price;
  @override
  double get shopPrice;
  @override
  double get websiteCommission;
  @override
  int get stock;
  @override
  bool get isAvailable;
  @override
  bool get isActive;
  @override
  String? get status;

  /// Create a copy of SizeVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SizeVariantImplCopyWith<_$SizeVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
