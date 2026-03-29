import 'package:freezed_annotation/freezed_annotation.dart';
part 'gen/category_model.freezed.dart';
part 'gen/category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
