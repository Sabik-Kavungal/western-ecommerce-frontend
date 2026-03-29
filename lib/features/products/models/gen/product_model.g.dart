// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      price: (json['price'] as num).toDouble(),
      shopPrice: (json['shopPrice'] as num?)?.toDouble() ?? 0,
      websiteCommission: (json['websiteCommission'] as num?)?.toDouble() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isSoldOut: json['isSoldOut'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => ColorVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      color: json['color'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      availableSizes: (json['availableSizes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      parentId: json['parentId'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'images': instance.images,
      'price': instance.price,
      'shopPrice': instance.shopPrice,
      'websiteCommission': instance.websiteCommission,
      'isFeatured': instance.isFeatured,
      'isAvailable': instance.isAvailable,
      'isSoldOut': instance.isSoldOut,
      'isActive': instance.isActive,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'variants': instance.variants,
      'color': instance.color,
      'quantity': instance.quantity,
      'availableSizes': instance.availableSizes,
      'parentId': instance.parentId,
      'status': instance.status,
    };

_$ColorVariantImpl _$$ColorVariantImplFromJson(Map<String, dynamic> json) =>
    _$ColorVariantImpl(
      id: json['id'] as String?,
      color: json['color'] as String,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      image: json['image'] as String,
      sizes: (json['sizes'] as List<dynamic>)
          .map((e) => SizeVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ColorVariantImplToJson(_$ColorVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'images': instance.images,
      'image': instance.image,
      'sizes': instance.sizes,
    };

_$SizeVariantImpl _$$SizeVariantImplFromJson(Map<String, dynamic> json) =>
    _$SizeVariantImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      shopPrice: (json['shopPrice'] as num?)?.toDouble() ?? 0,
      websiteCommission: (json['websiteCommission'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$SizeVariantImplToJson(_$SizeVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': instance.size,
      'price': instance.price,
      'shopPrice': instance.shopPrice,
      'websiteCommission': instance.websiteCommission,
      'stock': instance.stock,
      'isAvailable': instance.isAvailable,
      'isActive': instance.isActive,
      'status': instance.status,
    };
