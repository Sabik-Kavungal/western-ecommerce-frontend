// Admin product management: list (API), create (upload images + POST), update, delete.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';

import '../../products/models/product_model.dart';
import '../services/admin_api.dart';

class AdminProductViewModel extends ChangeNotifier {
  AdminProductViewModel({
    required AdminApi api,
    required String? Function() getToken,
    required Future<List<XFile>> Function() pickImages,
  }) : _api = api,
       _getToken = getToken,
       _pickImages = pickImages;

  final AdminApi _api;
  final String? Function() _getToken;
  final Future<List<XFile>> Function() _pickImages;

  List<ProductModel> _products = [];
  int _page = 1, _limit = 20, _total = 0, _totalPages = 1;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  ProductModel? _pendingDelete;
  String? _filterCategoryId; // Category filter for product list

  // Form
  String _formName = '';
  String _formDescription = '';
  double _formPrice = 400.0;
  bool _formIsFeatured = false;
  bool _formIsAvailable = true;
  bool _formIsActive = true;
  String? _formCategoryId;
  double _formShopPrice = 0.0;
  double _formWebsiteCommission = 0.0;
  List<Map<String, dynamic>> _formVariants = [];
  Map<int, List<XFile>> _selectedVariantImageFiles =
      {}; // Preview images per variant
  Map<int, bool> _isVariantUploading = {}; // Upload status per variant
  String? _editingId;
  bool _isSaving = false;
  bool _isUploading = false;

  List<ProductModel> get products => _products;
  int get page => _page;
  int get limit => _limit;
  int get total => _total;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  ProductModel? get pendingDelete => _pendingDelete;
  String? get filterCategoryId => _filterCategoryId;

  String get formName => _formName;
  String get formDescription => _formDescription;
  double get formPrice => _formPrice;
  bool get formIsFeatured => _formIsFeatured;
  bool get formIsAvailable => _formIsAvailable;
  bool get formIsActive => _formIsActive;
  String? get formCategoryId => _formCategoryId;
  String? get editingId => _editingId;
  bool get isSaving => _isSaving;
  bool get isUploading => _isUploading;
  double get formShopPrice => _formShopPrice;
  double get formWebsiteCommission => _formWebsiteCommission;
  List<Map<String, dynamic>> get formVariants =>
      List.unmodifiable(_formVariants);

  List<XFile> getVariantSelectedImages(int index) =>
      _selectedVariantImageFiles[index] ?? [];
  bool isVariantUploading(int index) => _isVariantUploading[index] ?? false;

  static const List<String> colorOptions = [
    'Pink',
    'Blue',
    'Red',
    'Yellow',
    'Green',
    'Purple',
    'Orange',
    'Black',
    'White',
    'Grey',
    'Brown',
    'Navy',
    'Maroon',
    'Beige',
    'Cream',
    'Off-White',
  ];

  Future<void> loadProducts({
    int? page,
    bool? featured,
    bool? available,
    String? color,
    String? search,
    String? categoryId,
  }) async {
    final t = _getToken();
    if (t == null || t.isEmpty) {
      _error = 'Not logged in';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final r = await _api.listProducts(
        token: t,
        page: page ?? _page,
        limit: _limit,
        featured: featured,
        available: available,
        color: color,
        search: search,
        categoryId: categoryId ?? _filterCategoryId,
      );
      _products = r.products;
      _page = r.page;
      _total = r.total;
      _totalPages = r.totalPages;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Quick toggle of product availability using PATCH (Developer Rule #2)
  Future<void> toggleProductAvailable(ProductModel p) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;

    final newStatus = !p.isAvailable;
    _isLoading = true;
    notifyListeners();

    try {
      await _api.updateProduct(
        p.id,
        {'isAvailable': newStatus},
        t,
        method: 'PATCH',
      );
      // Update local state without full reload
      final idx = _products.indexWhere((item) => item.id == p.id);
      if (idx != -1) {
        _products[idx] = _products[idx].copyWith(isAvailable: newStatus);
      }
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Quick toggle of featured status using PATCH (Developer Rule #2)
  Future<void> toggleProductFeatured(ProductModel p) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;

    final newStatus = !p.isFeatured;
    _isLoading = true;
    notifyListeners();

    try {
      await _api.updateProduct(
        p.id,
        {'isFeatured': newStatus},
        t,
        method: 'PATCH',
      );
      // Update local state
      final idx = _products.indexWhere((item) => item.id == p.id);
      if (idx != -1) {
        _products[idx] = _products[idx].copyWith(isFeatured: newStatus);
      }
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Quick toggle of product sold out status (Developer Rule #2)
  /// If marking sold out, sets stock to 0. If marking available, sets stock to 10 (default).
  Future<void> toggleProductSoldOut(ProductModel p) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;

    final isSold = p.status == 'Sold Out' || p.isSoldOut || p.quantity == 0;
    final newStock = isSold ? 10 : 0;
    _isLoading = true;
    notifyListeners();

    try {
      await _api.updateProduct(p.id, {'stock': newStock}, t, method: 'PATCH');
      // Update local state
      final idx = _products.indexWhere((item) => item.id == p.id);
      if (idx != -1) {
        _products[idx] = _products[idx].copyWith(
          quantity: newStock,
          isSoldOut: !isSold,
        );
      }
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Quick individual variant visibility toggle (Developer Rule #2 - Mode 2)
  Future<void> toggleVariantAvailableQuick(
    String variantId,
    bool currentStatus,
  ) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;

    final newStatus = !currentStatus;
    _isLoading = true;
    notifyListeners();

    try {
      await _api.updateProduct(
        variantId,
        {'isAvailable': newStatus},
        t,
        method: 'PATCH',
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Quick individual variant sold out toggle (Developer Rule #2 - Mode 2)
  Future<void> toggleVariantSoldOutQuick(
    String variantId,
    int currentStock,
  ) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;

    final newStock = currentStock > 0 ? 0 : 10;
    _isLoading = true;
    notifyListeners();

    try {
      await _api.updateProduct(
        variantId,
        {'stock': newStock},
        t,
        method: 'PATCH',
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProductForEdit(String id) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final p = await _api.getProduct(id, t);
      _editingId = id;
      _formName = p.name;
      _formDescription = p.description;
      _formPrice = p.price;
      _formIsFeatured = p.isFeatured;
      _formIsAvailable = p.isAvailable;
      _formIsActive = p.isActive;
      _formCategoryId = p.categoryId;
      _formShopPrice = p.shopPrice;
      _formWebsiteCommission = p.websiteCommission;

      // Load variants if they exist
      if (p.variants != null && p.variants!.isNotEmpty) {
        _formVariants = p.variants!.map((v) {
          return {
            'id': v.id,
            'color': v.color,
            'images': v.images,
            'sizes':
                v.sizes
                    ?.map(
                      (s) => {
                        'id': s.id,
                        'name': s.name,
                        'size': s.size,
                        'stock': s.stock,
                        'price': s.price,
                        'shopPrice': s.shopPrice,
                        'websiteCommission': s.websiteCommission,
                        'isAvailable': s.isAvailable,
                        'isActive': s.isActive,
                      },
                    )
                    .toList() ??
                [],
          };
        }).toList();
      } else {
        _formVariants = [];
      }

      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearProductForm() {
    _editingId = null;
    _formName = '';
    _formDescription = '';
    _formPrice = 400.0;
    _formIsFeatured = false;
    _formIsAvailable = true;
    _formIsActive = true;
    _formCategoryId = null;
    _formShopPrice = 0.0;
    _formWebsiteCommission = 0.0;
    _formVariants = [
      {
        'color': 'Black',
        'images': [],
        'sizes': [
          {
            'name': '',
            'size': 'Free Size',
            'stock': 1,
            'price': 400.0,
            'shopPrice': 0.0,
            'websiteCommission': 0.0,
            'isAvailable': true,
            'isActive': true,
          },
        ],
      },
    ];
    _error = null;
    notifyListeners();
  }

  void updateFormName(String v) {
    _formName = v;
    notifyListeners();
  }

  void updateFormDescription(String v) {
    _formDescription = v;
    notifyListeners();
  }

  void updateFormPrice(double v) {
    _formPrice = v;
    _formWebsiteCommission = _formPrice - _formShopPrice;
    notifyListeners();
  }

  void updateFormShopPrice(double v) {
    _formShopPrice = v;
    _formWebsiteCommission = _formPrice - _formShopPrice;
    notifyListeners();
  }

  void updateFormIsFeatured(bool v) {
    _formIsFeatured = v;
    notifyListeners();
  }

  void updateFormIsAvailable(bool v) {
    _formIsAvailable = v;
    notifyListeners();
  }

  void updateFormIsActive(bool v) {
    _formIsActive = v;
    notifyListeners();
  }

  void updateFormCategoryId(String? v) {
    _formCategoryId = v;
    notifyListeners();
  }

  void addFormVariant() {
    _formVariants = [
      ..._formVariants,
      {
        'color': 'Pink',
        'images': [],
        'sizes': [
          {
            'name': '',
            'size': 'Free Size',
            'stock': 1,
            'price': _formPrice,
            'shopPrice': _formShopPrice,
            'websiteCommission': _formWebsiteCommission,
            'isAvailable': true,
            'isActive': true,
          },
        ],
      },
    ];
    notifyListeners();
  }

  void addSizeToVariant(int variantIndex) {
    if (variantIndex >= 0 && variantIndex < _formVariants.length) {
      final variant = Map<String, dynamic>.from(_formVariants[variantIndex]);
      final sizes = List<Map<String, dynamic>>.from(variant['sizes'] ?? []);
      sizes.add({
        'name': '',
        'size': 'M',
        'stock': 1,
        'price': variant['sizes']?.isNotEmpty == true
            ? variant['sizes'].first['price']
            : _formPrice,
        'shopPrice': variant['sizes']?.isNotEmpty == true
            ? variant['sizes'].first['shopPrice']
            : _formShopPrice,
        'websiteCommission': variant['sizes']?.isNotEmpty == true
            ? variant['sizes'].first['websiteCommission']
            : _formWebsiteCommission,
        'isAvailable': true,
        'isActive': true,
      });
      variant['sizes'] = sizes;
      _formVariants = [..._formVariants];
      _formVariants[variantIndex] = variant;
      notifyListeners();
    }
  }

  void removeSizeFromVariant(int variantIndex, int sizeIndex) {
    if (variantIndex >= 0 && variantIndex < _formVariants.length) {
      final variant = Map<String, dynamic>.from(_formVariants[variantIndex]);
      final sizes = List<Map<String, dynamic>>.from(variant['sizes'] ?? []);
      if (sizeIndex >= 0 && sizeIndex < sizes.length) {
        sizes.removeAt(sizeIndex);
        variant['sizes'] = sizes;
        _formVariants = [..._formVariants];
        _formVariants[variantIndex] = variant;
        notifyListeners();
      }
    }
  }

  void updateSizeField(
    int variantIndex,
    int sizeIndex,
    String field,
    dynamic value,
  ) {
    if (variantIndex >= 0 && variantIndex < _formVariants.length) {
      final variant = Map<String, dynamic>.from(_formVariants[variantIndex]);
      final sizes = List<Map<String, dynamic>>.from(variant['sizes'] ?? []);
      if (sizeIndex >= 0 && sizeIndex < sizes.length) {
        sizes[sizeIndex] = {...sizes[sizeIndex], field: value};

        // Auto-calculate commission if price or shopPrice changed
        if (field == 'price' || field == 'shopPrice') {
          final p = (sizes[sizeIndex]['price'] as num?)?.toDouble() ?? 0.0;
          final s = (sizes[sizeIndex]['shopPrice'] as num?)?.toDouble() ?? 0.0;
          sizes[sizeIndex]['websiteCommission'] = p - s;
        }

        variant['sizes'] = sizes;
        _formVariants = [..._formVariants];
        _formVariants[variantIndex] = variant;
        notifyListeners();
      }
    }
  }

  void removeFormVariantAt(int i) {
    if (i >= 0 && i < _formVariants.length) {
      _formVariants = [..._formVariants]..removeAt(i);
      notifyListeners();
    }
  }

  void updateVariantColor(int i, String color) {
    if (i >= 0 && i < _formVariants.length) {
      _formVariants = [..._formVariants];
      _formVariants[i] = {..._formVariants[i], 'color': color};
      notifyListeners();
    }
  }

  void setFilterCategoryId(String? categoryId) {
    _filterCategoryId = categoryId;
    notifyListeners();
    loadProducts(page: 1); // Reload products with new filter
  }

  /// --- Variant Specific Image Handling ---

  void removeFormVariantImageAt(int variantIndex, int imageIndex) {
    if (variantIndex >= 0 && variantIndex < _formVariants.length) {
      final v = Map<String, dynamic>.from(_formVariants[variantIndex]);
      final images = List<String>.from(v['images'] ?? []);
      if (imageIndex >= 0 && imageIndex < images.length) {
        images.removeAt(imageIndex);
        v['images'] = images;
        _formVariants = [..._formVariants];
        _formVariants[variantIndex] = v;
        notifyListeners();
      }
    }
  }

  void removeVariantSelectedImageAt(int variantIndex, int imageIndex) {
    if (_selectedVariantImageFiles.containsKey(variantIndex)) {
      final files = List<XFile>.from(_selectedVariantImageFiles[variantIndex]!);
      if (imageIndex >= 0 && imageIndex < files.length) {
        files.removeAt(imageIndex);
        _selectedVariantImageFiles[variantIndex] = files;
        notifyListeners();
      }
    }
  }

  Future<void> selectVariantImages(int variantIndex) async {
    try {
      final xfiles = await _pickImages();
      if (xfiles.isEmpty) return;

      final currentSelected = _selectedVariantImageFiles[variantIndex] ?? [];
      final total = currentSelected.length + xfiles.length;
      if (total > 50) {
        _error = 'Maximum 50 images allowed per color.';
        notifyListeners();
        return;
      }

      const maxSizeBytes = 100 * 1024 * 1024;
      final valid = <XFile>[];
      for (final x in xfiles) {
        if (await x.length() <= maxSizeBytes) {
          valid.add(x);
        }
      }

      if (valid.isNotEmpty) {
        _selectedVariantImageFiles[variantIndex] = [
          ...currentSelected,
          ...valid,
        ];
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to select variant images: $e';
      notifyListeners();
    }
  }

  Future<void> uploadVariantImages(int variantIndex) async {
    final files = _selectedVariantImageFiles[variantIndex] ?? [];
    if (files.isEmpty) return;

    final t = _getToken();
    if (t == null) return;

    _isVariantUploading[variantIndex] = true;
    _error = null;
    notifyListeners();

    try {
      final descs = <MultipartFileDesc>[];
      for (final x in files) {
        final length = await x.length();
        final ext = x.name.toLowerCase().split('.').last;
        String mime = 'image/jpeg';
        if (ext == 'png') mime = 'image/png';
        if (ext == 'gif') mime = 'image/gif';
        if (ext == 'webp') mime = 'image/webp';
        if (ext == 'svg') mime = 'image/svg+xml';
        if (ext == 'ico') mime = 'image/x-icon';

        descs.add(
          MultipartFileDesc(
            filename: x.name,
            mimeType: mime,
            stream: x.openRead(),
            length: length,
          ),
        );
      }

      final urls = await _api.uploadImages(descs, t);

      // Add URLs to variant
      final v = Map<String, dynamic>.from(_formVariants[variantIndex]);
      final currentImages = List<String>.from(v['images'] ?? []);
      v['images'] = [...currentImages, ...urls];

      _formVariants = [..._formVariants];
      _formVariants[variantIndex] = v;

      // Clear selected files
      _selectedVariantImageFiles.remove(variantIndex);
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isVariantUploading.remove(variantIndex);
      notifyListeners();
    }
  }

  // /// Upload selected preview images and add URLs to form.
  // /// Validates: max 50 files per request (backend requirement).
  // Future<void> uploadSelectedImages() async {
  //   if (_selectedImageFiles.isEmpty) return;

  //   // Validate file count (max 50 per request)
  //   if (_selectedImageFiles.length > 50) {
  //     _error =
  //         'Maximum 50 images allowed per upload. Please select fewer images.';
  //     notifyListeners();
  //     return;
  //   }

  //   final t = _getToken();
  //   if (t == null || t.isEmpty) {
  //     _error = 'Not logged in';
  //     notifyListeners();
  //     return;
  //   }

  //   _isUploading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final descs = <MultipartFileDesc>[];
  //     for (final x in _selectedImageFiles) {
  //       final bytes = await x.readAsBytes();
  //       // Detect MIME type from filename extension (matches backend requirements)
  //       final ext = x.name.toLowerCase().split('.').last;
  //       String mimeType;
  //       switch (ext) {
  //         case 'jpg':
  //         case 'jpeg':
  //           mimeType = 'image/jpeg';
  //           break;
  //         case 'png':
  //           mimeType = 'image/png';
  //           break;
  //         case 'gif':
  //           mimeType = 'image/gif';
  //           break;
  //         case 'webp':
  //           mimeType = 'image/webp';
  //           break;
  //         default:
  //           mimeType =
  //               'image/jpeg'; // Default fallback (backend treats unknown as image/jpeg)
  //       }
  //       descs.add(
  //         MultipartFileDesc(bytes: bytes, filename: x.name, mimeType: mimeType),
  //       );
  //     }
  //     final urls = await _api.uploadImages(descs, t);
  //     // Filter out empty URLs before adding to form
  //     final validUrls = urls.where((url) => url.isNotEmpty).toList();
  //     _formImageUrls = [..._formImageUrls, ...validUrls];
  //     _selectedImageFiles = []; // Clear previews after successful upload
  //     _error = null;
  //   } on ApiException catch (e) {
  //     _error = e.message;
  //   } catch (e) {
  //     _error = e.toString();
  //   }
  //   _isUploading = false;
  //   notifyListeners();
  // }

  Future<void> saveProduct() async {
    final t = _getToken();
    if (t == null || t.isEmpty) {
      _error = 'Not logged in';
      notifyListeners();
      return;
    }
    final name = _formName.trim();
    final desc = _formDescription.trim();
    if (name.isEmpty) {
      _error = 'Name is required';
      notifyListeners();
      return;
    }
    if (desc.isEmpty) {
      _error = 'Description is required';
      notifyListeners();
      return;
    }
    if (_formCategoryId == null || _formCategoryId!.isEmpty) {
      _error = 'Collection / Category is required';
      notifyListeners();
      return;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    // Upload pending variant images before saving
    final pendingIndices = _selectedVariantImageFiles.keys.toList();
    for (final idx in pendingIndices) {
      if ((_selectedVariantImageFiles[idx] ?? []).isNotEmpty) {
        await uploadVariantImages(idx);
        if (_error != null) {
          // Upload failed, stop saving
          _isSaving = false;
          notifyListeners();
          return;
        }
      }
    }

    try {
      ProductModel? createdProduct;

      // Find the first variant that has images to use as the main product images
      List<String> mainImages = [];
      for (final v in _formVariants) {
        if (v['images'] != null && (v['images'] as List).isNotEmpty) {
          mainImages = List<String>.from(v['images']);
          break;
        }
      }

      // Prepare variants payload for synchronization (FLATTENED structure)
      final List<Map<String, dynamic>> flatVariants = [];
      for (final v in _formVariants) {
        final List sizes = v['sizes'] ?? [];
        for (int i = 0; i < sizes.length; i++) {
          final s = sizes[i];
          final smap = Map<String, dynamic>.from(s);

          // Basic fields from parent or variant header
          final color = v['color']?.toString() ?? 'Default';
          final size = smap['size']?.toString() ?? 'Free Size';

          final variantPayload = <String, dynamic>{
            'name': smap['name'] != null && smap['name'].toString().isNotEmpty
                ? smap['name']
                : '',
            'color': color,
            'size': size,
            'stock': (smap['stock'] as num?)?.toInt() ?? 0,
            // Use variant's own price if explicitly set; only default to _formPrice when null
            'price': smap.containsKey('price') && smap['price'] != null
                ? (smap['price'] as num).toDouble()
                : _formPrice,
            'shopPrice': (smap['shopPrice'] as num?)?.toDouble() ?? 0.0,
            'websiteCommission':
                (smap['websiteCommission'] as num?)?.toDouble() ?? 0.0,
            'isAvailable': smap['isAvailable'] ?? true,
            'isActive': smap['isActive'] ?? true,
          };

          // IDs if editing
          if (smap['id'] != null) variantPayload['id'] = smap['id'];
          if (v['id'] != null) variantPayload['parentId'] = v['id'];

          // Rule: Only the first variant of a color needs images
          if (i == 0 &&
              v['images'] != null &&
              (v['images'] as List).isNotEmpty) {
            variantPayload['images'] = v['images'];
          }

          flatVariants.add(variantPayload);
        }
      }

      final variantsPayload = flatVariants.isEmpty ? null : flatVariants;

      if (_editingId != null) {
        createdProduct = await _api.updateProduct(
          _editingId!,
          {
            'name': name,
            'description': desc,
            'images': mainImages,
            'price': _formPrice,
            'shopPrice': _formShopPrice,
            'websiteCommission': _formWebsiteCommission,
            'isFeatured': _formIsFeatured,
            'isAvailable': _formIsAvailable,
            'isActive': _formIsActive,
            if (_formCategoryId != null && _formCategoryId!.isNotEmpty)
              'categoryId': _formCategoryId,
            if (variantsPayload != null) 'variants': variantsPayload,
          },
          t,
          method: 'PUT',
        );
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print('✅ PRODUCT UPDATED - API RESPONSE');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print('ID: ${createdProduct.id}');
        print('Name: ${createdProduct.name}');
        print('Full JSON Summary:');
        try {
          print(
            const JsonEncoder.withIndent('  ').convert(createdProduct.toJson()),
          );
        } catch (e) {
          print('Error serializing to JSON: $e');
          print('Product: $createdProduct');
        }
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        _successMessage = 'Product updated';
      } else {
        createdProduct = await _api.createProduct(
          name: name,
          description: desc,
          images: mainImages,
          price: _formPrice,
          shopPrice: _formShopPrice,
          websiteCommission: _formWebsiteCommission,
          categoryId: _formCategoryId,
          variants: variantsPayload,
          token: t,
          isFeatured: _formIsFeatured,
          isAvailable: _formIsAvailable,
          isActive: _formIsActive,
        );
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print('✅ PRODUCT CREATED - API RESPONSE');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print('ID: ${createdProduct.id}');
        print('Name: ${createdProduct.name}');
        print('Description: ${createdProduct.description}');
        print('Price: ₹${createdProduct.price}');
        print('Full JSON Summary:');
        try {
          print(
            const JsonEncoder.withIndent('  ').convert(createdProduct.toJson()),
          );
        } catch (e) {
          print('Error serializing to JSON: $e');
          print('Product: $createdProduct');
        }
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        _successMessage = 'Product created';
      }
      clearProductForm();
      await loadProducts(page: 1);
    } on ApiException catch (e) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ PRODUCT CREATION/UPDATE FAILED - API ERROR');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Error: ${e.message}');
      print('Status Code: ${e.statusCode}');
      print('Code: ${e.code}');
      if (e.details != null) {
        print('Details: ${e.details}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _error = e.message;
    } catch (e) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ PRODUCT CREATION/UPDATE FAILED - UNEXPECTED ERROR');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Error: $e');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _error = e.toString();
    }
    _isSaving = false;
    notifyListeners();
  }

  void requestDelete(ProductModel p) {
    _pendingDelete = p;
    notifyListeners();
  }

  void clearPendingDelete() {
    _pendingDelete = null;
    notifyListeners();
  }

  Future<void> confirmDelete() async {
    final p = _pendingDelete;
    if (p == null) return;
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _pendingDelete = null;
    notifyListeners();
    try {
      final res = await _api.deleteProduct(p.id, t);
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🗑️ PRODUCT DELETED - API RESPONSE');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('ID: ${p.id}');
      print('Name: ${p.name}');
      print('Full JSON Response:');
      try {
        print(const JsonEncoder.withIndent('  ').convert(res));
      } catch (e) {
        print(res);
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _successMessage = 'Product deleted';
      await loadProducts(page: _page);
    } on ApiException catch (e) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('❌ PRODUCT DELETION FAILED - API ERROR');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Error: ${e.message}');
      print('Status Code: ${e.statusCode}');
      if (e.details != null) {
        print('Details: ${e.details}');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }
}
