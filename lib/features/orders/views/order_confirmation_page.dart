// Redesigned for WESTERN GRAM: high-end, directorial archival aesthetic.
// Implements a minimalist receipt-style layout with premium typography.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants.dart';
import '../models/order_model.dart';
import '../../checkout/services/shipping_service.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key, this.orderId});
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    String? id = orderId;
    OrderModel? order;
    if (arg is OrderModel) {
      order = arg;
      id = order.id;
    } else if (arg is String) {
      id ??= arg;
    }

    double shippingCharge = 0;
    String courierName = "N/A";
    if (order?.customerInfo != null) {
      final ci = order!.customerInfo!;
      final rates = ShippingService.getShippingOptions(ci.state, ci.city);
      shippingCharge = rates[ci.courierService] ?? 0;
      courierName = ci.courierService;
    }
    double totalAmount = (order?.totalAmount ?? 0) + shippingCharge;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        shape: const Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
        title: Column(
          children: [
            const Text(
              'WESTERN GRAM',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 4,
              ),
            ),
            Text(
              'ORDER AUTHENTICATION',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 7,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 900;
          final maxWidth = isWeb ? 500.0 : double.infinity;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuart,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // Status Circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 48),

                      // Headlines
                      const Text(
                        'ORDER SECURED',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'YOUR TRANSACTION HAS BEEN VERIFIED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 64),

                      // Receipt Style Details
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          border: Border.all(color: const Color(0xFFF0F0F0)),
                        ),
                        child: Column(
                          children: [
                              _receiptEntry('ORDER IDENTIFIER', '#${id ?? "WG-PENDING"}'),
                              const SizedBox(height: 32),
                              if (order != null && order.customerInfo != null) ...[
                                _receiptMultilineEntry('ADDRESS', '${order.customerInfo!.address}, ${order.customerInfo!.city}, ${order.customerInfo!.state} ${order.customerInfo!.pincode}'),
                                const SizedBox(height: 32),
                                _receiptEntry('COURIER', courierName.toUpperCase()),
                                const SizedBox(height: 32),
                                _receiptProductsList(order),
                                const SizedBox(height: 32),
                                _receiptEntry('SUBTOTAL', '₹${order.totalAmount.toInt()}'),
                                const SizedBox(height: 16),
                                _receiptEntry('SHIPPING', '₹${shippingCharge.toInt()}'),
                                const SizedBox(height: 24),
                                _receiptEntry('TOTAL AMOUNT', '₹${totalAmount.toInt()}'),
                                const SizedBox(height: 32),
                              ],
                              if (order == null) ...[
                                _receiptEntry('EST. DELIVERY', Constants.deliveryDays.toUpperCase()),
                                const SizedBox(height: 32),
                              ],
                              Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'STATUS',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'ACCOMPLISHED',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 64),

                      // Action Stack
                      Column(
                        children: [
                          _actionButton(
                            label: 'FINALIZE ON WHATSAPP',
                            onTap: () async {
                              String msg = 'Hi Westergram, I want to confirm my order: #${id ?? "WG-NEW"}';
                              if (order != null) {
                                // Simple list if order is present
                                String items = order.items.map((i) => "${i.product.name} (Qty: ${i.quantity})").join(", ");
                                msg += "\nItems: $items\nTotal: ₹${totalAmount.toInt()}";
                              }
                              final url = 'https://wa.me/${Constants.orderWhatsAppNumber}?text=${Uri.encodeComponent(msg)}';
                              final uri = Uri.parse(url);
                              try {
                                await launchUrl(uri, mode: LaunchMode.platformDefault);
                              } catch (_) {
                                // Show explicit info if even manual click fails
                              }
                            },
                            isPrimary: true,
                            icon: Icons.chat_bubble_outline_rounded,
                          ),
                          const SizedBox(height: 16),
                          _actionButton(
                            label: 'CONTINUE DISCOVERY',
                            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                            isPrimary: false,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                            child: const Text(
                              'VIEW ARCHIVE STATUS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 80),

                      // Footer
                      const Text(
                        'WESTERN GRAM',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'THANK YOU FOR YOUR PATRONAGE',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _receiptEntry(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: const Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.black : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 22),
          side: isPrimary ? null : const BorderSide(color: Color(0xFFF0F0F0)),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: isPrimary ? 8 : 0,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptMultilineEntry(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 0.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: const Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _receiptProductsList(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRODUCTS',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ...order.items.map((item) {
          final color = item.selectedColor ?? "N/A";
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size: ${item.selectedSize} | Color: $color | Qty: ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${item.totalPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        Container(height: 1, color: const Color(0xFFEEEEEE)),
      ],
    );
  }
}
