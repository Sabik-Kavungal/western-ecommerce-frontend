// Admin: Order management optimized for an editorial, archival aesthetic.
// Redesigned for WESTERN GRAM to feel more like a luxury control center.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants.dart';
import '../../admin/admin_module.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOrderViewModel>().loadOrders();
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
              'ORDER MANAGEMENT ARCHIVE',
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
      body: Consumer<AdminOrderViewModel>(
        builder: (context, vm, _) {
          if (vm.successMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    vm.successMessage!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              vm.clearSuccessMessage();
            });
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWeb = constraints.maxWidth > 900;

              return Column(
                children: [
                  // Filter Section
                  _buildHeaderAndFilters(vm, isWeb),

                  // Error Display
                  if (vm.error != null && vm.error!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      color: Colors.red.withOpacity(0.05),
                      child: Text(
                        vm.error!.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                  // Order List
                  Expanded(child: _buildOrderList(vm, isWeb)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeaderAndFilters(AdminOrderViewModel vm, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'COLLECTION STATUS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 24, height: 1.5, color: Colors.black),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _filterIndicator(vm, '', 'ALL ARCHIVE'),
                _filterIndicator(vm, 'pending', 'PENDING'),
                _filterIndicator(vm, 'confirmed', 'CONFIRMED'),
                _filterIndicator(vm, 'shipped', 'SHIPPED'),
                _filterIndicator(vm, 'delivered', 'DELIVERED'),
                _filterIndicator(vm, 'cancelled', 'CANCELLED'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterIndicator(AdminOrderViewModel vm, String value, String label) {
    final bool isSelected = vm.statusFilter == value;
    return GestureDetector(
      onTap: () {
        vm.setStatusFilter(value);
        vm.loadOrders(status: value.isEmpty ? null : value, page: 1);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade500,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(AdminOrderViewModel vm, bool isWeb) {
    if (vm.isLoading && vm.orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
      );
    }

    if (vm.orders.isEmpty) {
      return Center(
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
                Icons.receipt_long_outlined,
                size: 40,
                color: Colors.black12,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'NO RECORDS FOUND',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 20, vertical: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: vm.orders.length,
      itemBuilder: (context, index) {
        final order = vm.orders[index];
        return _OrderCard(
          order: order,
          onView: () => Navigator.pushNamed(
            context,
            '/order-detail',
            arguments: order.id,
          ),
          onStatusChange: (status) => vm.updateStatus(order.id, status),
          onDelete: () => _showDeleteConfirmation(context, vm, order.id),
          isWeb: isWeb,
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AdminOrderViewModel vm,
    String orderId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text(
          'PURGE RECORD?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
        content: const Text(
          'This will permanently remove the order from the archive. Stock levels will be reconciled automatically.',
          style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              vm.deleteOrder(orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 0,
            ),
            child: const Text(
              'PURGE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final ApiOrderModel order;
  final VoidCallback onView;
  final Function(String) onStatusChange;
  final VoidCallback onDelete;
  final bool isWeb;

  const _OrderCard({
    required this.order,
    required this.onView,
    required this.onStatusChange,
    required this.onDelete,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFBFBFB),
              border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WG_BATCH#${order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy · HH:mm',
                        ).format(order.orderDate).toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusIndicator(order.status),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small Preview
                    if (order.items.isNotEmpty)
                      Container(
                        width: 50,
                        height: 65,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          border: Border.all(color: const Color(0xFFF5F5F5)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          order.items.first.image.startsWith('http')
                              ? order.items.first.image
                              : '${Constants.apiOrigin}${order.items.first.image}',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.broken_image_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.customerInfo != null)
                            Text(
                              order.customerInfo!.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.items.length} ARCHIVAL PIECES',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF5F5F5)),
                const SizedBox(height: 12),

                // Fine-tuned Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: onView,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Text(
                          'VIEW DETAILS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _statusDropdown(),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Colors.red,
                        ),
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

  Widget _statusIndicator(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: DropdownButton<String>(
        value: order.status,
        isDense: true,
        underline: const SizedBox.shrink(),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 16,
          color: Colors.black,
        ),
        items: ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled']
            .map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              );
            })
            .toList(),
        onChanged: (v) {
          if (v != null) onStatusChange(v);
        },
      ),
    );
  }
}
