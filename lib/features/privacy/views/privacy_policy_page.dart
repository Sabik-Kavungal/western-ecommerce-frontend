// Redesigned for WESTERN GRAM: high-end privacy protocol aesthetic.
// Minimalist archival design with systematic legal sections.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/privacy_vm.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivacyViewModel>(
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
                'PRIVACY POLICY',
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
                _buildSectionHeader('LAST UPDATED'),
                const SizedBox(height: 8),
                Text(
                  vm.lastUpdated.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                _buildSection('PRIVACY POLICY', [
                  'At Westerngram, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information when you use our app.',
                  'We collect information that you provide directly to us, such as when you place an order, contact us via WhatsApp, or interact with our services.',
                  'Your payment information is processed securely through GPay and PhonePe. We do not store your payment card details on our servers.',
                ]),
                const SizedBox(height: 40),

                _buildSection('DATA COLLECTION', [
                  '• Name and contact information for order processing',
                  '• Delivery address for shipping purposes',
                  '• Order history and preferences',
                  '• Communication records via WhatsApp',
                ]),
                const SizedBox(height: 40),

                _buildSection('TERMS OF SERVICE', [
                  'By using Westerngram, you agree to these terms and conditions. All products are sold "as is" and we do not accept returns or exchanges.',
                  'Orders are processed within 3-4 working days. Delivery is handled by DTDC or India Post courier services.',
                  'We reserve the right to cancel orders in case of payment issues or stock unavailability.',
                ]),
                const SizedBox(height: 40),

                _buildSection('WHATSAPP PAYMENT', [
                  'Orders and payments are handled via WhatsApp for maximum direct control and support.',
                  'Manual verification is required for all receipt transmissions before order finalization.',
                ]),

                const SizedBox(height: 80),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: const Column(
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
                          'LEGAL & COMPLIANCE',
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

  Widget _buildSection(String title, List<String> paragraphs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 16),
        ...paragraphs
            .map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  p,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.6,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
