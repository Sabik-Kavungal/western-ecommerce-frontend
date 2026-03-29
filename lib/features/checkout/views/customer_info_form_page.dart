// Redesigned for the WESTERN GRAM archival checkout experience.
// Integrated with CheckoutViewModel for form state and validation.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/checkout_vm.dart';
import '../../cart/models/cart_item_model.dart';
import '../services/shipping_service.dart';

class CustomerInfoFormPage extends StatefulWidget {
  const CustomerInfoFormPage({
    super.key,
    this.items,
    this.isSingleProduct = false,
    this.productId,
    this.productName,
    this.productColor,
    this.size,
    this.price,
    this.quantity,
  });

  final List<CartItemModel>? items;
  final bool isSingleProduct;
  final String? productId;
  final String? productName;
  final String? productColor;
  final String? size;
  final double? price;
  final int? quantity;

  @override
  State<CustomerInfoFormPage> createState() => _CustomerInfoFormPageState();
}

class _CustomerInfoFormPageState extends State<CustomerInfoFormPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _contactNoController = TextEditingController();
  bool _isLoadingAddress = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  Future<void> _loadAddress() async {
    final vm = context.read<CheckoutViewModel>();
    await vm.loadSavedAddress();
    if (mounted) {
      _nameController.text = vm.name;
      _addressController.text = vm.address;
      _cityController.text = vm.city;
      _districtController.text = vm.district;
      _pincodeController.text = vm.pincode;
      _contactNoController.text = vm.contactNo;
      setState(() => _isLoadingAddress = false);
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
              'SHIPPING AUTHENTICATION',
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
        child: _isLoadingAddress
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Consumer<CheckoutViewModel>(
                  builder: (context, vm, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'ORDER DESTINATION',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(width: 16, height: 1.5, color: Colors.black),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PLEASE VERIFY YOUR SHIPPING CREDENTIALS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 48),

                        if (vm.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.05),
                                border: Border.all(color: Colors.red.withOpacity(0.1)),
                              ),
                              child: Text(
                                vm.error!.toUpperCase(),
                                style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),

                        _minimalField('FULL NAME *', _nameController, (v) => vm.updateName(v), hintText: 'Archival Name'),
                        _minimalField('STREET ADDRESS *', _addressController, (v) => vm.updateAddress(v), hintText: 'Studio/Home Location', maxLines: 2),

                        Row(
                          children: [
                            Expanded(child: _minimalField('CITY *', _cityController, (v) => vm.updateCity(v), hintText: 'Origin City')),
                            const SizedBox(width: 16),
                            Expanded(child: _minimalField('DISTRICT *', _districtController, (v) => vm.updateDistrict(v), hintText: 'Region')),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: _dropdownField('STATE *', vm.state, (v) => vm.updateState(v ?? ''))),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _minimalField(
                                'PINCODE *',
                                _pincodeController,
                                (v) => vm.updatePincode(v),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                              ),
                            ),
                          ],
                        ),

                        _minimalField(
                          'CONTACT NUMBER *',
                          _contactNoController,
                          (v) => vm.updateContactNo(v),
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          hintText: '10-Digit Secure ID',
                        ),

                        const SizedBox(height: 48),
                        Row(
                          children: [
                            const Text(
                              'LOGISTICS SELECTION',
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
                        _buildCourierOptions(vm),

                        const SizedBox(height: 64),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.isSubmitting
                                ? null
                                : () => vm.submitCheckout(
                                    cartItems: widget.items,
                                    isSingleProduct: widget.isSingleProduct,
                                    productId: widget.productId,
                                    productName: widget.productName,
                                    productColor: widget.productColor,
                                    size: widget.size,
                                    price: widget.price,
                                    quantity: widget.quantity,
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              elevation: 10,
                              shadowColor: Colors.black.withOpacity(0.4),
                            ),
                            child: vm.isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'FINALIZE ORDER ON WHATSAPP',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 2.5,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _minimalField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    String? hintText,
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
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          decoration: InputDecoration(
            counterText: "",
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13, fontWeight: FontWeight.w500),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade100)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _dropdownField(String label, String? value, Function(String?) onChanged) {
    final states = [
      "Andaman and Nicobar Islands", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli and Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Ladakh", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"
    ];
    // Avoid unmatched value error in dropdown
    final validValue = (value == null || value.isEmpty || !states.contains(value)) ? null : value;
    
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
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              builder: (ctx) {
                String query = '';
                return StatefulBuilder(
                  builder: (ctx, setModalState) {
                    final filtered = states.where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('SELECT STATE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2)),
                            const SizedBox(height: 24),
                            TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search State...',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                                prefixIcon: const Icon(Icons.search, color: Colors.black, size: 20),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade200)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                              ),
                              style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                              onChanged: (v) => setModalState(() => query = v),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                                itemBuilder: (ctx, i) {
                                  final s = filtered[i];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(s, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Inter')),
                                    onTap: () {
                                      onChanged(s);
                                      Navigator.pop(ctx);
                                    },
                                    trailing: s == validValue ? const Icon(Icons.check, color: Colors.black, size: 20) : null,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: validValue == null ? Colors.grey.shade100 : Colors.black, width: validValue == null ? 1.0 : 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  validValue ?? 'Select State',
                  style: TextStyle(
                    fontSize: 15,
                    color: validValue == null ? Colors.grey.shade300 : Colors.black,
                    fontWeight: validValue == null ? FontWeight.w500 : FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCourierOptions(CheckoutViewModel vm) {
    String city = vm.city.isNotEmpty ? vm.city : 'Bangalore';
    String state = vm.state.isNotEmpty ? vm.state : 'Karnataka';
    Map<String, double> rates = ShippingService.getShippingOptions(state, city);

    return Column(
      children: [
        _courierOption(vm, 'DTDC', Icons.local_shipping_outlined, rates['DTDC']!),
        const SizedBox(height: 12),
        _courierOption(vm, 'INDIA POST', Icons.mail_outlined, rates['INDIA POST']!),
      ],
    );
  }

  Widget _courierOption(CheckoutViewModel vm, String name, IconData icon, double cost) {
    final isSelected = vm.selectedCourier == name;
    return InkWell(
      onTap: () => vm.updateCourier(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade100, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : Colors.black,
                      letterSpacing: 2,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${cost.toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
