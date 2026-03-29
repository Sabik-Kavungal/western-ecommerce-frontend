import 'package:freezed_annotation/freezed_annotation.dart';
import '../../checkout/models/customer_info_model.dart';

part 'gen/api_order_model.freezed.dart';
part 'gen/api_order_model.g.dart';

@freezed
class ApiOrderItem with _$ApiOrderItem {
  const factory ApiOrderItem({
    required String productId,
    required String productName,
    required int quantity,
    required String size,
    required double price,
    required double totalPrice,
    @Default(0) double shopPrice,
    @Default(0) double websiteCommission,
    required String color,
    @Default('') String image,
    @Default([]) List<String> images,
  }) = _ApiOrderItem;

  factory ApiOrderItem.fromJson(Map<String, dynamic> json) =>
      _$ApiOrderItemFromJson(json);
}

@freezed
class ApiOrderModel with _$ApiOrderModel {
  const factory ApiOrderModel({
    required String id,
    required List<ApiOrderItem> items,
    required DateTime orderDate,
    required String status,
    required double totalAmount,
    CustomerInfoModel? customerInfo,
    @Default(0) double commission,
    @Default('pending') String paymentStatus,
    String? paymentScreenshot,
    String? createdAt,
    String? updatedAt,
  }) = _ApiOrderModel;

  factory ApiOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ApiOrderModelFromJson(json);
}
