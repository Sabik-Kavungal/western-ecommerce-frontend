// Renders ProductViewModel and CartViewModel; loads cart on init.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../features/products/viewmodels/product_vm.dart';
import '../features/admin/viewmodels/category_vm.dart';
import '../features/cart/viewmodels/cart_vm.dart';

import '../widgets/product_card.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only strictly necessary lifecycle updates here
  }

  void _loadInitialData() {
    context.read<CartViewModel>().loadCart();
    context.read<CategoryViewModel>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final padding = _calculateHorizontalPadding(screenWidth, isWeb);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const AppDrawer(currentRoute: '/home'),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Consumer<ProductViewModel>(
          builder: (context, productVm, _) {
            if (productVm.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'FAILED TO LOAD PRODUCTS',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productVm.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => productVm.loadProducts(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text('RETRY'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Scrollbar(
              controller: _scrollController,
              child: RefreshIndicator(
                onRefresh: () async {
                  await productVm.loadProducts();
                  if (mounted) {
                    context.read<CategoryViewModel>().loadCategories();
                  }
                },
                color: Colors.black,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // 1. Hero Sliders (Featured Products)
                    if (productVm.featuredProducts.isNotEmpty)
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _buildHeroSlider(productVm),
                        ),
                      ),

                    // 2. Category Tabs
                    SliverToBoxAdapter(
                      child: RepaintBoundary(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              _buildCategoryTabs(productVm),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text(
                                    'NEW ARRIVALS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'VIEW ALL',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.shade400,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 2. Product Grid
                    _buildProductGridSliver(context, productVm, isWeb, padding),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _calculateHorizontalPadding(double width, bool isWeb) {
    return isWeb ? (width - 1200).clamp(16.0, double.infinity) / 2 : 12.0;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 65, // Slightly taller for premium feel
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.sort_rounded,
          color: Colors.black,
          size: 24,
        ), // Classier icon
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
          icon: const Icon(Icons.search_rounded, color: Colors.black, size: 22),
          onPressed: () {},
        ),
        _buildCartButton(context),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Consumer<CartViewModel>(
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
                    color: Color(0xFFFF9900),
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
    );
  }

  Widget _buildHeroSlider(ProductViewModel vm) {
    final featured = vm.featuredProducts;
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: featured.length,
          options: CarouselOptions(
            height: 280,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, _) {
              // We could sync an internal index here if needed for dots
            },
          ),
          itemBuilder: (context, index, _) {
            final p = featured[index];
            return GestureDetector(
              onTap: () {
                vm.selectProduct(p);
                Navigator.pushNamed(context, '/product-detail');
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.zero,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      p.image ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.image)),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          color: Colors.white,
                          child: const Text(
                            'SHOP NOW',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(ProductViewModel productVm) {
    return Consumer<CategoryViewModel>(
      builder: (context, categoryVm, _) {
        if (categoryVm.isLoading) {
          return const SizedBox(height: 35);
        }

        final categories = categoryVm.categories;

        return SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              final String name;
              final String? currentId;

              if (index == 0) {
                name = "ALL";
                currentId = null;
              } else {
                name = categories[index - 1].name.toUpperCase();
                currentId = categories[index - 1].id;
              }
              final isSelected = productVm.filterCategoryId == currentId;

              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: InkWell(
                  onTap: () => productVm.setFilterCategoryId(currentId),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 12 : 0,
                        height: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --- Beautiful Minimalist Drawer ---

  // --- Product Grid (Sliver) ---
  Widget _buildProductGridSliver(
    BuildContext context,
    ProductViewModel productVm,
    bool isWeb,
    double horizontalPadding,
  ) {
    if (productVm.isLoading) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Center(child: CircularProgressIndicator(color: Colors.black)),
        ),
      );
    }

    // Design has 2 columns.
    int crossAxisCount = isWeb ? 4 : 2;
    if (MediaQuery.of(context).size.width > 1400) crossAxisCount = 5;

    // Use filtered products if available, or all.
    final list = productVm.products;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio:
              0.65, // Tighter ratio to reduce white space on mobile
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= list.length) return null;
          final p = list[index];
          return RepaintBoundary(
            child: ProductCard(
              product: p,
              onTap: () {
                productVm.selectProduct(p);
                Navigator.pushNamed(context, '/product-detail');
              },
            ),
          );
        }, childCount: list.length),
      ),
    );
  }
}
