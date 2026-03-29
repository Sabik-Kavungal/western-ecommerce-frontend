// StatelessWidget. Only renders ProductViewModel state; all actions via VM.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/product_vm.dart';
import '../../../widgets/product_card.dart';
import '../../admin/admin_module.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'COLLECTIONS',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                RepaintBoundary(child: _buildCategoryFilter()),
                Expanded(
                  child: Consumer<ProductViewModel>(
                    builder: (context, productVm, _) {
                      if (productVm.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        );
                      }

                      if (productVm.error != null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Error: ${productVm.error}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => productVm.loadProducts(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final products = productVm.products;
                      if (products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No products available',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              if (productVm.filterCategoryId != null) ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () =>
                                      productVm.setFilterCategoryId(null),
                                  child: const Text(
                                    'Clear Filter',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                          await productVm.loadProducts();
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _getCrossAxisCount(context),
                                childAspectRatio:
                                    0.62, // Tighter ratio for better mobile fit
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 24,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return RepaintBoundary(
                              child: ProductCard(
                                product: products[index],
                                onTap: () {
                                  productVm.selectProduct(products[index]);
                                  Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  Widget _buildCategoryFilter() {
    return Consumer<CategoryViewModel>(
      builder: (context, categoryVm, _) {
        return Consumer<ProductViewModel>(
          builder: (context, productVm, _) {
            final uniqueCategories = <String, String>{};
            for (final cat in categoryVm.categories) {
              if (!uniqueCategories.containsKey(cat.id)) {
                uniqueCategories[cat.id] = cat.name;
              }
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 18, color: Colors.black),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: productVm.filterCategoryId,
                        isDense: true,
                        isExpanded: true,
                        hint: const Text(
                          "FILTER BY CATEGORY",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              'ALL CATEGORIES',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          ...uniqueCategories.entries.map(
                            (entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(
                                entry.value.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: productVm.setFilterCategoryId,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
