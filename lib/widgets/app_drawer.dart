import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/auth_module.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Consumer<AuthViewModel>(
        builder: (context, authVm, _) {
          return Column(
            children: [
              // 1. Drawer Header (WesternGram Branding + User Profile)
              _buildDrawerHeader(context, authVm),

              // 2. Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  children: [
                    _drawerSectionTitle('SHOP'),
                    _drawerItem(
                      icon: Icons.home_outlined,
                      label: 'HOME',
                      onTap: () => _safeNavigate(context, '/home'),
                      isSelected:
                          currentRoute == '/' || currentRoute == '/home',
                    ),
                    _drawerItem(
                      icon: Icons.shopping_bag_outlined,
                      label: 'MY BAG',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    const SizedBox(height: 20),
                    _drawerSectionTitle('ACCOUNT'),
                    _drawerItem(
                      icon: Icons.person_outline,
                      label: 'MY PROFILE',
                      onTap: () => _safeNavigate(context, '/profile'),
                      isSelected: currentRoute == '/profile',
                    ),
                    _drawerItem(
                      icon: Icons.edit_outlined,
                      label: 'EDIT PROFILE',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                    ),
                    _drawerItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'MY ORDERS',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/my-orders');
                      },
                    ),
                    _drawerItem(
                      icon: Icons.location_on_outlined,
                      label: 'MY ADDRESSES',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/address');
                      },
                    ),
                  ],
                ),
              ),

              // 3. Bottom Actions (Pinned)
              _buildDrawerFooter(context, authVm),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context, AuthViewModel authVm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        children: [
          if (authVm.isLoggedIn)
            _drawerItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              onTap: () => _showLogoutDialog(context, authVm),
              color: Colors.red.shade800,
            ),
          const SizedBox(height: 12),
          Text(
            'WESTERN GRAM'.toUpperCase(),
            style: const TextStyle(
              fontSize: 8,
              letterSpacing: 3,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'ESTABLISHED 2024',
            style: TextStyle(
              fontSize: 6,
              letterSpacing: 2,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel authVm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'LOGOUT'.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Are you sure you want to sign out of your account?'.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            letterSpacing: 1,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Text(
                    'CANCEL'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Close dialog and drawer
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close drawer

                    // Delay logout slightly to allow animations to finish
                    // This prevents "!isDisposed" errors on Flutter Web
                    Future.delayed(const Duration(milliseconds: 300), () {
                      authVm.logout();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'LOGOUT'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, AuthViewModel authVm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WESTERN GRAM',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'COLLECTION \'24',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (authVm.isLoggedIn) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.black,
                  child: Text(
                    (authVm.userName ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (authVm.userName ?? 'GUEST').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authVm.userEmail?.toLowerCase() ?? 'Verified Member',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DISCOVER THE TRENDS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SIGN IN / REGISTER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _drawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 15, height: 2, color: Colors.black),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9F9F9) : Colors.transparent,
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  color ?? (isSelected ? Colors.black : Colors.grey.shade400),
            ),
            const SizedBox(width: 16),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color:
                    color ?? (isSelected ? Colors.black : Colors.grey.shade600),
                letterSpacing: 2.0,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _safeNavigate(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    if (currentRoute == route) return;

    // Small delay to allow drawer animation to complete, prevents layout jank on Web
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      if (route == '/home') {
        Navigator.pushReplacementNamed(context, route);
      } else {
        Navigator.pushNamed(context, route);
      }
    });
  }
}
