import 'product.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({Product? product, String? selectedSize, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product.id == product.id &&
        other.selectedSize == selectedSize;
  }

  @override
  int get hashCode => product.id.hashCode ^ selectedSize.hashCode;
}
