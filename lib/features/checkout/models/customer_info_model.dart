// feature-first: CustomerInfo for checkout/orders. Freezed, immutable.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gen/customer_info_model.freezed.dart';
part 'gen/customer_info_model.g.dart';

@freezed
class CustomerInfoModel with _$CustomerInfoModel {
  const factory CustomerInfoModel({
    required String name,
    required String address,
    required String city,
    required String district,
    required String state,
    required String pincode,
    required String contactNo,
    @Default('DTDC') String courierService,
  }) = _CustomerInfoModel;

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoModelFromJson(json);
}
