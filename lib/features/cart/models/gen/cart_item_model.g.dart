// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      selectedSize: json['selectedSize'] as String,
      selectedColor: json['selectedColor'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'product': instance.product,
      'selectedSize': instance.selectedSize,
      'selectedColor': instance.selectedColor,
      'quantity': instance.quantity,
    };
