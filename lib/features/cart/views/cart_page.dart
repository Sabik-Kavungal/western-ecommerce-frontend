import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_vm.dart';
import '../../../widgets/cart_item_card.dart';
import '../../checkout/checkout_module.dart';
import '../../checkout/services/shipping_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartViewModel? _cartVm;
  CheckoutViewModel? _checkoutVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _cartVm = context.read<CartViewModel>();
      _checkoutVm = context.read<CheckoutViewModel>();
      _cartVm?.loadCart();
      _checkoutVm?.loadSavedAddress();
      _cartVm?.addListener(_handleError);
    });
  }

  @override
  void dispose() {
    _cartVm?.removeListener(_handleError);
    super.dispose();
  }

  void _handleError() {
    if (!mounted || _cartVm == null) return;
    final cartVm = _cartVm!;
    if (cartVm.error != null && cartVm.error!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cartVm.error!.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final horizontalPadding = isWeb
        ? (screenWidth - 800).clamp(20.0, double.infinity) / 2
        : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
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
              'MY BAG COLLECTION',
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
      body: Consumer2<CartViewModel, CheckoutViewModel>(
        builder: (context, cartVm, checkoutVm, _) {
          if (cartVm.isLoading && cartVm.items.isEmpty) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              ),
            );
          }

          if (cartVm.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          String state = checkoutVm.state.isNotEmpty ? checkoutVm.state : 'Karnataka';
          String city = checkoutVm.city.isNotEmpty ? checkoutVm.city : 'Bangalore';
          String courier = checkoutVm.selectedCourier.isNotEmpty ? checkoutVm.selectedCourier : 'DTDC';
          
          Map<String, double> rates = ShippingService.getShippingOptions(state, city);
          double shippingCost = rates[courier] ?? 0;
          double total = cartVm.totalPrice + shippingCost;

          return Column(
            children: [
              // Items List
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: horizontalPadding,
                  ),
                  itemCount: cartVm.items.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, i) {
                    final x = cartVm.items[i];
                    return CartItemCard(
                        cartItem: x.item,
                        itemId: x.id,
                        onRemove: () => cartVm.removeFromCartById(x.id),
                        onQuantityChanged: (q) => cartVm.updateQuantity(x.id, q),
                      );
                  },
                ),
              ),

              // Summary Section
              Container(
                  padding: EdgeInsets.fromLTRB(
                    isWeb ? horizontalPadding : 16,
                    20,
                    isWeb ? horizontalPadding : 16,
                    32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'SUBTOTAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '₹${cartVm.totalPrice.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SHIPPING ${checkoutVm.state.isEmpty ? "(ESTIMATED)" : ""}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '₹${shippingCost.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(height: 1, color: Colors.grey.shade100),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '₹${total.toInt()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomerInfoFormPage(
                                items: cartVm.items.map((e) => e.item).toList(),
                                isSingleProduct: false,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.3),
                          ),
                          child: const Text(
                            'CONTINUE TO SHIPPING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'CURATION EMPTY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'YOUR SELECTION ARCHIVE IS CURRENTLY VACANT.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                letterSpacing: 1.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 240,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: const Text(
                  'BROWSE THE COLLECTION',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
