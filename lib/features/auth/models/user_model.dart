// feature-first auth: User model matching backend API contract.
// Freezed ensures immutability, fromJson/toJson, and testability.

import 'package:freezed_annotation/freezed_annotation.dart';
part 'gen/user_model.freezed.dart';
part 'gen/user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String phone,
    @JsonKey(name: 'email') String? email,
    @Default('customer') String role,
    @JsonKey(name: 'permissions') List<String>? permissions,
    @JsonKey(name: 'isActive') bool? isActive,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
