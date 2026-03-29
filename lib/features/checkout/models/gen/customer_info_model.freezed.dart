// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../customer_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerInfoModel _$CustomerInfoModelFromJson(Map<String, dynamic> json) {
  return _CustomerInfoModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerInfoModel {
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get pincode => throw _privateConstructorUsedError;
  String get contactNo => throw _privateConstructorUsedError;
  String get courierService => throw _privateConstructorUsedError;

  /// Serializes this CustomerInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerInfoModelCopyWith<CustomerInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInfoModelCopyWith<$Res> {
  factory $CustomerInfoModelCopyWith(
    CustomerInfoModel value,
    $Res Function(CustomerInfoModel) then,
  ) = _$CustomerInfoModelCopyWithImpl<$Res, CustomerInfoModel>;
  @useResult
  $Res call({
    String name,
    String address,
    String city,
    String district,
    String state,
    String pincode,
    String contactNo,
    String courierService,
  });
}

/// @nodoc
class _$CustomerInfoModelCopyWithImpl<$Res, $Val extends CustomerInfoModel>
    implements $CustomerInfoModelCopyWith<$Res> {
  _$CustomerInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = null,
    Object? city = null,
    Object? district = null,
    Object? state = null,
    Object? pincode = null,
    Object? contactNo = null,
    Object? courierService = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            district: null == district
                ? _value.district
                : district // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            pincode: null == pincode
                ? _value.pincode
                : pincode // ignore: cast_nullable_to_non_nullable
                      as String,
            contactNo: null == contactNo
                ? _value.contactNo
                : contactNo // ignore: cast_nullable_to_non_nullable
                      as String,
            courierService: null == courierService
                ? _value.courierService
                : courierService // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerInfoModelImplCopyWith<$Res>
    implements $CustomerInfoModelCopyWith<$Res> {
  factory _$$CustomerInfoModelImplCopyWith(
    _$CustomerInfoModelImpl value,
    $Res Function(_$CustomerInfoModelImpl) then,
  ) = __$$CustomerInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String address,
    String city,
    String district,
    String state,
    String pincode,
    String contactNo,
    String courierService,
  });
}

/// @nodoc
class __$$CustomerInfoModelImplCopyWithImpl<$Res>
    extends _$CustomerInfoModelCopyWithImpl<$Res, _$CustomerInfoModelImpl>
    implements _$$CustomerInfoModelImplCopyWith<$Res> {
  __$$CustomerInfoModelImplCopyWithImpl(
    _$CustomerInfoModelImpl _value,
    $Res Function(_$CustomerInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = null,
    Object? city = null,
    Object? district = null,
    Object? state = null,
    Object? pincode = null,
    Object? contactNo = null,
    Object? courierService = null,
  }) {
    return _then(
      _$CustomerInfoModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        district: null == district
            ? _value.district
            : district // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        pincode: null == pincode
            ? _value.pincode
            : pincode // ignore: cast_nullable_to_non_nullable
                  as String,
        contactNo: null == contactNo
            ? _value.contactNo
            : contactNo // ignore: cast_nullable_to_non_nullable
                  as String,
        courierService: null == courierService
            ? _value.courierService
            : courierService // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInfoModelImpl implements _CustomerInfoModel {
  const _$CustomerInfoModelImpl({
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
    required this.contactNo,
    this.courierService = 'DTDC',
  });

  factory _$CustomerInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInfoModelImplFromJson(json);

  @override
  final String name;
  @override
  final String address;
  @override
  final String city;
  @override
  final String district;
  @override
  final String state;
  @override
  final String pincode;
  @override
  final String contactNo;
  @override
  @JsonKey()
  final String courierService;

  @override
  String toString() {
    return 'CustomerInfoModel(name: $name, address: $address, city: $city, district: $district, state: $state, pincode: $pincode, contactNo: $contactNo, courierService: $courierService)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInfoModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.contactNo, contactNo) ||
                other.contactNo == contactNo) &&
            (identical(other.courierService, courierService) ||
                other.courierService == courierService));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    address,
    city,
    district,
    state,
    pincode,
    contactNo,
    courierService,
  );

  /// Create a copy of CustomerInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInfoModelImplCopyWith<_$CustomerInfoModelImpl> get copyWith =>
      __$$CustomerInfoModelImplCopyWithImpl<_$CustomerInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInfoModelImplToJson(this);
  }
}

abstract class _CustomerInfoModel implements CustomerInfoModel {
  const factory _CustomerInfoModel({
    required final String name,
    required final String address,
    required final String city,
    required final String district,
    required final String state,
    required final String pincode,
    required final String contactNo,
    final String courierService,
  }) = _$CustomerInfoModelImpl;

  factory _CustomerInfoModel.fromJson(Map<String, dynamic> json) =
      _$CustomerInfoModelImpl.fromJson;

  @override
  String get name;
  @override
  String get address;
  @override
  String get city;
  @override
  String get district;
  @override
  String get state;
  @override
  String get pincode;
  @override
  String get contactNo;
  @override
  String get courierService;

  /// Create a copy of CustomerInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInfoModelImplCopyWith<_$CustomerInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
