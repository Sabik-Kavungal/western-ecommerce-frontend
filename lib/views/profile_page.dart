// Redesigned for WESTERN GRAM: high-end account archival aesthetic.
// Minimalist flat design with premium typography and directed layout.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e/core/constants/app_roles.dart';
import '../features/auth/auth_module.dart';
import '../widgets/login_dialog.dart';
import '../widgets/app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(currentRoute: '/profile'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.sort_rounded, color: Colors.black, size: 24),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
              'YOUR ACCOUNT DETAILS',
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
      body: Consumer<AuthViewModel>(
        builder: (context, authVm, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: !authVm.isLoggedIn
                  ? _buildNotLoggedIn(context)
                  : _buildLoggedIn(context, authVm),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'WELCOME',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SIGN IN TO ACCESS YOUR ACCOUNT',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 64),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildLoggedIn(BuildContext context, AuthViewModel authVm) {
    return TweenAnimationBuilder<double>(
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            _buildProfileHeader(authVm),
            const SizedBox(height: 48),

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    Icons.shopping_bag_outlined,
                    'MY ORDERS',
                    () => Navigator.pushNamed(context, '/my-orders'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    Icons.location_on_outlined,
                    'ADDRESSES',
                    () => Navigator.pushNamed(context, '/address'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            _buildMenuSection(
              context,
              'ACCOUNT SETTINGS',
              _getAccountItems(context, authVm),
            ),

            if (authVm.user?.role == AppRoles.businessAdmin) ...[
              const SizedBox(height: 40),
              _buildMenuSection(
                context,
                'BUSINESS TOOLS',
                _getBusinessItems(context),
              ),
            ],

            const SizedBox(height: 40),
            _buildMenuSection(
              context,
              'HELP & SUPPORT',
              _getSupportItems(context),
            ),

            const SizedBox(height: 40),
            _buildMenuSection(
              context,
              'LEGAL & POLICIES',
              _getSettingsItems(context, authVm),
            ),

            const SizedBox(height: 64),
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
              'VERSION 1.0.4 - STABLE',
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
    );
  }

  Widget _buildProfileHeader(AuthViewModel authVm) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              (authVm.userName ?? 'U').substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          (authVm.userName ?? 'PATRON').toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          authVm.userEmail?.toUpperCase() ?? 'IDENTIFIED BY WESTERN GRAM',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showDialog(context: context, builder: (_) => const LoginDialog());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: const Text(
              'LOG IN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              showDialog(context: context, builder: (_) => const LoginDialog());
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: const BorderSide(color: Color(0xFFF0F0F0)),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'SIGN UP / REGISTER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<_MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 16, height: 1.5, color: Colors.black),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: items.map((item) {
            return _buildMenuItem(context, item);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: item.isDestructive ? Colors.red : Colors.grey.shade400,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: item.isDestructive
                      ? Colors.red.shade900
                      : Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  List<_MenuItem> _getAccountItems(
    BuildContext context,
    AuthViewModel authVm,
  ) => [
    _MenuItem(
      icon: Icons.person_outline_rounded,
      title: 'Edit Profile',
      onTap: () => Navigator.pushNamed(context, '/edit-profile'),
    ),
    if (authVm.user?.role == AppRoles.businessAdmin)
      _MenuItem(
        icon: Icons.inventory_2_outlined,
        title: 'Manage Products',
        onTap: () => Navigator.pushNamed(context, '/product-management'),
      ),
    if (authVm.user?.role != AppRoles.businessAdmin)
      _MenuItem(
        icon: Icons.receipt_long_outlined,
        title: 'My Orders',
        onTap: () => Navigator.pushNamed(context, '/my-orders'),
      ),
    _MenuItem(
      icon: Icons.location_on_outlined,
      title: 'My Addresses',
      onTap: () => Navigator.pushNamed(context, '/address'),
    ),
  ];

  List<_MenuItem> _getBusinessItems(BuildContext context) => [
    _MenuItem(
      icon: Icons.admin_panel_settings_outlined,
      title: 'Admin Dashboard',
      onTap: () => Navigator.pushNamed(context, '/admin'),
    ),
    _MenuItem(
      icon: Icons.dashboard_outlined,
      title: 'Sales Dashboard',
      onTap: () => Navigator.pushNamed(context, '/sales-dashboard'),
    ),
    _MenuItem(
      icon: Icons.list_alt_rounded,
      title: 'Order Management',
      onTap: () => Navigator.pushNamed(context, '/order-management'),
    ),
  ];

  List<_MenuItem> _getSupportItems(BuildContext context) => [
    _MenuItem(
      icon: Icons.help_outline_rounded,
      title: 'Help Center',
      onTap: () {},
    ),
    _MenuItem(
      icon: Icons.info_outline_rounded,
      title: 'About Us',
      onTap: () => Navigator.pushNamed(context, '/about'),
    ),
    _MenuItem(
      icon: Icons.phone_outlined,
      title: 'Contact Us',
      onTap: () => Navigator.pushNamed(context, '/contact'),
    ),
  ];

  List<_MenuItem> _getSettingsItems(
    BuildContext context,
    AuthViewModel authVm,
  ) => [
    _MenuItem(
      icon: Icons.lock_outline_rounded,
      title: 'Privacy Policy',
      onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
    ),
    _MenuItem(
      icon: Icons.logout_rounded,
      title: 'Logout',
      onTap: () => authVm.logout(),
      isDestructive: true,
    ),
  ];
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}
