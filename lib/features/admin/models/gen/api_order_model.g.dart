// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../api_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiOrderItemImpl _$$ApiOrderItemImplFromJson(Map<String, dynamic> json) =>
    _$ApiOrderItemImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      shopPrice: (json['shopPrice'] as num?)?.toDouble() ?? 0,
      websiteCommission: (json['websiteCommission'] as num?)?.toDouble() ?? 0,
      color: json['color'] as String,
      image: json['image'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ApiOrderItemImplToJson(_$ApiOrderItemImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'size': instance.size,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
      'shopPrice': instance.shopPrice,
      'websiteCommission': instance.websiteCommission,
      'color': instance.color,
      'image': instance.image,
      'images': instance.images,
    };

_$ApiOrderModelImpl _$$ApiOrderModelImplFromJson(Map<String, dynamic> json) =>
    _$ApiOrderModelImpl(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ApiOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      customerInfo: json['customerInfo'] == null
          ? null
          : CustomerInfoModel.fromJson(
              json['customerInfo'] as Map<String, dynamic>,
            ),
      commission: (json['commission'] as num?)?.toDouble() ?? 0,
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
      paymentScreenshot: json['paymentScreenshot'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$ApiOrderModelImplToJson(_$ApiOrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'orderDate': instance.orderDate.toIso8601String(),
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'customerInfo': instance.customerInfo,
      'commission': instance.commission,
      'paymentStatus': instance.paymentStatus,
      'paymentScreenshot': instance.paymentScreenshot,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
