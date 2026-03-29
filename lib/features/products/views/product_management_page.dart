// Admin: product list from API, create (with image upload), update, delete.

import 'dart:typed_data';

import 'package:e/features/products/models/product_model.dart';
import 'package:e/features/admin/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:e/core/constants/app_color.dart';
import '../../admin/admin_module.dart';
import '../../admin/viewmodels/category_vm.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductViewModel>().loadProducts();
      context.read<CategoryViewModel>().loadCategories();
    });
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
              'PRODUCT COLLECTIONS',
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
      body: Consumer<AdminProductViewModel>(
        builder: (context, vm, _) {
          if (vm.successMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(vm.successMessage!),
                  backgroundColor: Colors.black,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              vm.clearSuccessMessage();
            });
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWeb = constraints.maxWidth >= 900;
              final padding = isWeb
                  ? (constraints.maxWidth - 1200).clamp(0.0, double.infinity) /
                        2
                  : 0.0;

              return Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: isWeb
                      ? _buildWebLayout(context, vm)
                      : _buildMobileLayout(context, vm),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context, AdminProductViewModel vm) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFFF5F5F5)),
                    right: BorderSide(color: Color(0xFFF5F5F5)),
                  ),
                ),
                child: Column(
                  children: [
                    _buildNewProductHeader(vm),
                    RepaintBoundary(child: _buildCategoryFilterSection(vm)),
                    const Divider(height: 1),
                    Expanded(
                      child: RepaintBoundary(
                        child: _buildProductListSection(vm),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Color(0xFFF5F5F5))),
                ),
                child: RepaintBoundary(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 32,
                    ),
                    child: _buildProductForm(context, vm),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (vm.pendingDelete != null) _buildDeleteOverlay(vm),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AdminProductViewModel vm) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorWeight: 1,
                dividerColor: Color(0xFFF5F5F5),
                labelStyle: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
                tabs: [
                  Tab(text: 'ARCHIVE'),
                  Tab(text: 'COLLECTION EDITOR'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        _buildNewProductHeader(vm),
                        _buildCategoryFilterSection(vm),
                        Expanded(child: _buildProductListSection(vm)),
                      ],
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildProductForm(context, vm),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (vm.pendingDelete != null) _buildDeleteOverlay(vm),
      ],
    );
  }

  Widget _buildNewProductHeader(AdminProductViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: vm.clearProductForm,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text(
            'NEW COLLECTION ENTRY',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterSection(AdminProductViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Consumer<CategoryViewModel>(
        builder: (context, categoryVm, _) {
          final uniqueCategories = <String, String>{};
          for (final category in categoryVm.categories) {
            if (!uniqueCategories.containsKey(category.id)) {
              uniqueCategories[category.id] = category.name;
            }
          }

          final selectedValue =
              vm.filterCategoryId != null &&
                  uniqueCategories.containsKey(vm.filterCategoryId)
              ? vm.filterCategoryId
              : null;

          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              border: Border.all(color: const Color(0xFFF5F5F5)),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: const InputDecoration(
                labelText: 'FILTER COLLECTION',
                labelStyle: TextStyle(
                  color: Colors.black26,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.filter_list_rounded,
                  size: 14,
                  color: Colors.black,
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'ALL CATEGORIES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ...uniqueCategories.entries.map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(
                      entry.value.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: vm.setFilterCategoryId,
              isExpanded: true,
              style: const TextStyle(color: Colors.black, fontSize: 11),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductListSection(AdminProductViewModel vm) {
    if (vm.isLoading && vm.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
      );
    }
    if (vm.products.isEmpty) {
      return Center(
        child: Text(
          'ARCHIVE EMPTY',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: vm.products.length,
      itemBuilder: (_, i) {
        final p = vm.products[i];
        return _ProductListItem(
          product: p,
          onTap: () => vm.loadProductForEdit(p.id),
          onEdit: () => vm.loadProductForEdit(p.id),
          onDelete: () => vm.requestDelete(p),
        );
      },
    );
  }

  Widget _buildProductForm(BuildContext context, AdminProductViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vm.error != null && vm.error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              vm.error!.toUpperCase(),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        _buildSectionTitle('COLLECTION METADATA'),
        _minimalFormField(
          'PRODUCT NAME *',
          vm.formName,
          vm.updateFormName,
          vm.editingId,
        ),
        const SizedBox(height: 16),
        _minimalFormField(
          'DESCRIPTION / ARCHIVE NOTES',
          vm.formDescription,
          vm.updateFormDescription,
          vm.editingId,
          maxLines: 3,
        ),
        const SizedBox(height: 24),

        _buildCategoryDropdown(context, vm),
        const SizedBox(height: 24),

        _buildSectionTitle('STRATEGIC STATUS'),
        _buildSwitchRow(
          'FEATURED IN SHOWCASE',
          'Highlight in premium collections',
          vm.formIsFeatured,
          (v) => vm.updateFormIsFeatured(v),
        ),
        const SizedBox(height: 12),
        _buildSwitchRow(
          'MANUAL VISIBILITY',
          'Override system availability',
          vm.formIsAvailable,
          (v) => vm.updateFormIsAvailable(v),
        ),
        const SizedBox(height: 12),
        _buildSwitchRow(
          'LIVE ARCHIVE STATUS',
          'Toggle general database state',
          vm.formIsActive,
          (v) => vm.updateFormIsActive(v),
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('PRICING ARCHIVE'),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _pricingField(
                'RETAIL (₹)',
                vm.formPrice.toString(),
                (v) {
                  final p = double.tryParse(v);
                  if (p != null) vm.updateFormPrice(p);
                },
                ValueKey('price_${vm.editingId}'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _pricingField(
                'SHOP RATE (₹)',
                vm.formShopPrice.toString(),
                (v) {
                  final p = double.tryParse(v);
                  if (p != null) vm.updateFormShopPrice(p);
                },
                ValueKey('shop_price_${vm.editingId}'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: _pricingField(
                'COMM (%)',
                vm.formWebsiteCommission.toStringAsFixed(0),
                null,
                ValueKey('comm_${vm.editingId}'),
                enabled: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildVariantsSection(vm),

        const SizedBox(height: 48),

        const SizedBox(height: 48),

        RepaintBoundary(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: vm.isSaving ? null : vm.saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: vm.isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'SUBMIT TO COLLECTIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(
          height: 48,
        ), // Added bottom padding to ensure button isn't flushed to edge
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.5,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDeleteOverlay(AdminProductViewModel vm) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Colors.black,
              ),
              const SizedBox(height: 16),
              const Text(
                'DELETE PRODUCT?',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              const SizedBox(height: 12),
              Text(
                'Delete "${vm.pendingDelete!.name}" permanently?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: vm.clearPendingDelete,
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: vm.confirmDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _minimalFormField(
    String label,
    String value,
    void Function(String) onChanged,
    String? editingId, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
          ),
          child: TextFormField(
            key: ValueKey('$label-$editingId'),
            initialValue: value,
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _pricingField(
    String label,
    String value,
    Function(String)? onChanged,
    Key fieldKey, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFF9F9F9) : const Color(0xFFEEEEEE),
            border: const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
          ),
          child: TextFormField(
            key: fieldKey,
            initialValue: value,
            enabled: enabled,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: enabled ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    String title,
    String subtitle,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }

  void _showCategoryManagement(
    BuildContext context,
    CategoryViewModel categoryVm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryManagementSheet(categoryVm: categoryVm),
    );
  }

  Widget _buildVariantsSection(AdminProductViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Text(
          vm.editingId != null
              ? 'SYNC MODE: Provide an ID to update, omit to delete, or add new colors without IDs.'
              : 'BATCH MODE: Creating multiple products with different colors. Base fields (Name, Category, Price) apply to all.',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black26,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.formVariants.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _buildVariantRow(vm, index),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: vm.addFormVariant,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('ADD ANOTHER COLOR'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Color(0xFFF0F0F0)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVariantRow(AdminProductViewModel vm, int index) {
    final variant = vm.formVariants[index];
    final color = variant['color'] as String;
    final sizes = List<Map<String, dynamic>>.from(variant['sizes'] ?? []);
    final id = variant['id'] as String?;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: id != null ? Colors.black12 : const Color(0xFFF0F0F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: id != null ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                id != null
                    ? 'SYNCING (ID: ...${id.substring(id.length > 4 ? id.length - 4 : 0)})'
                    : 'NEW VARIANT',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: id != null ? Colors.green : Colors.blue,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => vm.removeFormVariantAt(index),
                child: const Icon(Icons.close, size: 16, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildVariantColorInput(vm, index, color),
          const SizedBox(height: 20),
          _buildVariantImageSection(vm, index),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const Text(
            'SIZES & INVENTORY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          ...sizes.asMap().entries.map((e) {
            final sIdx = e.key;
            final s = e.value;
            return _buildSizeRow(vm, index, sIdx, s);
          }),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => vm.addSizeToVariant(index),
            icon: const Icon(Icons.add, size: 14),
            label: const Text(
              'ADD SIZE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantColorInput(
    AdminProductViewModel vm,
    int index,
    String color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COLOR NAME',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
          ),
          child: TextFormField(
            key: ValueKey('variant-color-$index-${vm.editingId}'),
            initialValue: color,
            onChanged: (v) => vm.updateVariantColor(index, v),
            decoration: const InputDecoration(
              hintText: 'ENTER COLOR (e.g. Navy Blue)',
              hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeRow(
    AdminProductViewModel vm,
    int vIdx,
    int sIdx,
    Map<String, dynamic> size,
  ) {
    final sName = size['name'] as String? ?? '';
    final sSize = size['size'] as String;
    final stock = size['stock'] as int;
    final price = (size['price'] as num?)?.toDouble() ?? vm.formPrice;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: _minimalSizeField(
              'NAME / SKU',
              sName,
              (v) => vm.updateSizeField(vIdx, sIdx, 'name', v),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _minimalSizeField(
              'SIZE',
              sSize,
              (v) => vm.updateSizeField(vIdx, sIdx, 'size', v),
            ),
          ),
          Expanded(
            flex: 2,
            child: _minimalSizeField(
              'PRICE',
              price.toInt().toString(),
              (v) {
                final p = double.tryParse(v);
                if (p != null) vm.updateSizeField(vIdx, sIdx, 'price', p);
              },
              keyboardType: TextInputType.number,
              fieldKey: ValueKey('price-$vIdx-$sIdx-${vm.editingId}'),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: _minimalSizeField(
              'SHOP',
              ((size['shopPrice'] as num?)?.toDouble() ?? 0.0)
                  .toInt()
                  .toString(),
              (v) {
                final p = double.tryParse(v);
                if (p != null) vm.updateSizeField(vIdx, sIdx, 'shopPrice', p);
              },
              keyboardType: TextInputType.number,
              fieldKey: ValueKey('shop-$vIdx-$sIdx-${vm.editingId}'),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: _minimalSizeField(
              'COMM',
              ((size['websiteCommission'] as num?)?.toDouble() ?? 0.0)
                  .toInt()
                  .toString(),
              null,
              enabled: false,
              fieldKey: ValueKey('comm-$vIdx-$sIdx-${vm.editingId}'),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STOCK',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0F0F0)),
                    ),
                  ),
                  child: TextFormField(
                    key: ValueKey('stock-$vIdx-$sIdx-${vm.editingId}'),
                    initialValue: stock.toString(),
                    onChanged: (v) {
                      final s = int.tryParse(v);
                      if (s != null) vm.updateSizeField(vIdx, sIdx, 'stock', s);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              const Text(
                'VISIBLE',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: size['isAvailable'] == true,
                  onChanged: (v) {
                    vm.updateSizeField(vIdx, sIdx, 'isAvailable', v);
                    // Mode 2: Quick Action for existing variants
                    if (size['id'] != null) {
                      vm.toggleVariantAvailableQuick(size['id'].toString(), !v);
                    }
                  },
                  activeColor: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'OUT',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  final sId = size['id'];
                  if (sId != null) {
                    vm.toggleVariantSoldOutQuick(sId.toString(), stock);
                  }
                  vm.updateSizeField(vIdx, sIdx, 'stock', stock > 0 ? 0 : 10);
                },
                icon: Icon(
                  stock > 0
                      ? Icons.check_circle_outline_rounded
                      : Icons.do_not_disturb_on_rounded,
                  size: 18,
                  color: stock > 0 ? Colors.black26 : Colors.red,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => vm.removeSizeFromVariant(vIdx, sIdx),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _minimalSizeField(
    String label,
    String value,
    void Function(String)? onChanged, {
    TextInputType keyboardType = TextInputType.text,
    Key? fieldKey,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
          ),
          child: TextFormField(
            key: fieldKey,
            initialValue: value,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 12,
              color: enabled ? Colors.black : Colors.grey,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantImageSection(AdminProductViewModel vm, int vIdx) {
    final variant = vm.formVariants[vIdx];
    final imageUrls = List<String>.from(variant['images'] ?? []);
    final selectedFiles = vm.getVariantSelectedImages(vIdx);
    final isUploading = vm.isVariantUploading(vIdx);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COLOR IMAGES',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Current Images
            ...imageUrls.asMap().entries.map((e) {
              final imgIdx = e.key;
              final url = e.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 70,
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                      image: DecorationImage(
                        image: NetworkImage(AdminApi.imageUrl(url)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () => vm.removeFormVariantImageAt(vIdx, imgIdx),
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }),
            // Selected but not uploaded preview
            ...selectedFiles.asMap().entries.map((e) {
              final fIdx = e.key;
              final file = e.value;
              return _PreviewImageWidget(
                xFile: file,
                index: fIdx,
                onRemove: () => vm.removeVariantSelectedImageAt(vIdx, fIdx),
                isUploading: isUploading,
              );
            }),
            // Add Button
            if (!isUploading)
              InkWell(
                onTap: () => vm.selectVariantImages(vIdx),
                child: Container(
                  width: 70,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    border: Border.all(
                      color: const Color(0xFFF0F0F0),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
        if (selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: isUploading
                  ? null
                  : () => vm.uploadVariantImages(vIdx),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'UPLOAD COLOR IMAGES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryDropdown(
    BuildContext context,
    AdminProductViewModel vm,
  ) {
    return Consumer<CategoryViewModel>(
      builder: (context, categoryVm, _) {
        final uniqueCategories = <String, String>{};
        for (final category in categoryVm.categories) {
          if (!uniqueCategories.containsKey(category.id)) {
            uniqueCategories[category.id] = category.name;
          }
        }

        final selectedValue =
            vm.formCategoryId != null &&
                uniqueCategories.containsKey(vm.formCategoryId)
            ? vm.formCategoryId
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'COLLECTION / CATEGORY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => _showCategoryManagement(context, categoryVm),
                  child: const Text(
                    'MANAGE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
              ),
              child: DropdownButtonFormField<String?>(
                value: selectedValue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                hint: const Text(
                  'SELECT COLLECTION',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('NO CATEGORY', style: TextStyle(fontSize: 13)),
                  ),
                  ...uniqueCategories.entries.map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(
                        entry.value.toUpperCase(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
                onChanged: vm.updateFormCategoryId,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Product list item with image carousel
class _ProductListItem extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductListItem({
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<_ProductListItem> {
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final imageUrls = p.images.where((img) => img.isNotEmpty).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFB),
                  border: Border.all(color: const Color(0xFFF5F5F5)),
                ),
                child: imageUrls.isEmpty
                    ? const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.black12,
                        size: 20,
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              AdminApi.imageUrl(imageUrls[0]),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                          if (imageUrls.length > 1)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                color: Colors.black,
                                child: Text(
                                  '+${imageUrls.length - 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ...${p.id.length > 6 ? p.id.substring(p.id.length - 6).toUpperCase() : p.id.toUpperCase()}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${p.price.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBFBFB),
                          ),
                          child: Text(
                            'QTY: ${p.quantity}',
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer<AdminProductViewModel>(
                    builder: (context, vm, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _quickToggle(
                            p.isAvailable
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            p.isAvailable ? Colors.black : Colors.grey.shade300,
                            () => vm.toggleProductAvailable(p),
                          ),
                          const SizedBox(width: 4),
                          _quickToggle(
                            (p.status == 'Sold Out' ||
                                    p.isSoldOut ||
                                    p.quantity == 0)
                                ? Icons.do_not_disturb_on_rounded
                                : Icons.check_circle_rounded,
                            (p.status == 'Sold Out' ||
                                    p.isSoldOut ||
                                    p.quantity == 0)
                                ? Colors.red
                                : Colors.green,
                            () => vm.toggleProductSoldOut(p),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionIcon(
                        Icons.edit_outlined,
                        Colors.black,
                        widget.onEdit,
                      ),
                      const SizedBox(width: 4),
                      _actionIcon(
                        Icons.delete_outline_rounded,
                        Colors.red.shade900,
                        widget.onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickToggle(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF5F5F5)),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color == Colors.black ? Colors.black : Colors.white,
          border: color == Colors.black
              ? null
              : Border.all(color: color.withOpacity(0.1)),
        ),
        child: Icon(
          icon,
          size: 14,
          color: color == Colors.black ? Colors.white : color,
        ),
      ),
    );
  }
}

/// Category Management Bottom Sheet
class _CategoryManagementSheet extends StatefulWidget {
  final CategoryViewModel categoryVm;
  const _CategoryManagementSheet({required this.categoryVm});

  @override
  State<_CategoryManagementSheet> createState() =>
      _CategoryManagementSheetState();
}

class _CategoryManagementSheetState extends State<_CategoryManagementSheet> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.categoryVm.formName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startEdit(CategoryModel category) {
    widget.categoryVm.loadCategoryForEdit(category);
    _nameController.text = category.name;
  }

  void _cancelEdit() {
    widget.categoryVm.clearCategoryForm();
    _nameController.clear();
  }

  Future<void> _submit() async {
    widget.categoryVm.updateFormName(_nameController.text);
    await widget.categoryVm.saveCategory();
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.categoryVm;
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              title: Column(
                children: [
                  Text(
                    'WESTERN GRAM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  Text(
                    vm.editingId != null
                        ? 'EDIT CLASSIFICATION'
                        : 'MANAGE ARCHIVE CATEGORIES',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 6,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              shape: const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        vm.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ),
                  _minimalField('CATEGORY NAME', _nameController),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        elevation: 0,
                      ),
                      child: vm.isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              vm.editingId != null
                                  ? 'UPDATE'
                                  : 'CREATE CATEGORY',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                  if (vm.editingId != null)
                    TextButton(
                      onPressed: _cancelEdit,
                      child: const Text(
                        'CANCEL EDIT',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Stack(
                children: [
                  vm.isLoading && vm.categories.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      : ListView.separated(
                          itemCount: vm.categories.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 24),
                          itemBuilder: (context, index) {
                            final category = vm.categories[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              title: Text(
                                category.name.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                    onPressed: () => _startEdit(category),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => vm.requestDelete(category),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  if (vm.pendingDelete != null)
                    Container(
                      color: Colors.black87,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(32),
                          padding: const EdgeInsets.all(24),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 40,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'DELETE "${vm.pendingDelete!.name.toUpperCase()}"?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'This will fail if products are linked.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: vm.clearPendingDelete,
                                      child: const Text('CANCEL'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: vm.confirmDelete,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      child: const Text('DELETE'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _minimalField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFBFBFB),
            border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget to display preview images from XFile in a web-compatible way
class _PreviewImageWidget extends StatelessWidget {
  final XFile xFile;
  final int index;
  final VoidCallback onRemove;
  final bool isUploading;

  const _PreviewImageWidget({
    required this.xFile,
    required this.index,
    required this.onRemove,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: FutureBuilder<Uint8List>(
              future: xFile.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 80,
                    height: 100,
                    color: const Color(0xFFF9F9F9),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    width: 80,
                    height: 100,
                    color: const Color(0xFFF9F9F9),
                    child: const Icon(Icons.broken_image),
                  );
                }
                return Image.memory(
                  snapshot.data!,
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.orange,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
        if (isUploading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
