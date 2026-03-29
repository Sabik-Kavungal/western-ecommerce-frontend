import 'package:e/features/auth/viewmodels/auth_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleGuard extends StatelessWidget {
  final Widget child;
  final String allowedRole;

  const RoleGuard({super.key, required this.child, required this.allowedRole});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      });
      return const SizedBox();
    }

    if (auth.user?.role != allowedRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      });
      return const SizedBox();
    }

    return child;
  }
}
