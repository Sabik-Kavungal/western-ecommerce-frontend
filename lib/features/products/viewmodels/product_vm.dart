// feature-first: ViewModel owns loading, error, products, selection, carousel index,
// home filter, management form, and actions. UI only calls methods and renders state.
// Separation of concerns for testability and scalability.

import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../../auth/viewmodels/auth_vm.dart';

class ProductViewModel extends ChangeNotifier {
  ProductViewModel({
    required ProductApi api,
    required AuthViewModel authVm,
    required VoidCallback showLoginDialog,
    required void Function(ProductModel, String?, String?, double)
    navigateToCheckoutForProduct,
  }) : _api = api,
       _authVm = authVm,
       _showLoginDialog = showLoginDialog,
       _goToCheckout = navigateToCheckoutForProduct {
    loadProducts();
  }

  final ProductApi _api;
  final AuthViewModel _authVm;
  final VoidCallback _showLoginDialog;
  final void Function(ProductModel, String?, String?, double) _goToCheckout;

  List<ProductModel> _products = [];
  List<ProductModel> _featured = [];
  ProductModel? _selected;
  bool _isLoading = false;
  String? _error;
  int _imageIndex = 0;
  String _selectedFilter = 'All';
  String? _filterCategoryId; // Category filter for product list
  List<ColorVariant> _variants = [];
  String? _selectedColor;
  String? _selectedSize;

  List<ProductModel> get products => _products;
  List<ProductModel> get featuredProducts => _featured;
  ProductModel? get selectedProduct => _selected;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentImageIndex => _imageIndex;
  String get selectedFilter => _selectedFilter;
  String? get filterCategoryId => _filterCategoryId;
  List<ColorVariant> get variants => _variants;
  String? get selectedColor => _selectedColor;
  String? get selectedSize => _selectedSize;

  ColorVariant? get selectedColorVariant {
    if (_selectedColor == null || _variants.isEmpty) return null;
    try {
      return _variants.firstWhere(
        (v) => v.color.toLowerCase() == _selectedColor!.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  SizeVariant? get selectedSizeVariant {
    final cv = selectedColorVariant;
    if (cv == null || _selectedSize == null) return null;
    try {
      return cv.sizes.firstWhere(
        (s) => s.size.toLowerCase() == _selectedSize!.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  bool get isVariantUnavailable {
    if (_selected == null) return true;
    if (_selected!.status == 'Disabled' ||
        !_selected!.isAvailable ||
        !_selected!.isActive)
      return true;

    if (_variants.isEmpty) {
      // Simple product check
      return _selected!.isSoldOut || (_selected!.quantity ?? 0) <= 0;
    }

    final s = selectedSizeVariant;
    // If no variant selected yet, we don't disable the button,
    // instead we prompt for selection on click.
    if (s == null) return false;

    return s.status == 'Disabled' ||
        s.status == 'Sold Out' ||
        s.stock <= 0 ||
        !s.isAvailable ||
        !s.isActive;
  }

  String get variantStatusText {
    if (_selected == null) return 'UNAVAILABLE';
    if (_selected!.status == 'Disabled' ||
        !_selected!.isAvailable ||
        !_selected!.isActive)
      return 'UNAVAILABLE';
    if (_selected!.status == 'Sold Out' || _selected!.isSoldOut)
      return 'SOLD OUT';

    final s = selectedSizeVariant;
    if (s == null) return 'UNAVAILABLE';
    if (s.status == 'Disabled' || !s.isAvailable || !s.isActive)
      return 'UNAVAILABLE';
    if (s.status == 'Sold Out' || s.stock <= 0) return 'SOLD OUT';

    return 'AVAILABLE';
  }

  List<String> get displayImages {
    if (_selected == null) return [];

    // 1. If a color is selected, use the color variant images if available
    final cv = selectedColorVariant;
    if (cv != null && cv.images.isNotEmpty) {
      return cv.images;
    }
    if (cv != null && cv.image.isNotEmpty) {
      return [cv.image];
    }

    // 2. Fallback: use top-level product images
    return _selected!.images.where((e) => e.isNotEmpty).toList();
  }

  List<ProductModel> get filteredProducts => _selectedFilter == 'All'
      ? _products
      : _products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(_selectedFilter.toLowerCase()),
            )
            .toList();

  void updateSelectedFilter(String v) {
    _selectedFilter = v;
    notifyListeners();
  }

  Future<void> loadProducts({String? categoryId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final list = await _api.listProducts(
        categoryId: categoryId ?? _filterCategoryId,
      );
      print('✅ PRODUCTS LOADED: ${list.length} items');
      _products = list;

      _featured = list.where((p) => p.isFeatured).toList();
    } catch (e, stack) {
      print('❌ ERROR LOADING PRODUCTS: $e');
      print(stack);
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void setFilterCategoryId(String? categoryId) {
    _filterCategoryId = categoryId;
    notifyListeners();
    loadProducts(); // Reload products with new filter
  }

  void selectProduct(ProductModel p) {
    _selected = p;
    _imageIndex = 0;
    _selectedColor = null;
    _selectedSize = null;

    if (p.variants != null && p.variants!.isNotEmpty) {
      _variants = p.variants!;

      // Auto-select first available color
      try {
        final firstValidVariant = _variants.firstWhere(
          (v) => !v.sizes.every(
            (s) => s.status == 'Disabled' || !s.isAvailable || !s.isActive,
          ),
        );
        _selectedColor = firstValidVariant.color;

        // Auto-select first available size for that color
        if (firstValidVariant.sizes.isNotEmpty) {
          final firstValidSize = firstValidVariant.sizes.firstWhere(
            (s) => s.status != 'Disabled' && s.isAvailable && s.isActive,
            orElse: () => firstValidVariant.sizes.first,
          );
          _selectedSize = firstValidSize.size;
        }
      } catch (_) {
        // Fallback if no variants are "valid"
        _selectedColor = _variants.first.color;
        if (_variants.first.sizes.isNotEmpty) {
          _selectedSize = _variants.first.sizes.first.size;
        }
      }
    } else {
      _variants = [];
    }
    notifyListeners();
  }

  void updateSelectedColor(String color) {
    _selectedColor = color;
    _imageIndex = 0;

    // Reset size if current size not available in new color
    final cv = selectedColorVariant;
    if (cv != null) {
      if (!cv.sizes.any((s) => s.size == _selectedSize)) {
        _selectedSize = cv.sizes.isNotEmpty ? cv.sizes.first.size : null;
      }
    }
    notifyListeners();
  }

  void updateSelectedSize(String size) {
    _selectedSize = size;
    notifyListeners();
  }

  void updateImageIndex(int index, CarouselPageChangedReason reason) {
    _imageIndex = index;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {}
    try {
      return await _api.getProduct(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadAndSelectProduct(String id, {String? initialColor}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final product = await getProductById(id);
      if (product != null) {
        selectProduct(product);
        if (initialColor != null) {
          updateSelectedColor(initialColor);
        }
      } else {
        _error = 'Product not found';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void buyNow() {
    if (_selectedColor == null && _variants.isNotEmpty) {
      _error = 'Please select a color before purchasing.';
      notifyListeners();
      return;
    }

    final s = selectedSizeVariant;
    if (s == null) {
      if (_variants.isNotEmpty) {
        _error = 'Please select a size before purchasing.';
      } else {
        _error = 'This product is currently unavailable.';
      }
      notifyListeners();
      return;
    }

    if (!_authVm.isLoggedIn) {
      _showLoginDialog();
      return;
    }

    // Pass the specific variant details to checkout
    _goToCheckout(_selected!, _selectedColor, _selectedSize, s.price);
  }
}

// class ProductViewModel extends ChangeNotifier {
//   ProductViewModel({
//     required ProductService productService,
//     required AuthViewModel authVm,
//     required void Function() showLoginDialog,
//     required void Function(ProductModel p) navigateToCheckoutForProduct,
//   })  : _productService = productService,
//         _authVm = authVm,
//         _showLoginDialog = showLoginDialog,
//         _navigateToCheckoutForProduct = navigateToCheckoutForProduct {
//     loadProducts();
//   }

//   final ProductService _productService;
//   final AuthViewModel _authVm;
//   final void Function() _showLoginDialog;
//   final void Function(ProductModel p) _navigateToCheckoutForProduct;

//   List<ProductModel> _products = [];
//   List<ProductModel> _featuredProducts = [];
//   ProductModel? _selectedProduct;
//   bool _isLoading = false;
//   String? _error;
//   int _currentImageIndex = 0;
//   String _selectedFilter = 'All';

//   // Management form (no TextEditingController; primitives only)
//   String _formName = '';
//   String _formDescription = '';
//   String _formImageUrl = '';
//   String _formColor = 'Pink';
//   bool _formIsFeatured = false;
//   bool _formIsAvailable = true;
//   ProductModel? _editingProduct;
//   ProductModel? _pendingDelete;
//   String? _successMessage;

//   List<ProductModel> get products => _products;
//   List<ProductModel> get featuredProducts => _featuredProducts;
//   ProductModel? get selectedProduct => _selectedProduct;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   int get currentImageIndex => _currentImageIndex;
//   String get selectedFilter => _selectedFilter;

//   String get formName => _formName;
//   String get formDescription => _formDescription;
//   String get formImageUrl => _formImageUrl;
//   String get formColor => _formColor;
//   bool get formIsFeatured => _formIsFeatured;
//   bool get formIsAvailable => _formIsAvailable;
//   ProductModel? get editingProduct => _editingProduct;
//   ProductModel? get pendingDelete => _pendingDelete;
//   String? get successMessage => _successMessage;

//   static const List<String> colorOptions = [
//     'Pink', 'Blue', 'Red', 'Yellow', 'Green', 'Purple', 'Orange',
//     'Black', 'White', 'Grey', 'Brown', 'Navy', 'Maroon', 'Beige', 'Cream',
//   ];

//   List<ProductModel> get filteredProducts {
//     if (_selectedFilter == 'All') return _products;
//     return _products.where((p) => p.name.toLowerCase().contains(_selectedFilter.toLowerCase())).toList();
//   }

//   void loadProducts() {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//     _productService.getProducts().then((list) {
//       _products = list;
//       _featuredProducts = list.where((p) => p.isFeatured).toList();
//       _error = null;
//       _isLoading = false;
//       notifyListeners();
//     }).catchError((e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     });
//   }

//   void selectProduct(ProductModel p) {
//     _selectedProduct = p;
//     _currentImageIndex = 0;
//     notifyListeners();
//   }

//   void clearSelection() {
//     _selectedProduct = null;
//     _currentImageIndex = 0;
//     notifyListeners();
//   }

//   void updateCurrentImageIndex(int i) {
//     _currentImageIndex = i;
//     notifyListeners();
//   }

//   void updateSelectedFilter(String v) {
//     _selectedFilter = v;
//     notifyListeners();
//   }

//   ProductModel? getProductById(String id) {
//     try {
//       return _products.firstWhere((p) => p.id == id);
//     } catch (_) {
//       return null;
//     }
//   }

//   void updateProduct(ProductModel p) {
//     final i = _products.indexWhere((x) => x.id == p.id);
//     if (i >= 0) {
//       _products = [..._products]..[i] = p;
//       _featuredProducts = _products.where((x) => x.isFeatured).toList();
//       notifyListeners();
//     }
//   }

//   void addProduct(ProductModel p) {
//     _products = [p, ..._products];
//     if (p.isFeatured) _featuredProducts = _products.where((x) => x.isFeatured).toList();
//     notifyListeners();
//   }

//   void removeProductById(String id) {
//     _products = _products.where((p) => p.id != id).toList();
//     _featuredProducts = _featuredProducts.where((p) => p.id != id).toList();
//     notifyListeners();
//   }

//   void buyNow() {
//     final p = _selectedProduct;
//     if (p == null) return;
//     if (!_authVm.isLoggedIn) {
//       _showLoginDialog();
//       return;
//     }
//     _navigateToCheckoutForProduct(p);
//   }

//   // ---- Management form ----
//   void updateFormName(String v) { _formName = v; notifyListeners(); }
//   void updateFormDescription(String v) { _formDescription = v; notifyListeners(); }
//   void updateFormImageUrl(String v) { _formImageUrl = v; notifyListeners(); }
//   void updateFormColor(String v) { _formColor = v; notifyListeners(); }
//   void updateFormIsFeatured(bool v) { _formIsFeatured = v; notifyListeners(); }
//   void updateFormIsAvailable(bool v) { _formIsAvailable = v; notifyListeners(); }

//   void loadProductForEdit(ProductModel p) {
//     _editingProduct = p;
//     _formName = p.name;
//     _formDescription = p.description;
//     _formImageUrl = p.images.isNotEmpty ? p.images[0] : '';
//     _formColor = p.color;
//     _formIsFeatured = p.isFeatured;
//     _formIsAvailable = p.isAvailable;
//     notifyListeners();
//   }

//   void clearProductForm() {
//     _editingProduct = null;
//     _formName = '';
//     _formDescription = '';
//     _formImageUrl = '';
//     _formColor = 'Pink';
//     _formIsFeatured = false;
//     _formIsAvailable = true;
//     notifyListeners();
//   }

//   void saveProduct() {
//     final name = _formName.trim();
//     final desc = _formDescription.trim();
//     if (name.isEmpty) { _error = 'Name is required'; notifyListeners(); return; }
//     if (desc.isEmpty) { _error = 'Description is required'; notifyListeners(); return; }
//     _error = null;
//     final images = _formImageUrl.trim().isEmpty ? <String>[] : [_formImageUrl.trim()];
//     final p = ProductModel(
//       id: _editingProduct?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       name: name,
//       description: desc,
//       images: images,
//       price: Constants.onlinePrice,
//       color: _formColor,
//       quantity: 1,
//       availableSizes: ['Free Size'],
//       isFeatured: _formIsFeatured,
//       isAvailable: _formIsAvailable,
//     );
//     if (_editingProduct != null) {
//       updateProduct(p);
//       _successMessage = 'Product updated successfully!';
//     } else {
//       addProduct(p);
//       _successMessage = 'Product added successfully!';
//     }
//     clearProductForm();
//     notifyListeners();
//   }

//   void requestDelete(ProductModel p) {
//     _pendingDelete = p;
//     notifyListeners();
//   }

//   void clearPendingDelete() {
//     _pendingDelete = null;
//     notifyListeners();
//   }

//   void confirmDelete() {
//     final p = _pendingDelete;
//     if (p == null) return;
//     removeProductById(p.id);
//     _pendingDelete = null;
//     _successMessage = 'Product deleted!';
//     notifyListeners();
//   }

//   void clearSuccessMessage() {
//     _successMessage = null;
//     notifyListeners();
//   }
// }
