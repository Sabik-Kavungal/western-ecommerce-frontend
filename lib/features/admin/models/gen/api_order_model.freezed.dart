// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../api_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiOrderItem _$ApiOrderItemFromJson(Map<String, dynamic> json) {
  return _ApiOrderItem.fromJson(json);
}

/// @nodoc
mixin _$ApiOrderItem {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double get shopPrice => throw _privateConstructorUsedError;
  double get websiteCommission => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;

  /// Serializes this ApiOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiOrderItemCopyWith<ApiOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiOrderItemCopyWith<$Res> {
  factory $ApiOrderItemCopyWith(
    ApiOrderItem value,
    $Res Function(ApiOrderItem) then,
  ) = _$ApiOrderItemCopyWithImpl<$Res, ApiOrderItem>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int quantity,
    String size,
    double price,
    double totalPrice,
    double shopPrice,
    double websiteCommission,
    String color,
    String image,
    List<String> images,
  });
}

/// @nodoc
class _$ApiOrderItemCopyWithImpl<$Res, $Val extends ApiOrderItem>
    implements $ApiOrderItemCopyWith<$Res> {
  _$ApiOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? size = null,
    Object? price = null,
    Object? totalPrice = null,
    Object? shopPrice = null,
    Object? websiteCommission = null,
    Object? color = null,
    Object? image = null,
    Object? images = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            shopPrice: null == shopPrice
                ? _value.shopPrice
                : shopPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            websiteCommission: null == websiteCommission
                ? _value.websiteCommission
                : websiteCommission // ignore: cast_nullable_to_non_nullable
                      as double,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiOrderItemImplCopyWith<$Res>
    implements $ApiOrderItemCopyWith<$Res> {
  factory _$$ApiOrderItemImplCopyWith(
    _$ApiOrderItemImpl value,
    $Res Function(_$ApiOrderItemImpl) then,
  ) = __$$ApiOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int quantity,
    String size,
    double price,
    double totalPrice,
    double shopPrice,
    double websiteCommission,
    String color,
    String image,
    List<String> images,
  });
}

/// @nodoc
class __$$ApiOrderItemImplCopyWithImpl<$Res>
    extends _$ApiOrderItemCopyWithImpl<$Res, _$ApiOrderItemImpl>
    implements _$$ApiOrderItemImplCopyWith<$Res> {
  __$$ApiOrderItemImplCopyWithImpl(
    _$ApiOrderItemImpl _value,
    $Res Function(_$ApiOrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? size = null,
    Object? price = null,
    Object? totalPrice = null,
    Object? shopPrice = null,
    Object? websiteCommission = null,
    Object? color = null,
    Object? image = null,
    Object? images = null,
  }) {
    return _then(
      _$ApiOrderItemImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        shopPrice: null == shopPrice
            ? _value.shopPrice
            : shopPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        websiteCommission: null == websiteCommission
            ? _value.websiteCommission
            : websiteCommission // ignore: cast_nullable_to_non_nullable
                  as double,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiOrderItemImpl implements _ApiOrderItem {
  const _$ApiOrderItemImpl({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.size,
    required this.price,
    required this.totalPrice,
    this.shopPrice = 0,
    this.websiteCommission = 0,
    required this.color,
    this.image = '',
    final List<String> images = const [],
  }) : _images = images;

  factory _$ApiOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiOrderItemImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int quantity;
  @override
  final String size;
  @override
  final double price;
  @override
  final double totalPrice;
  @override
  @JsonKey()
  final double shopPrice;
  @override
  @JsonKey()
  final double websiteCommission;
  @override
  final String color;
  @override
  @JsonKey()
  final String image;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'ApiOrderItem(productId: $productId, productName: $productName, quantity: $quantity, size: $size, price: $price, totalPrice: $totalPrice, shopPrice: $shopPrice, websiteCommission: $websiteCommission, color: $color, image: $image, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiOrderItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.shopPrice, shopPrice) ||
                other.shopPrice == shopPrice) &&
            (identical(other.websiteCommission, websiteCommission) ||
                other.websiteCommission == websiteCommission) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    productName,
    quantity,
    size,
    price,
    totalPrice,
    shopPrice,
    websiteCommission,
    color,
    image,
    const DeepCollectionEquality().hash(_images),
  );

  /// Create a copy of ApiOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiOrderItemImplCopyWith<_$ApiOrderItemImpl> get copyWith =>
      __$$ApiOrderItemImplCopyWithImpl<_$ApiOrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiOrderItemImplToJson(this);
  }
}

abstract class _ApiOrderItem implements ApiOrderItem {
  const factory _ApiOrderItem({
    required final String productId,
    required final String productName,
    required final int quantity,
    required final String size,
    required final double price,
    required final double totalPrice,
    final double shopPrice,
    final double websiteCommission,
    required final String color,
    final String image,
    final List<String> images,
  }) = _$ApiOrderItemImpl;

  factory _ApiOrderItem.fromJson(Map<String, dynamic> json) =
      _$ApiOrderItemImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get quantity;
  @override
  String get size;
  @override
  double get price;
  @override
  double get totalPrice;
  @override
  double get shopPrice;
  @override
  double get websiteCommission;
  @override
  String get color;
  @override
  String get image;
  @override
  List<String> get images;

  /// Create a copy of ApiOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiOrderItemImplCopyWith<_$ApiOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiOrderModel _$ApiOrderModelFromJson(Map<String, dynamic> json) {
  return _ApiOrderModel.fromJson(json);
}

/// @nodoc
mixin _$ApiOrderModel {
  String get id => throw _privateConstructorUsedError;
  List<ApiOrderItem> get items => throw _privateConstructorUsedError;
  DateTime get orderDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  CustomerInfoModel? get customerInfo => throw _privateConstructorUsedError;
  double get commission => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get paymentScreenshot => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ApiOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiOrderModelCopyWith<ApiOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiOrderModelCopyWith<$Res> {
  factory $ApiOrderModelCopyWith(
    ApiOrderModel value,
    $Res Function(ApiOrderModel) then,
  ) = _$ApiOrderModelCopyWithImpl<$Res, ApiOrderModel>;
  @useResult
  $Res call({
    String id,
    List<ApiOrderItem> items,
    DateTime orderDate,
    String status,
    double totalAmount,
    CustomerInfoModel? customerInfo,
    double commission,
    String paymentStatus,
    String? paymentScreenshot,
    String? createdAt,
    String? updatedAt,
  });

  $CustomerInfoModelCopyWith<$Res>? get customerInfo;
}

/// @nodoc
class _$ApiOrderModelCopyWithImpl<$Res, $Val extends ApiOrderModel>
    implements $ApiOrderModelCopyWith<$Res> {
  _$ApiOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? orderDate = null,
    Object? status = null,
    Object? totalAmount = null,
    Object? customerInfo = freezed,
    Object? commission = null,
    Object? paymentStatus = null,
    Object? paymentScreenshot = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ApiOrderItem>,
            orderDate: null == orderDate
                ? _value.orderDate
                : orderDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            customerInfo: freezed == customerInfo
                ? _value.customerInfo
                : customerInfo // ignore: cast_nullable_to_non_nullable
                      as CustomerInfoModel?,
            commission: null == commission
                ? _value.commission
                : commission // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentScreenshot: freezed == paymentScreenshot
                ? _value.paymentScreenshot
                : paymentScreenshot // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ApiOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerInfoModelCopyWith<$Res>? get customerInfo {
    if (_value.customerInfo == null) {
      return null;
    }

    return $CustomerInfoModelCopyWith<$Res>(_value.customerInfo!, (value) {
      return _then(_value.copyWith(customerInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiOrderModelImplCopyWith<$Res>
    implements $ApiOrderModelCopyWith<$Res> {
  factory _$$ApiOrderModelImplCopyWith(
    _$ApiOrderModelImpl value,
    $Res Function(_$ApiOrderModelImpl) then,
  ) = __$$ApiOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    List<ApiOrderItem> items,
    DateTime orderDate,
    String status,
    double totalAmount,
    CustomerInfoModel? customerInfo,
    double commission,
    String paymentStatus,
    String? paymentScreenshot,
    String? createdAt,
    String? updatedAt,
  });

  @override
  $CustomerInfoModelCopyWith<$Res>? get customerInfo;
}

/// @nodoc
class __$$ApiOrderModelImplCopyWithImpl<$Res>
    extends _$ApiOrderModelCopyWithImpl<$Res, _$ApiOrderModelImpl>
    implements _$$ApiOrderModelImplCopyWith<$Res> {
  __$$ApiOrderModelImplCopyWithImpl(
    _$ApiOrderModelImpl _value,
    $Res Function(_$ApiOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? orderDate = null,
    Object? status = null,
    Object? totalAmount = null,
    Object? customerInfo = freezed,
    Object? commission = null,
    Object? paymentStatus = null,
    Object? paymentScreenshot = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ApiOrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ApiOrderItem>,
        orderDate: null == orderDate
            ? _value.orderDate
            : orderDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        customerInfo: freezed == customerInfo
            ? _value.customerInfo
            : customerInfo // ignore: cast_nullable_to_non_nullable
                  as CustomerInfoModel?,
        commission: null == commission
            ? _value.commission
            : commission // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentScreenshot: freezed == paymentScreenshot
            ? _value.paymentScreenshot
            : paymentScreenshot // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiOrderModelImpl implements _ApiOrderModel {
  const _$ApiOrderModelImpl({
    required this.id,
    required final List<ApiOrderItem> items,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    this.customerInfo,
    this.commission = 0,
    this.paymentStatus = 'pending',
    this.paymentScreenshot,
    this.createdAt,
    this.updatedAt,
  }) : _items = items;

  factory _$ApiOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiOrderModelImplFromJson(json);

  @override
  final String id;
  final List<ApiOrderItem> _items;
  @override
  List<ApiOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime orderDate;
  @override
  final String status;
  @override
  final double totalAmount;
  @override
  final CustomerInfoModel? customerInfo;
  @override
  @JsonKey()
  final double commission;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  final String? paymentScreenshot;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'ApiOrderModel(id: $id, items: $items, orderDate: $orderDate, status: $status, totalAmount: $totalAmount, customerInfo: $customerInfo, commission: $commission, paymentStatus: $paymentStatus, paymentScreenshot: $paymentScreenshot, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.customerInfo, customerInfo) ||
                other.customerInfo == customerInfo) &&
            (identical(other.commission, commission) ||
                other.commission == commission) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentScreenshot, paymentScreenshot) ||
                other.paymentScreenshot == paymentScreenshot) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_items),
    orderDate,
    status,
    totalAmount,
    customerInfo,
    commission,
    paymentStatus,
    paymentScreenshot,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ApiOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiOrderModelImplCopyWith<_$ApiOrderModelImpl> get copyWith =>
      __$$ApiOrderModelImplCopyWithImpl<_$ApiOrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiOrderModelImplToJson(this);
  }
}

abstract class _ApiOrderModel implements ApiOrderModel {
  const factory _ApiOrderModel({
    required final String id,
    required final List<ApiOrderItem> items,
    required final DateTime orderDate,
    required final String status,
    required final double totalAmount,
    final CustomerInfoModel? customerInfo,
    final double commission,
    final String paymentStatus,
    final String? paymentScreenshot,
    final String? createdAt,
    final String? updatedAt,
  }) = _$ApiOrderModelImpl;

  factory _ApiOrderModel.fromJson(Map<String, dynamic> json) =
      _$ApiOrderModelImpl.fromJson;

  @override
  String get id;
  @override
  List<ApiOrderItem> get items;
  @override
  DateTime get orderDate;
  @override
  String get status;
  @override
  double get totalAmount;
  @override
  CustomerInfoModel? get customerInfo;
  @override
  double get commission;
  @override
  String get paymentStatus;
  @override
  String? get paymentScreenshot;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of ApiOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiOrderModelImplCopyWith<_$ApiOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
