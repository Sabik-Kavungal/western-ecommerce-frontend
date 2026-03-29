// Customer: list own orders from GET /orders. Loads on init.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e/core/constants/app_color.dart';
import '../viewmodels/order_vm.dart';
import '../models/order_model.dart';
import '../../../utils/constants.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().loadOrders();
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
              'ORDER ARCHIVE',
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
      body: Consumer<OrderViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null && vm.orders.isEmpty) {
            return Center(
              child: Text(
                vm.error!,
                style: const TextStyle(color: AppColors.redAccent),
              ),
            );
          }

          if (vm.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 48,
                      color: Colors.black12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ARCHIVE IS EMPTY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'YOU HAVEN\'T PLACED ANY ORDERS YET',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => vm.loadOrders(),
            color: Colors.black,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: vm.filteredOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final order = vm.filteredOrders[i];
                return _OrderCard(
                  order: order,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/my-order-detail',
                    arguments: order.id,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final d = order.orderDate;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Container(
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT THUMBNAIL
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (order.items.isNotEmpty &&
                      (order.items.first.product.image?.isNotEmpty ?? false))
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network(
                        order.items.first.product.image!.startsWith('http')
                            ? order.items.first.product.image!
                            : '${Constants.apiOrigin}${order.items.first.product.image}',
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _OrderPlaceholder(),
                      ),
                    )
                  else
                    const _OrderPlaceholder(),

                  if (order.items.length > 1)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '+${order.items.length - 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),

              // MAIN CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${order.id.toUpperCase().substring(order.id.length > 6 ? order.id.length - 6 : 0)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        _StatusChip(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      (order.items.isNotEmpty
                              ? order.items.first.product.name
                              : 'ORDER UNIT')
                          .toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      'WESTERN GRAM COLLECTION',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade400,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${order.items.length} ${order.items.length == 1 ? 'PIECE' : 'PIECES'}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${order.totalAmount.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              'VIEW ARCHIVE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderPlaceholder extends StatelessWidget {
  const _OrderPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(2),
      ),
      child: const Center(
        child: Icon(
          Icons.local_shipping_outlined,
          color: Colors.black12,
          size: 32,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final isSpecial =
        status.toLowerCase() == 'pending' ||
        status.toLowerCase() == 'processing';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSpecial ? Colors.black : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: isSpecial ? Colors.white : color,
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return const Color(0xFF4CAF50);
    case 'cancelled':
      return const Color(0xFFE57373);
    case 'pending':
    case 'processing':
      return Colors.black;
    default:
      return Colors.grey;
  }
}
