// feature-first auth: Token model for JWT + optional refresh (backend: JWT + Refresh tokens).
// Freezed for immutability and JSON (fromJson/toJson).

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gen/token_model.freezed.dart';
part 'gen/token_model.g.dart';

@freezed
class TokenModel with _$TokenModel {
  const factory TokenModel({
    required String token,
    @JsonKey(name: 'refreshToken') String? refreshToken,
    @JsonKey(name: 'expiresIn') int? expiresIn,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
}
