// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String? ?? 'pending',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      customerInfo: json['customerInfo'] == null
          ? null
          : CustomerInfoModel.fromJson(
              json['customerInfo'] as Map<String, dynamic>,
            ),
      commission: (json['commission'] as num?)?.toDouble() ?? 50.0,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'orderDate': instance.orderDate.toIso8601String(),
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'customerInfo': instance.customerInfo,
      'commission': instance.commission,
    };
