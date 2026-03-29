// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../customer_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoModelImpl _$$CustomerInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerInfoModelImpl(
  name: json['name'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  district: json['district'] as String,
  state: json['state'] as String,
  pincode: json['pincode'] as String,
  contactNo: json['contactNo'] as String,
  courierService: json['courierService'] as String? ?? 'DTDC',
);

Map<String, dynamic> _$$CustomerInfoModelImplToJson(
  _$CustomerInfoModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'city': instance.city,
  'district': instance.district,
  'state': instance.state,
  'pincode': instance.pincode,
  'contactNo': instance.contactNo,
  'courierService': instance.courierService,
};
