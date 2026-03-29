// Redesigned for WESTERN GRAM: high-end identity management aesthetic.
// Minimalist archival design with systematic input layouts.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_vm.dart';
import '../services/customer_api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthViewModel>();
    _nameController = TextEditingController(text: auth.userName ?? '');
    _emailController = TextEditingController(text: auth.userEmail ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final n = _nameController.text.trim();
    final e = _emailController.text.trim();
    if (n.length < 2) {
      setState(() => _error = 'Name must be 2–100 characters');
      return;
    }
    final auth = context.read<AuthViewModel>();
    final api = context.read<CustomerApi>();
    final token = auth.token;
    if (token == null) {
      setState(() => _error = 'Please sign in');
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      final u = await api.updateProfile(
        token,
        name: n,
        email: e.isEmpty ? null : e,
      );
      auth.setUser(u);
      if (mounted) Navigator.pop(context);
    } catch (ex) {
      setState(() {
        _error = ex.toString();
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 24,
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
              'IDENTITY RECORDS',
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
        child: TweenAnimationBuilder<double>(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                _buildAvatarSection(context),
                const SizedBox(height: 56),

                if (_error != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Text(
                      _error!.toUpperCase(),
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                _buildArchivalField(
                  'FULL NAME',
                  _nameController,
                  hint: 'ENTER YOUR FULL NAME',
                ),
                const SizedBox(height: 32),
                _buildArchivalField(
                  'EMAIL ADDRESS',
                  _emailController,
                  hint: 'USER@EXAMPLE.COM',
                  keyboard: TextInputType.emailAddress,
                ),

                const SizedBox(height: 64),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 10,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'UPDATE MY PROFILE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  'ALL CHANGES ARE LOGGED PERMANENTLY',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    final auth = context.read<AuthViewModel>();
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1A1A1A),
              ),
              child: Center(
                child: Text(
                  (auth.userName ?? 'U').substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'PROFILE IDENTITY',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildArchivalField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(height: 0.5, color: const Color(0xFFF0F0F0)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
