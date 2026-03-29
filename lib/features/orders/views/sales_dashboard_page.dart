// Admin: sales dashboard from GET /analytics/dashboard.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../admin/admin_module.dart';

class SalesDashboardPage extends StatefulWidget {
  const SalesDashboardPage({super.key});

  @override
  State<SalesDashboardPage> createState() => _SalesDashboardPageState();
}

class _SalesDashboardPageState extends State<SalesDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminAnalyticsViewModel>().loadDashboard();
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
              'SALES ARCHIVE / ANALYTICS',
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
      body: SafeArea(
        child: Consumer<AdminAnalyticsViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading && vm.dashboard == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              );
            }
            if (vm.error != null && vm.dashboard == null) {
              return Center(
                child: Text(
                  vm.error!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              );
            }
            final d = vm.dashboard;
            if (d == null)
              return const Center(
                child: Text(
                  'NO DATA RECORDED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('FINANCIAL OVERVIEW'),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'TOTAL REVENUE',
                          '₹${d.totalRevenue.toInt()}',
                          Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'NET PROFIT',
                          '₹${d.netProfit.toInt()}',
                          Icons.trending_up_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'DAILY YIELD',
                          '₹${d.todayRevenue.toInt()}',
                          Icons.today_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'MONTHLY REVENUE',
                          '₹${d.thisMonthRevenue.toInt()}',
                          Icons.calendar_month_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('LOGISTICS FOOTPRINT'),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'TOTAL ORDERS',
                          '${d.totalOrders}',
                          Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'PENDING CLEARANCE',
                          '${d.pendingOrders}',
                          Icons.hourglass_empty_rounded,
                          isAlert: d.pendingOrders > 0,
                        ),
                      ),
                    ],
                  ),
                  if (d.topSellingProducts.isNotEmpty) ...[
                    const SizedBox(height: 48),
                    _buildSectionHeader('PERFORMANCE LEADERS'),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: d.topSellingProducts.length,
                      itemBuilder: (_, i) {
                        final t = d.topSellingProducts[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFF5F5F5)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  t.productName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Text(
                                '${t.totalSold} UNITS',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 32),
                              Text(
                                '₹${t.revenue.toInt()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: const Color(0xFFF5F5F5))),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon, {
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAlert ? const Color(0xFFFFF8F8) : Colors.white,
        border: Border.all(
          color: isAlert
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFFF5F5F5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: isAlert ? Colors.red : Colors.grey.shade400,
                    letterSpacing: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 14, color: isAlert ? Colors.red : Colors.black),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
