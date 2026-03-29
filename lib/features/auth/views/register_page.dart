// feature-first auth: Register UI. Redesigned to Seasons aesthetic.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVm, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
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
                  'COLLECTION \'24',
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'JOIN US',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(width: 25, height: 2, color: Colors.black),
                          const SizedBox(width: 8),
                          Text(
                            'START YOUR JOURNEY WITH THE BRAND',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _buildForm(context, authVm),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, AuthViewModel authVm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMinimalField(
          label: 'FULL NAME',
          hint: 'Enter your name',
          value: authVm.name,
          onChanged: authVm.updateName,
        ),
        const SizedBox(height: 24),
        _buildMinimalField(
          label: 'PHONE NUMBER',
          hint: 'Enter 10-digit phone',
          value: authVm.phone,
          onChanged: authVm.updatePhone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        _buildMinimalField(
          label: 'PASSWORD',
          hint: 'At least 6 characters',
          value: authVm.password,
          onChanged: authVm.updatePassword,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        _buildMinimalField(
          label: 'EMAIL (OPTIONAL)',
          hint: 'e.g. you@example.com',
          value: authVm.email,
          onChanged: authVm.updateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        if (authVm.errorMessage != null && authVm.errorMessage!.isNotEmpty) ...[
          Text(
            authVm.errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authVm.isLoading ? null : authVm.register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: authVm.isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'CREATE NEW ACCOUNT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: authVm.isLoading
                ? null
                : () {
                    authVm.clearRegisterFields();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
            child: Text(
              'ALREADY A MEMBER? SIGN IN',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalField({
    required String label,
    required String hint,
    required String value,
    required void Function(String) onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: ValueKey(label),
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
