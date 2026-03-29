// feature-first: CartItem. Freezed, immutable. Depends on ProductModel.

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../products/models/product_model.dart';

part 'gen/cart_item_model.freezed.dart';
part 'gen/cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required ProductModel product,
    required String selectedSize,
    String? selectedColor,
    @Default(1) int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  double get totalPrice => product.price * quantity;
}

/// Wrapper for API cart items: includes server-side [id] for update/remove. [item] is the cart row.
class CartItemWithId {
  const CartItemWithId({required this.id, required this.item});
  final String id;
  final CartItemModel item;
}
