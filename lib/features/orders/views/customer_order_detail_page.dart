// Customer: single order detail. Fetches via OrderApi GET /orders/:id.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e/core/constants/app_color.dart';
import '../../../utils/constants.dart';
import '../viewmodels/order_vm.dart';
import '../models/order_model.dart';
import '../../checkout/models/customer_info_model.dart';
import '../../auth/services/customer_api.dart';
import '../../auth/viewmodels/auth_vm.dart';

class CustomerOrderDetailPage extends StatefulWidget {
  const CustomerOrderDetailPage({super.key, required this.orderId});
  final String orderId;

  @override
  State<CustomerOrderDetailPage> createState() =>
      _CustomerOrderDetailPageState();
}

class _CustomerOrderDetailPageState extends State<CustomerOrderDetailPage> {
  OrderModel? _order;
  bool _loading = true;
  String? _error;

  bool _isEditingAddress = false;
  bool _savingAddress = false;
  String? _addressError;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _contactNoController = TextEditingController();

  String _selectedCourier = 'DTDC';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final vm = context.read<OrderViewModel>();
    OrderModel? o = vm.getOrderById(widget.orderId);

    if (o == null) {
      try {
        o = await vm.fetchOrderById(widget.orderId);
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _order = o;
        _loading = false;
        if (o == null) _error = 'Order not found';
        if (o?.customerInfo != null) {
          _loadAddress(o!.customerInfo!);
        }
      });
    }
  }

  void _loadAddress(CustomerInfoModel c) {
    _nameController.text = c.name;
    _addressController.text = c.address;
    _cityController.text = c.city;
    _districtController.text = c.district;
    _stateController.text = c.state;
    _pincodeController.text = c.pincode;
    _contactNoController.text = c.contactNo;
    _selectedCourier = c.courierService;
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            _error ?? 'Order not found',
            style: const TextStyle(color: AppColors.redAccent),
          ),
        ),
      );
    }

    final o = _order!;
    final d = o.orderDate;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 65,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
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
              'ACQUISITION DETAILS',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            _orderBanner(o, dateStr),
            const SizedBox(height: 24),

            _card(
              icon: Icons.receipt_long_outlined,
              title: 'ORDER SUMMARY',
              child: Column(
                children: [
                  _row('IDENTIFIER', '#${o.id.toUpperCase()}'),
                  _row('TRANSACTION DATE', dateStr),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: Color(0xFFF5F5F5)),
                  ),
                  _row(
                    'TOTAL ACQUISITION',
                    '₹${o.totalAmount.toInt()}',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              icon: Icons.inventory_2_outlined,
              title: 'CURATED PIECES',
              child: Column(
                children: o.items
                    .map(
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (i.product.image != null &&
                                i.product.image!.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: const Color(0xFFF5F5F5),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Image.network(
                                    i.product.image!.startsWith('http')
                                        ? i.product.image!
                                        : '${Constants.apiOrigin}${i.product.image}',
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 80,
                                      height: 100,
                                      color: const Color(0xFFF9F9F9),
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                        size: 20,
                                        color: Colors.black12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (i.product.image != null &&
                                i.product.image!.isNotEmpty)
                              const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i.product.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'Serif',
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'SIZE: ${i.selectedSize}  |  COLOR: ${i.selectedColor?.toUpperCase() ?? "DEFAULT"}',
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black54,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${i.quantity} × ₹${i.product.price.toInt()}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.shade400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${i.totalPrice.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Colors.black,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            if (o.customerInfo != null)
              _card(
                icon: Icons.location_on_outlined,
                title: 'SHIPPING DESTINATION',
                trailing: !_isEditingAddress
                    ? TextButton(
                        onPressed: () =>
                            setState(() => _isEditingAddress = true),
                        child: Text(
                          'AMEND',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey.shade400,
                            letterSpacing: 1.5,
                          ),
                        ),
                      )
                    : null,
                child: _customerBlock(o.customerInfo!),
              ),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _orderBanner(OrderModel o, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF5F5F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${o.id.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PLACED ON $date',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade400,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          _statusChip(o.status),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF5F5F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(width: 20, height: 1.5, color: Colors.grey.shade100),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
              letterSpacing: 1.5,
              color: isTotal ? Colors.black : Colors.grey.shade400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 12,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: isTotal ? -0.5 : 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    final isSpecial =
        status.toLowerCase() == 'pending' ||
        status.toLowerCase() == 'processing' ||
        status.toLowerCase() == 'shipped';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSpecial ? Colors.black : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: isSpecial ? Colors.white : color,
        ),
      ),
    );
  }

  Widget _customerBlock(CustomerInfoModel c) {
    if (_isEditingAddress) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AMEND SHIPPING DESTINATION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'THE AMEND FEATURE IS TEMPORARILY DISABLED. PLEASE CONTACT CONCIERGE IF YOU NEED TO UPDATE DETAILS.',
            style: TextStyle(
              fontSize: 8,
              height: 1.8,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _isEditingAddress = false),
            child: const Text(
              'RETURN TO DETAILS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              size: 16,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Text(
              c.name.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.phone_outlined, size: 16, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              c.contactNo,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 1.5,
          color: const Color(0xFFF9F9F9),
        ),
        const SizedBox(height: 20),
        Text(
          c.address.toUpperCase(),
          style: const TextStyle(
            height: 1.8,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${c.city}, ${c.district}, ${c.state} - ${c.pincode}'.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                size: 16,
                color: Colors.black,
              ),
              const SizedBox(width: 12),
              Text(
                'COURIER: ${c.courierService}'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFE57373);
      case 'shipped':
      case 'pending':
      case 'processing':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}
