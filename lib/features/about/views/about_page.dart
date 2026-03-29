// Redesigned for WESTERN GRAM: high-end house history aesthetic.
// Minimalist archival design with systematic layouts.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/about_vm.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AboutViewModel>(
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
                'ABOUT US',
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
                _buildSectionHeader('WHO WE ARE'),
                const SizedBox(height: 16),
                const Text(
                  'WESTERN GRAM IS A PREMIUM WESTERN WEAR BRAND DEDICATED TO CURATING HIGH-QUALITY FASHION AT ACCESSIBLE PRICE POINTS. WE BELIEVE IN STYLE THAT CARRIES WORTH.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 48),

                _buildSectionHeader('WHY CHOOSE US'),
                const SizedBox(height: 16),
                _buildFeatureGrid(),
                const SizedBox(height: 48),

                _buildSectionHeader('HOW TO ORDER'),
                const SizedBox(height: 8),
                Text(
                  'A STEP-BY-STEP GUIDE TO PLACING YOUR ORDER',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                _buildOrderFlow(),
                const SizedBox(height: 48),

                _buildSectionHeader('DELIVERY INFORMATION'),
                const SizedBox(height: 16),
                _buildDeliveryInfo(),

                const SizedBox(height: 64),
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'WESTERN GRAM',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ESTABLISHED FOR THE PATRON',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBDBDBD),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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

  Widget _buildFeatureGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureTile(
                Icons.verified_outlined,
                'PREMIUM QUALITY',
                'ONLY THE BEST TEXTILES',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureTile(
                Icons.local_shipping_outlined,
                'FAST LOGISTICS',
                '3-4 DAY DELIVERY',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFeatureTile(
                Icons.payments_outlined,
                'SECURE PAY',
                'GPAY & PHONEPE READY',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeatureTile(
                Icons.support_agent_outlined,
                'DIRECT SUPPORT',
                'WHATSAPP HELP',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderFlow() {
    final steps = [
      'SELECT PRODUCT VARIANT AND SIZE',
      'COMPLETE THE SECURE ORDER FORM',
      'AUTOMATIC REDIRECT TO WHATSAPP',
      'EXECUTE PAYMENT VIA UPI CHANNEL',
      'MANUAL VERIFICATION OF RECEIPT',
      'ORDER LOGGED AND PREPARED',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(left: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: entry.key == steps.length - 1 ? 0 : 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '0${entry.key + 1}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          _infoRow(
            Icons.local_shipping_outlined,
            'TIMELINE',
            '3-4 WORKING DAYS NATIONWIDE',
          ),
          const Divider(height: 32, color: Color(0xFFF5F5F5)),
          _infoRow(
            Icons.inventory_2_outlined,
            'CARRIERS',
            'DTDC / INDIA POST SERVICE',
          ),
          const Divider(height: 32, color: Color(0xFFF5F5F5)),
          _infoRow(Icons.policy_outlined, 'POLICY', 'FIXED SALES - NO RETURNS'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
