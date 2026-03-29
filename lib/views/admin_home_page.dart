// Redesigned Admin Dashboard for WESTERN GRAM.
// Implements a high-end, directorial archival aesthetic.
// Structured around high-contrast typography and minimalist data visualization.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e/core/constants/app_roles.dart';
import '../features/admin/admin_module.dart';
import '../features/auth/viewmodels/auth_vm.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth >= 900;
    final padding = isWeb
        ? (screenWidth - 1200).clamp(24.0, double.infinity) / 2
        : 16.0;

    return Consumer2<AuthViewModel, AdminAnalyticsViewModel>(
      builder: (context, authVm, analyticsVm, _) {
        if (analyticsVm.dashboard == null && !analyticsVm.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => analyticsVm.loadDashboard(),
          );
        }

        if (authVm.user != null &&
            authVm.user?.role != AppRoles.businessAdmin) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (_) => false);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        if (authVm.user == null) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: isWeb ? null : _buildMobileDrawer(context, authVm),
          appBar: _buildArchivalTopBar(context, authVm, isWeb),
          body: Row(
            children: [
              if (isWeb) _buildSidebar(context, authVm),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: _buildDashboardContent(context, authVm, analyticsVm),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, AuthViewModel authVm) {
    return Container(
      width: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Minimal Logo
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Colors.black),
              child: const Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            _sideIcon(
              Icons.inventory_2_outlined,
              'COLLECTIONS',
              () => Navigator.pushNamed(context, '/product-management'),
            ),
            _sideIcon(
              Icons.insights_rounded,
              'INSIGHTS',
              () => Navigator.pushNamed(context, '/sales-dashboard'),
            ),
            _sideIcon(
              Icons.receipt_long_rounded,
              'ARCHIVE',
              () => Navigator.pushNamed(context, '/order-management'),
            ),

            const Spacer(),

            _sideIcon(
              Icons.person_outline_rounded,
              'IDENTITY',
              () => Navigator.pushNamed(context, '/profile'),
            ),
            _sideIcon(
              Icons.logout_rounded,
              'TERMINATE',
              () => authVm.logout(),
              isDestructive: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sideIcon(
    IconData icon,
    String tooltip,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            color: isDestructive ? Colors.red.shade900 : Colors.black,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context, AuthViewModel authVm) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WESTERN GRAM',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'EXECUTIVE PRIVILEGES',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              _drawerItem(Icons.inventory_2_outlined, 'COLLECTIONS', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/product-management');
              }),
              _drawerItem(Icons.insights_rounded, 'INSIGHTS', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sales-dashboard');
              }),
              _drawerItem(Icons.receipt_long_rounded, 'ARCHIVE', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/order-management');
              }),
              const Spacer(),
              _drawerItem(Icons.person_outline_rounded, 'IDENTITY', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              }),
              _drawerItem(
                Icons.logout_rounded,
                'TERMINATE',
                () => authVm.logout(),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? Colors.red.shade900 : Colors.black,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: isDestructive ? Colors.red.shade900 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildArchivalTopBar(
    BuildContext context,
    AuthViewModel authVm,
    bool isWeb,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: isWeb ? 80 : 70,
      leading: isWeb
          ? null
          : IconButton(
              icon: const Icon(Icons.sort_rounded, color: Colors.black),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
      shape: const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      title: Column(
        children: [
          const Text(
            'WESTERN GRAM',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.black,
            ),
          ),
          Text(
            isWeb ? 'EXECUTIVE DASHBOARD / SYSTEM v1.0' : 'MANAGEMENT PORTAL',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      actions: isWeb
          ? [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFF5F5F5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        authVm.userName?.toUpperCase() ?? 'ADMIN',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    AuthViewModel authVm,
    AdminAnalyticsViewModel analyticsVm,
  ) {
    if (analyticsVm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricGrid(analyticsVm),
          const SizedBox(height: 40),
          _buildSectionHeader('STRATEGIC ACTIONS'),
          _buildActionGrid(context),
          const SizedBox(height: 40),
          _buildSectionHeader('COLLECTION PERFORMANCE'),
          _buildTopSellingList(analyticsVm),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: const Color(0xFFF5F5F5))),
        ],
      ),
    );
  }

  Widget _buildMetricGrid(AdminAnalyticsViewModel analyticsVm) {
    final d = analyticsVm.dashboard;
    if (d == null) return const SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 900 ? 3 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: constraints.maxWidth > 600 ? 1.8 : 1.4,
          children: [
            _metricCard(
              'GROSS REVENUE',
              '₹${d.totalSales.toInt()}',
              Icons.account_balance_wallet_outlined,
            ),
            _metricCard(
              'WEBSITE PROFIT',
              '₹${d.totalWebsiteProfit.toInt()}',
              Icons.trending_up_rounded,
            ),
            _metricCard(
              'SHOP ALLOCATION',
              '₹${d.totalShopShare.toInt()}',
              Icons.storefront_outlined,
            ),
            _metricCard(
              'TOTAL CONSIGNMENTS',
              '${d.totalOrders}',
              Icons.inventory_2_outlined,
            ),
            _metricCard(
              'PENDING CLEARANCE',
              '${d.pendingOrders}',
              Icons.hourglass_empty_rounded,
              isAlert: d.pendingOrders > 0,
            ),
            _metricCard(
              'FULFILLED ORDERS',
              '${d.confirmedOrders}',
              Icons.verified_outlined,
            ),
          ],
        );
      },
    );
  }

  Widget _metricCard(
    String label,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isAlert ? Colors.red : Colors.grey.shade400,
                    letterSpacing: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 14, color: isAlert ? Colors.red : Colors.black),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              _actionButton(
                context,
                'PRODUCT MGMT',
                Icons.add_rounded,
                '/product-management',
                isFullWidth: true,
              ),
              const SizedBox(height: 8),
              _actionButton(
                context,
                'SALES ARCHIVE',
                Icons.bar_chart_rounded,
                '/sales-dashboard',
                isFullWidth: true,
              ),
              const SizedBox(height: 8),
              _actionButton(
                context,
                'ORDER LOGS',
                Icons.receipt_long_rounded,
                '/order-management',
                isFullWidth: true,
              ),
            ],
          );
        }
        return Row(
          children: [
            _actionButton(
              context,
              'PRODUCT MGMT',
              Icons.add_rounded,
              '/product-management',
            ),
            const SizedBox(width: 12),
            _actionButton(
              context,
              'SALES ARCHIVE',
              Icons.bar_chart_rounded,
              '/sales-dashboard',
            ),
            const SizedBox(width: 12),
            _actionButton(
              context,
              'ORDER LOGS',
              Icons.receipt_long_rounded,
              '/order-management',
            ),
          ],
        );
      },
    );
  }

  Widget _actionButton(
    BuildContext context,
    String label,
    IconData icon,
    String route, {
    bool isFullWidth = false,
  }) {
    final button = InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : Expanded(child: button);
  }

  Widget _buildTopSellingList(AdminAnalyticsViewModel analyticsVm) {
    final top = analyticsVm.dashboard?.topSellingProducts ?? [];
    if (top.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF5F5F5)),
        ),
        child: Center(
          child: Text(
            'NO DATA RECORDED',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.grey.shade300,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }

    return Column(
      children: top.take(5).map((p) => _topSellingItem(p)).toList(),
    );
  }

  Widget _topSellingItem(TopSellingProduct product) {
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
              product.productName.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            '${product.totalSold} UNITS SOLD',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 32),
          Text(
            '₹${product.revenue.toInt()}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
