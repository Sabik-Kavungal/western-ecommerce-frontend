import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:e/core/constants/app_constants.dart';
import '../../products/models/product_model.dart';
import '../viewmodels/product_vm.dart';
import '../../cart/viewmodels/cart_vm.dart';
import '../../auth/viewmodels/auth_vm.dart';
import '../../../widgets/login_dialog.dart';

class ProductDetailPage extends StatefulWidget {
  final String? initialProductId;
  final String? initialColor;
  const ProductDetailPage({
    super.key,
    this.initialProductId,
    this.initialColor,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  static const _freeSize = 'Free Size';
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  ProductViewModel? _productVm;

  @override
  void initState() {
    super.initState();
    _productVm = context.read<ProductViewModel>();
    _productVm?.addListener(_onProductVmChanged);
    if (widget.initialProductId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _productVm?.loadAndSelectProduct(
          widget.initialProductId!,
          initialColor: widget.initialColor,
        );
        // Ensure carousel starts at first image
        _carouselController.jumpToPage(0);
      });
    }
  }

  @override
  void dispose() {
    _productVm?.removeListener(_onProductVmChanged);
    super.dispose();
  }

  void _onProductVmChanged() {
    if (!mounted || _productVm == null) return;
    final vm = _productVm!;
    if (vm.error != null && vm.error!.contains('purchasing')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error!),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
      vm.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProductViewModel, CartViewModel, AuthViewModel>(
      builder: (context, productVm, cartVm, authVm, _) {
        if (productVm.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        final product = productVm.selectedProduct;
        if (product == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Product not found'),
                  if (productVm.error != null)
                    Text(
                      productVm.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Go Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final images = product.images.where((e) => e.isNotEmpty).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context, productVm),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWeb = constraints.maxWidth >= 900;
              final double horizontalPadding = isWeb
                  ? (constraints.maxWidth - 1200).clamp(16, double.infinity) / 2
                  : 16;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? horizontalPadding : 0,
                        vertical: 12,
                      ),
                      child: isWeb
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildImageSection(productVm)),
                                const SizedBox(width: 60),
                                Expanded(
                                  child: _buildInfoSection(
                                    context,
                                    product,
                                    productVm,
                                    cartVm,
                                    authVm,
                                    isWeb: true,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildImageSection(productVm),
                                const SizedBox(height: 12), // Reduced space
                                _buildInfoSection(
                                  context,
                                  product,
                                  productVm,
                                  cartVm,
                                  authVm,
                                  isWeb: false,
                                ),
                                const SizedBox(
                                  height: 100,
                                ), // Space for sticky bottom bar
                              ],
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: LayoutBuilder(
            builder: (context, constraints) {
              final isWeb = constraints.maxWidth >= 900;
              if (isWeb) return const SizedBox.shrink();
              return _buildStickyActions(
                context,
                product,
                productVm,
                cartVm,
                authVm,
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ProductViewModel productVm,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black, size: 22),
          onPressed: () => _showShareSheet(context, productVm),
        ),
        Consumer<CartViewModel>(
          builder: (context, cartVm, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
                if (cartVm.itemCount > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9900), // Amazon Amber
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartVm.itemCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ---------------- IMAGE SECTION ----------------
  Widget _buildImageSection(ProductViewModel vm) {
    // 1. Gather all unique images with their associated color context
    final List<Map<String, dynamic>> carouselItems = [];

    // Add main product images
    if (vm.selectedProduct != null) {
      for (final img in vm.selectedProduct!.images.where((e) => e.isNotEmpty)) {
        carouselItems.add({'url': img, 'color': null});
      }
    }

    // Add variant-specific images
    for (final variant in vm.variants) {
      for (final img in variant.images.where((e) => e.isNotEmpty)) {
        carouselItems.add({'url': img, 'color': variant.color});
      }
      if (variant.image.isNotEmpty && !variant.images.contains(variant.image)) {
        carouselItems.add({'url': variant.image, 'color': variant.color});
      }
    }

    if (carouselItems.isEmpty) return _emptyImage();

    return RepaintBoundary(
      child: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: carouselItems.length,
            itemBuilder: (context, index, _) =>
                _buildImage(carouselItems[index]['url']),
            options: CarouselOptions(
              height: 500,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                vm.updateImageIndex(index, reason);
                // If the user swiped manually, update the selected color
                if (reason == CarouselPageChangedReason.manual) {
                  final color = carouselItems[index]['color'];
                  if (color != null && color != vm.selectedColor) {
                    vm.updateSelectedColor(color);
                  }
                }
              },
            ),
          ),

          // Discount badge
          Positioned(
            top: 15,
            left: 15,
            child: RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'LIMITED SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 8,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),

          // Dot indicator overlay
          if (carouselItems.length > 1)
            Positioned(
              bottom: 12, // Tighter
              left: 20,
              child: Row(
                children: carouselItems.asMap().entries.map((e) {
                  final isActive = vm.currentImageIndex == e.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 16 : 4,
                    height: 4,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.black
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- INFO SECTION ----------------
  Widget _buildInfoSection(
    BuildContext context,
    ProductModel product,
    ProductViewModel productVm,
    CartViewModel cartVm,
    AuthViewModel authVm, {
    required bool isWeb,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Two-tone Category/Brand
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: (product.categoryName ?? 'Western').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: ' GRAM',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 9, letterSpacing: 3),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end, // Aligned to bottom
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22, // Slightly more compact
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Serif',
                        color: Color(0xFF1A1A1A),
                        height: 1.1,
                      ),
                    ),
                    if (productVm.selectedColor != null ||
                        productVm.selectedSize != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          [
                            if (productVm.selectedColor != null)
                              productVm.selectedColor,
                            if (productVm.selectedSize != null)
                              productVm.selectedSize,
                          ].join(' / '),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(productVm.selectedSizeVariant?.price ?? product.price).toInt()}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹${((productVm.selectedSizeVariant?.price ?? product.price) * 1.5).toInt()}', // Bigger markdown
                    style: TextStyle(
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          const SizedBox(height: 12),

          _buildSizeSelector(productVm),

          const SizedBox(height: 16),
          _buildColorSelector(productVm),

          const SizedBox(height: 16),
          const Text(
            'PRODUCT DESCRIPTION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Colors.grey.shade700,
            ),
          ),

          if (isWeb) ...[
            const SizedBox(height: 48),
            _buildActionButtons(context, product, productVm, cartVm, authVm),
          ],

          const SizedBox(height: 40),
          // Additional features could go here (delivery info, etc.)
        ],
      ),
    );
  }

  // ---------------- STICKY ACTIONS ----------------
  Widget _buildStickyActions(
    BuildContext context,
    ProductModel product,
    ProductViewModel productVm,
    CartViewModel cartVm,
    AuthViewModel authVm,
  ) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: _buildActionButtons(
            context,
            product,
            productVm,
            cartVm,
            authVm,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ProductModel product,
    ProductViewModel productVm,
    CartViewModel cartVm,
    AuthViewModel authVm,
  ) {
    final isUnavailable = productVm.isVariantUnavailable;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isUnavailable
                ? null
                : () async {
                    if (!authVm.isLoggedIn) {
                      showDialog(
                        context: context,
                        builder: (_) => const LoginDialog(),
                      );
                      return;
                    }
                    if (productVm.variants.isNotEmpty &&
                        productVm.selectedColor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select a color before purchasing.',
                          ),
                          backgroundColor: Colors.black,
                        ),
                      );
                      return;
                    }
                    final targetProduct = product; // Use parent product
                    final selectedSize = productVm.selectedSize ?? _freeSize;

                    await cartVm.addProduct(
                      targetProduct,
                      selectedSize,
                      1,
                      color: productVm.selectedColor,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to bag'),
                          backgroundColor: Colors.black,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ), // Thicker border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2), // Micro corner
              ),
            ),
            child: Text(
              isUnavailable ? productVm.variantStatusText : 'ADD TO BAG',
              style: TextStyle(
                color: isUnavailable ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w900, // Blacker
                letterSpacing: 2,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isUnavailable ? null : productVm.buyNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              elevation: 8, // More tactile shadow
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              isUnavailable ? productVm.variantStatusText : 'BUY NOW',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- HELPERS ----------------

  Widget _buildImage(String url) {
    final imageUrl = url.startsWith('http')
        ? url
        : '${Constants.apiOrigin}$url';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        height: 500,
        width: double.infinity,
        fit: BoxFit.cover,
        cacheHeight: 1000, // Optimize memory for high-res detail images
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.grey),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFF9F9F9),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black26,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyImage() {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildSizeSelector(ProductViewModel vm) {
    final cv = vm.selectedColorVariant;
    if (cv == null || cv.sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SIZE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cv.sizes.map((s) {
            final isSelected = vm.selectedSize == s.size;
            final isSoldOut = s.status == 'Sold Out' || s.stock <= 0;
            final isDisabled =
                s.status == 'Disabled' || !s.isAvailable || !s.isActive;
            final isInteractable = !isSoldOut && !isDisabled;

            return InkWell(
              onTap: isInteractable
                  ? () => vm.updateSelectedSize(s.size)
                  : null,
              child: Opacity(
                opacity: isInteractable ? 1.0 : 0.3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        s.size.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.5,
                          decoration: isDisabled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (isSoldOut && !isDisabled)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Transform.rotate(
                            angle: 0.5,
                            child: const Text(
                              '•',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector(ProductViewModel vm) {
    if (vm.variants.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COLOR',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: vm.variants.map((v) {
            final isSelected = vm.selectedColor == v.color;
            final allDisabled =
                v.sizes.isNotEmpty &&
                v.sizes.every(
                  (s) =>
                      s.status == 'Disabled' || !s.isAvailable || !s.isActive,
                );
            final allSoldOut =
                !allDisabled &&
                v.sizes.isNotEmpty &&
                v.sizes.every((s) => s.status == 'Sold Out' || s.stock <= 0);
            final totalStock = v.sizes.fold<int>(0, (sum, s) => sum + s.stock);
            final canTap = !allDisabled;

            String stockLabel = '';
            if (allDisabled)
              stockLabel = 'UNA';
            else if (allSoldOut)
              stockLabel = 'OLD';
            else
              stockLabel = '$totalStock LEFT';

            return InkWell(
              onTap: canTap
                  ? () {
                      vm.updateSelectedColor(v.color);

                      final List<Map<String, dynamic>> items = [];
                      if (vm.selectedProduct != null) {
                        for (final img in vm.selectedProduct!.images.where(
                          (e) => e.isNotEmpty,
                        )) {
                          items.add({'url': img, 'color': null});
                        }
                      }
                      for (final variant in vm.variants) {
                        for (final img in variant.images.where(
                          (e) => e.isNotEmpty,
                        )) {
                          items.add({'url': img, 'color': variant.color});
                        }
                        if (variant.image.isNotEmpty &&
                            !variant.images.contains(variant.image)) {
                          items.add({
                            'url': variant.image,
                            'color': variant.color,
                          });
                        }
                      }

                      int targetIndex = items.indexWhere(
                        (item) => item['color'] == v.color,
                      );
                      if (targetIndex != -1) {
                        _carouselController.animateToPage(
                          targetIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    }
                  : null,
              child: Opacity(
                opacity: allDisabled ? 0.3 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        v.color.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black,
                          letterSpacing: 0.5,
                          decoration: allDisabled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (stockLabel.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          '($stockLabel)',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? Colors.white60
                                : Colors.red.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  // ---------------- SHARE SHEET (WESTERN GRAM ARCHIVAL STYLE) ----------------

  void _showShareSheet(BuildContext context, ProductViewModel vm) {
    final product = vm.selectedProduct!;
    final currentPrice = (vm.selectedSizeVariant?.price ?? product.price)
        .toInt();

    // Construct product URL
    final productUrl =
        'https://westerngram.net/product/${product.id}${vm.selectedColor != null ? "?color=${Uri.encodeComponent(vm.selectedColor!)}" : ""}';

    // Get product image
    final String imageUrl = (vm.selectedColorVariant?.images.isNotEmpty == true)
        ? vm.selectedColorVariant!.images.first
        : (product.images.isNotEmpty == true ? product.images.first : '');
    final String fullImageUrl = imageUrl.startsWith('http')
        ? imageUrl
        : '${Constants.apiOrigin}$imageUrl';

    final String colorSuffix = vm.selectedColor != null
        ? ' (${vm.selectedColor})'
        : '';
    final shareText =
        'Check this out! ${product.name}$colorSuffix for ₹$currentPrice on Western Gram: $productUrl';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ), // Sharp elite edges or very subtle round
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black, width: 2)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'WESTERN GRAM',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SHARE PRODUCT',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 20),

              // Elite Product Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF0F0F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Color(0xFFF0F0F0)),
                          ),
                        ),
                        child: Image.network(
                          fullImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'CODE: #${product.id.toString().padLeft(4, '0')}',
                              style: TextStyle(
                                fontSize: 7,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹$currentPrice',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Systematic Action Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShareActionTile(
                      icon: Icons.send_rounded,
                      label: 'WHATSAPP',
                      onTap: () async {
                        Navigator.pop(context);
                        await Share.share(shareText);
                      },
                    ),
                    _buildShareActionTile(
                      icon: Icons.link_rounded,
                      label: 'COPY LINK',
                      onTap: () async {
                        Navigator.pop(context);
                        await Clipboard.setData(ClipboardData(text: shareText));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PRODUCT INFO COPIED!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                    _buildShareActionTile(
                      icon: Icons.ios_share_rounded,
                      label: 'MORE',
                      onTap: () async {
                        Navigator.pop(context);
                        if (kIsWeb) {
                          await Share.share(shareText);
                          return;
                        }
                        _triggerSocialShare(
                          context,
                          product,
                          fullImageUrl,
                          shareText,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFF0F0F0)),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.black, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _triggerSocialShare(
    BuildContext context,
    ProductModel product,
    String fullImageUrl,
    String shareText,
  ) async {
    try {
      final response = await http
          .get(Uri.parse(fullImageUrl))
          .timeout(const Duration(seconds: 5));
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/share_${product.id}.jpg');
      await tempFile.writeAsBytes(response.bodyBytes);
      await Share.shareXFiles([
        XFile(
          tempFile.path,
          name: '${product.name}.jpg',
          mimeType: 'image/jpeg',
        ),
      ], text: shareText);
    } catch (e) {
      await Share.share(shareText);
    }
  }
}
