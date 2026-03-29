// View and save address via GET/PUT /customers/me/address.
// Redesigned for WESTERN GRAM boutique aesthetic.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_vm.dart';
import '../services/customer_api.dart';
import '../../checkout/models/customer_info_model.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();
  final _contactNo = TextEditingController();
  String _courier = 'DTDC';
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _city.dispose();
    _district.dispose();
    _state.dispose();
    _pincode.dispose();
    _contactNo.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final token = context.read<AuthViewModel>().token;
    if (token == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final a = await context.read<CustomerApi>().getAddress(token);
      if (a != null && mounted) {
        _name.text = a.name;
        _address.text = a.address;
        _city.text = a.city;
        _district.text = a.district;
        _state.text = a.state;
        _pincode.text = a.pincode;
        _contactNo.text = a.contactNo;
        _courier = a.courierService;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final n = _name.text.trim(),
        a = _address.text.trim(),
        c = _city.text.trim();
    final d = _district.text.trim(),
        s = _state.text.trim(),
        p = _pincode.text.trim(),
        ph = _contactNo.text.trim();

    if (n.length < 2) {
      setState(() => _error = 'Name must be 2–100 characters');
      return;
    }
    if (a.isEmpty) {
      setState(() => _error = 'Address is required');
      return;
    }
    if (c.length < 2) {
      setState(() => _error = 'City required');
      return;
    }
    if (d.length < 2) {
      setState(() => _error = 'District required');
      return;
    }
    if (s.length < 2) {
      setState(() => _error = 'State required');
      return;
    }
    if (p.length != 6 || !RegExp(r'^\d+$').hasMatch(p)) {
      setState(() => _error = 'Pincode must be 6 digits');
      return;
    }
    if (ph.length != 10 || !RegExp(r'^\d+$').hasMatch(ph)) {
      setState(() => _error = 'Contact must be 10 digits');
      return;
    }

    final token = context.read<AuthViewModel>().token;
    if (token == null) {
      setState(() => _error = 'Please sign in');
      return;
    }

    setState(() {
      _error = null;
      _saving = true;
    });

    try {
      await context.read<CustomerApi>().saveAddress(
        token,
        CustomerInfoModel(
          name: n,
          address: a,
          city: c,
          district: d,
          state: s,
          pincode: p,
          contactNo: ph,
          courierService: _courier,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address saved successfully'),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'SHIPPING DESTINATION',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 24, height: 1.5, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'UPDATE YOUR PERMANENT DELIVERY LOCATION',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.05),
                          border: Border.all(color: Colors.red.withOpacity(0.1)),
                        ),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ),

                  _buildMinimalField('FULL NAME *', _name, hint: 'e.g. John Doe'),
                  _buildMinimalField('COMPLETE ADDRESS *', _address,
                      hint: 'Street, House No, Landmark', maxLines: 2),

                  Row(
                    children: [
                      Expanded(child: _buildMinimalField('CITY *', _city, hint: 'e.g. Kochi')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMinimalField('DISTRICT *', _district, hint: 'e.g. Ernakulam')),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(child: _buildMinimalField('STATE *', _state, hint: 'e.g. Kerala')),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMinimalField(
                          'PINCODE *',
                          _pincode,
                          keyboard: TextInputType.number,
                          maxLength: 6,
                          hint: '6-digit code',
                        ),
                      ),
                    ],
                  ),

                  _buildMinimalField(
                    'REACHABLE CONTACT *',
                    _contactNo,
                    keyboard: TextInputType.phone,
                    maxLength: 10,
                    hint: '10-digit mobile number',
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Text(
                        'COURIER PREFERENCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(width: 16, height: 1.5, color: Colors.grey.shade200),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCourierSelection(),

                  const SizedBox(height: 56),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'UPDATE ADDRESS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourierSelection() {
    return Row(
      children: [
        Expanded(child: _courierOption('DTDC')),
        const SizedBox(width: 12),
        Expanded(child: _courierOption('INDIA POST')),
      ],
    );
  }

  Widget _courierOption(String value) {
    final bool isSelected = _courier == value;
    return InkWell(
      onTap: () => setState(() => _courier = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              value == 'DTDC' ? Icons.local_shipping_outlined : Icons.mail_outline,
              color: isSelected ? Colors.white : Colors.black,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboard,
    int? maxLength,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
            counterText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
