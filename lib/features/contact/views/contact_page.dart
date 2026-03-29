// Redesigned for WESTERN GRAM: high-end direct communication aesthetic.
// Minimalist archival design with systematic channel layout.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/contact_vm.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactViewModel>(
      builder: (_, vm, __) => Scaffold(
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
            onPressed: vm.goBack,
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
                'CONTACT US',
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
        body: TweenAnimationBuilder<double>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('GET IN TOUCH'),
                const SizedBox(height: 24),
                _buildContactTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'WHATSAPP SUPPORT',
                  sub: 'ORDER ASSISTANCE & CUSTOMER CARE',
                  onTap: () => vm.launchWhatsApp(),
                ),
                const SizedBox(height: 16),
                _buildContactTile(
                  icon: Icons.camera_alt_outlined,
                  title: 'INSTAGRAM',
                  sub: 'FOLLOW US FOR UPDATES',
                  onTap: () => vm.launchInstagram(),
                ),
                const SizedBox(height: 48),

                _buildSectionHeader('PAYMENT INFO'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF0F0F0)),
                  ),
                  child: Column(
                    children: [
                      _paymentRow('GOOGLE PAY', 'GPay Number: +91 88493 25211'),
                      const Divider(height: 32, color: Color(0xFFF5F5F5)),
                      _paymentRow('PHONEPE', 'PhonePe Number: +91 88493 25211'),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                _buildSectionHeader('CONTACT DETAILS'),
                const SizedBox(height: 16),
                _directoryItem('WHATSAPP PRIMARY', '+91 88493 25211'),
                const SizedBox(height: 12),
                _directoryItem('ORDER DESK', '+91 88493 25211'),
                const SizedBox(height: 12),
                _directoryItem('SECONDARY LOGISTICS', '+91 88493 25211'),

                const SizedBox(height: 80),
                const Center(
                  child: Text(
                    'RESPONSE TIME: < 12 HOURS',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFBDBDBD),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
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
        Container(width: 24, height: 1.5, color: Colors.black),
      ],
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String sub,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentRow(String title, String sub) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.black,
          size: 18,
        ),
      ],
    );
  }

  Widget _directoryItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9E9E9E),
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
