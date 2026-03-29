import 'package:flutter/material.dart';
import '../features/cart/models/cart_item_model.dart';
import '../core/constants/app_constants.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel cartItem;
  final String? itemId;
  final VoidCallback? onRemove;
  final void Function(int)? onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.cartItem,
    this.itemId,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Image Container
          Container(
            width: 90,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.zero, // Hard corners for premium feel
              border: Border.all(color: const Color(0xFFF5F5F5), width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildImage(),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.product.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'WESTERN GRAM COLLECTION',
                            style: TextStyle(
                              fontSize: 7,
                              color: Colors.grey.shade400,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onRemove != null)
                      GestureDetector(
                        onTap: onRemove,
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                // Specifications Chips (Minimalist)
                Row(
                  children: [
                    _specLabel('SIZE', cartItem.selectedSize),
                    const SizedBox(width: 16),
                    if (cartItem.selectedColor != null)
                      _specLabel(
                        'COLOR',
                        cartItem.selectedColor!.toUpperCase(),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price & Quantity Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${cartItem.totalPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.2,
                      ),
                    ),

                    // Controlled Quantity Logic
                    if (onQuantityChanged != null)
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _qtyAction(Icons.remove, () {
                              if (cartItem.quantity > 1) {
                                onQuantityChanged!(cartItem.quantity - 1);
                              }
                            }),
                            Container(
                              constraints: const BoxConstraints(minWidth: 32),
                              alignment: Alignment.center,
                              child: Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _qtyAction(Icons.add, () {
                              onQuantityChanged!(cartItem.quantity + 1);
                            }),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _qtyAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: double.infinity,
        alignment: Alignment.center,
        child: Icon(icon, size: 12, color: Colors.black),
      ),
    );
  }

  Widget _buildImage() {
    final variant = cartItem.product.variants
        ?.where(
          (v) => v.color.toLowerCase() == cartItem.selectedColor?.toLowerCase(),
        )
        .firstOrNull;

    String rawUrl =
        variant?.image ??
        cartItem.product.image ??
        (cartItem.product.images.isNotEmpty ? cartItem.product.images[0] : '');

    if (rawUrl.isEmpty && cartItem.product.images.isNotEmpty) {
      rawUrl = cartItem.product.images[0];
    }

    final displayUrl = rawUrl.startsWith('http')
        ? rawUrl
        : '${Constants.apiOrigin}$rawUrl';

    return displayUrl.isNotEmpty
        ? Image.network(
            displayUrl,
            fit: BoxFit.cover,
            cacheWidth: 300,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
          )
        : const Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 20,
            ),
          );
  }
}
