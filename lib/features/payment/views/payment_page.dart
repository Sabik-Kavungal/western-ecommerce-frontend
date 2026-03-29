// Redesigned for WESTERN GRAM: high-end transaction archival aesthetic.
// Minimalist flat design with receipt-style payout credentials.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../viewmodels/payment_vm.dart';
import '../../orders/models/order_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final order = ModalRoute.of(context)?.settings.arguments as OrderModel?;
      context.read<PaymentViewModel>().setOrder(order);
      context.read<PaymentViewModel>().loadPaymentInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
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
                  'MAKE PAYMENT',
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
          body: vm.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : TweenAnimationBuilder<double>(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'PAYMENT OPTIONS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 16,
                                  height: 1.5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'CHOOSE YOUR PREFERRED PAYMENT METHOD',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 48),

                            if (vm.currentOrder != null) ...[
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'TOTAL PAYABLE',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ORDER #${vm.currentOrder!.id.toUpperCase().substring(vm.currentOrder!.id.length > 6 ? vm.currentOrder!.id.length - 6 : 0)}',
                                          style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade400,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '₹${vm.currentOrder!.totalAmount.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 48),
                            ],

                            _payoutTile(
                              label: 'PHONEPE UPI ID',
                              value: vm.phonepeNumber,
                              color: Colors.deepPurple,
                              context: context,
                            ),
                            const SizedBox(height: 24),
                            _payoutTile(
                              label: 'GOOGLE PAY UPI ID',
                              value: vm.gpayNumber,
                              color: Colors.blue.shade700,
                              context: context,
                            ),

                            const SizedBox(height: 48),

                            // Verification Guide
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                border: Border.all(
                                  color: const Color(0xFFF0F0F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'HOW TO PAY',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _instructionRow(
                                    '1',
                                    'COMPLETE THE TRANSFER TO EITHER UPI ID ABOVE',
                                  ),
                                  const SizedBox(height: 12),
                                  _instructionRow(
                                    '2',
                                    'TAKE A SCREENSHOT OF THE PAYMENT RECEIPT',
                                  ),
                                  const SizedBox(height: 12),
                                  _instructionRow(
                                    '3',
                                    'SEND THE SCREENSHOT VIA WHATSAPP FOR CONFIRMATION',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Finalize Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: vm.confirmPayment,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 22,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                ),
                                child: Text(
                                  vm.currentOrder != null
                                      ? 'FINALIZE ON WHATSAPP'
                                      : 'CONFIRM PAYMENT',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'SECURED BY WESTERN GRAM AUTHENTICATION',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
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

  Widget _payoutTile({
    required String label,
    required String value,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade400,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('UPI ID COPIED TO CLIPBOARD'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _instructionRow(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
