import 'package:freezed_annotation/freezed_annotation.dart';

part 'gen/product_model.freezed.dart';
part 'gen/product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    String? image,
    required List<String> images,
    required double price,
    @Default(0) double shopPrice,
    @Default(0) double websiteCommission,
    @Default(false) bool isFeatured,
    @Default(true) bool isAvailable,
    @Default(false) bool isSoldOut,
    @Default(true) bool isActive,
    String? categoryId,
    String? categoryName,
    List<ColorVariant>? variants,
    // Keep these for backward compatibility if needed, but they might be null/empty
    String? color,
    int? quantity,
    List<String>? availableSizes,
    String? parentId,
    String? status,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
class ColorVariant with _$ColorVariant {
  const factory ColorVariant({
    String? id,
    required String color,
    @Default([]) List<String> images,
    required String image,
    required List<SizeVariant> sizes,
  }) = _ColorVariant;

  factory ColorVariant.fromJson(Map<String, dynamic> json) =>
      _$ColorVariantFromJson(json);
}

@freezed
class SizeVariant with _$SizeVariant {
  const factory SizeVariant({
    required String id,
    required String name,
    required String size,
    required double price,
    @Default(0) double shopPrice,
    @Default(0) double websiteCommission,
    required int stock,
    @Default(true) bool isAvailable,
    @Default(true) bool isActive,
    String? status,
  }) = _SizeVariant;

  factory SizeVariant.fromJson(Map<String, dynamic> json) =>
      _$SizeVariantFromJson(json);
}
