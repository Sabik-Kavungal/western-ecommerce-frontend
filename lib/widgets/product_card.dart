import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../features/products/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) {
    // Gather all unique images (main, gallery, and variant images)
    final Set<String> allImages = {};
    if (product.image != null && product.image!.isNotEmpty)
      allImages.add(product.image!);
    allImages.addAll(product.images.where((i) => i.isNotEmpty));
    if (product.variants != null) {
      for (final variant in product.variants!) {
        if (variant.image.isNotEmpty) allImages.add(variant.image);
        allImages.addAll(variant.images.where((i) => i.isNotEmpty));
      }
    }
    final imageList = allImages.toList();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: ColorFiltered(
                        colorFilter:
                            (product.status == 'Disabled' ||
                                product.status == 'Sold Out' ||
                                product.isSoldOut)
                            ? const ColorFilter.matrix([
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ])
                            : const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9F9),
                          ),
                          child: imageList.isEmpty
                              ? _imagePlaceholder()
                              : CarouselSlider.builder(
                                  itemCount: imageList.length,
                                  options: CarouselOptions(
                                    height: double.infinity,
                                    viewportFraction: 1.0,
                                    autoPlay: imageList.length > 1,
                                    autoPlayInterval: const Duration(
                                      seconds: 4,
                                    ),
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 800,
                                    ),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: false,
                                    pauseAutoPlayOnTouch: true,
                                    scrollPhysics:
                                        const BouncingScrollPhysics(), // Enabled manual slide
                                  ),
                                  itemBuilder: (context, index, realIndex) {
                                    return Image.network(
                                      imageList[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      cacheWidth: 350,
                                      errorBuilder: (_, __, ___) =>
                                          _imagePlaceholder(),
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return _imagePlaceholder();
                                          },
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    child: RepaintBoundary(child: _buildBrandTag()),
                  ),

                  if (product.status == 'Disabled' ||
                      product.status == 'Sold Out' ||
                      product.isSoldOut)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.4),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                            ),
                            child: Text(
                              product.status == 'Disabled'
                                  ? 'UNAVAILABLE'
                                  : 'SOLD OUT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),
          RepaintBoundary(child: _buildProductInfo()),
        ],
      ),
    );
  }

  Widget _buildBrandTag() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: (product.categoryName ?? 'NEW').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: ' GRAM',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          style: const TextStyle(fontSize: 9, letterSpacing: 1.5),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Serif',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '₹${product.price.toInt()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              if (product.price > 0)
                Text(
                  '₹${(product.price * 1.5).toInt()}',
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 24,
        color: Color(0xFFEEEEEE),
      ),
    );
  }
}
