// Admin: Order Detail Archive. Redesigned for a high-end editorial boutique experience.
// Aligns with the WESTERN GRAM archival aesthetic: high-contrast, monochromatic, and structured.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants.dart';
import '../../admin/admin_module.dart';
import '../../checkout/models/customer_info_model.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOrderViewModel>().loadOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'TRANSACTION ARCHIVE',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 7,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<AdminOrderViewModel>(
            builder: (_, vm, __) {
              if (vm.selectedOrder == null) return const SizedBox();
              return IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: () => _confirmDelete(context, vm),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Consumer<AdminOrderViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.selectedOrder == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            );
          }

          final o = vm.selectedOrder;
          if (o == null) {
            return Center(
              child: Text(
                'RECORD NOT FOUND',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.grey.shade400,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderHeader(o),
                const SizedBox(height: 48),

                _sectionTitle('ARCHIVAL SUMMARY'),
                _buildSummarySection(o),
                const SizedBox(height: 48),

                _sectionTitle('CURATED ITEMS'),
                _buildItemsSection(o),
                const SizedBox(height: 48),

                if (o.customerInfo != null) ...[
                  _sectionTitle('SHIPPING CREDENTIALS'),
                  _buildCustomerSection(o.customerInfo!),
                  const SizedBox(height: 48),
                ],

                _sectionTitle('ADMINISTRATIVE CONTROLS'),
                _buildActionSection(context, vm, o),
                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: const Color(0xFFF5F5F5))),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(ApiOrderModel o) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WG_BATCH#${o.id.length > 8 ? o.id.substring(o.id.length - 8).toUpperCase() : o.id.toUpperCase()}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat(
                'MMMM dd, yyyy · HH:mm',
              ).format(o.orderDate).toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        _statusIndicator(o.status),
      ],
    );
  }

  Widget _buildSummarySection(ApiOrderModel o) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Column(
        children: [
          _row(
            'TOTAL AMOUNT',
            '₹${o.totalAmount.toStringAsFixed(0)}',
            isBold: true,
          ),
          _row('COMMISSION FEE', '₹${o.commission.toStringAsFixed(0)}'),
          _row(
            'PAYMENT STATUS',
            o.paymentStatus.toUpperCase(),
            valueColor: _paymentColor(o.paymentStatus),
          ),
          _row(
            'LOGISTICS MODE',
            o.customerInfo?.courierService.toUpperCase() ?? 'STANDARD',
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(ApiOrderModel o) {
    return Column(
      children: o.items.map((i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF5F5F5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  border: Border.all(color: const Color(0xFFF5F5F5)),
                ),
                clipBehavior: Clip.antiAlias,
                child: i.image.isNotEmpty
                    ? Image.network(
                        i.image.startsWith('http')
                            ? i.image
                            : '${Constants.apiOrigin}${i.image}',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.broken_image_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                    : const Icon(
                        Icons.inventory_2_outlined,
                        size: 20,
                        color: Colors.black12,
                      ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i.productName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'SZ: ${i.size} · CLR: ${i.color.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'QUANTITY: ${i.quantity}',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${i.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomerSection(CustomerInfoModel c) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            c.contactNo,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: const Color(0xFFF5F5F5)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ADDRESS',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final text =
                      '* Name: ${c.name}\n'
                      '* Mobile: ${c.contactNo}\n'
                      '* Address: ${c.address}\n'
                      '* City: ${c.city}\n'
                      '* District: ${c.district}\n'
                      '* State: ${c.state}\n'
                      '* Pincode: ${c.pincode}\n'
                      '* Courier: ${c.courierService.toUpperCase()}';
                  await Clipboard.setData(ClipboardData(text: text));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'ADDRESS COPIED TO ARCHIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        backgroundColor: Colors.black,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: Text(
                  'COPY ADDRESS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue.shade700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${c.address}\n${c.city.toUpperCase()}, ${c.district.toUpperCase()}\n${c.state.toUpperCase()} - ${c.pincode}',
            style: const TextStyle(
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'LOGISTICS: ${c.courierService.toUpperCase()}',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.grey.shade400,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(
    BuildContext context,
    AdminOrderViewModel vm,
    ApiOrderModel o,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statusDropdown(vm, o)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _showPaymentDialog(context, vm, o.id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Text(
                  'VERIFY PAYMENT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.grey.shade400,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              color: valueColor ?? Colors.black,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusIndicator(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _statusDropdown(AdminOrderViewModel vm, ApiOrderModel o) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: o.status,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          items: ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled']
              .map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(
                    s.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                );
              })
              .toList(),
          onChanged: (v) {
            if (v != null) vm.updateStatus(o.id, v);
          },
        ),
      ),
    );
  }

  Color _paymentColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green.shade700;
      case 'failed':
        return Colors.red.shade700;
      default:
        return Colors.orange.shade700;
    }
  }

  void _confirmDelete(BuildContext context, AdminOrderViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text(
          'PURGE TRANSACTION?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
        content: const Text(
          'This action is irreversible and will permanently remove this record from the archive.',
          style: TextStyle(fontSize: 12, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              vm.deleteOrder(widget.orderId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'PURGE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    AdminOrderViewModel vm,
    String orderId,
  ) {
    String status = 'verified';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text(
          'CREDENTIAL VERIFICATION',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 13,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(
                labelText: 'PAYMENT STATUS',
                labelStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                border: UnderlineInputBorder(),
              ),
              items: ['pending', 'verified', 'failed']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setDialogState(() => status = v ?? status),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              vm.verifyPayment(orderId, status);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'SUBMIT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
