// feature-first: Product data. UI/VM must NOT call services directly; only ViewModel calls this.

import 'package:e/core/api/api_service.dart';
import 'package:e/core/constants/app_constants.dart';

import '../models/product_model.dart';

/// Normalize API images [{"url":"/uploads/x"}] to list of full URLs for ProductModel.
List<String> _normalizeImages(dynamic raw) {
  if (raw == null) return [];
  if (raw is! List || raw.isEmpty) return [];
  final out = <String>[];
  for (final e in raw) {
    String u = '';
    if (e is Map) {
      u = e['url']?.toString() ?? e['image']?.toString() ?? '';
    } else if (e is String) {
      u = e;
    }

    if (u.isNotEmpty) {
      out.add(u.startsWith('http') ? u : '${Constants.apiOrigin}$u');
    }
  }
  return out;
}

Map<String, dynamic> _prepareProductJson(Map<String, dynamic> e) {
  final j = Map<String, dynamic>.from(e);

  // 1. Remap _id to id if needed
  if (j['id'] == null && j['_id'] != null) {
    j['id'] = j['_id'].toString();
  }

  // 2. Ensure required String fields are never null
  j['id'] = j['id']?.toString() ?? '';
  j['name'] = j['name']?.toString() ?? 'Unnamed Product';
  j['description'] = j['description']?.toString() ?? '';

  // 2.5 Normalize hero image
  if (j['image'] != null) {
    String img = '';
    if (j['image'] is Map) {
      img = j['image']['url']?.toString() ?? '';
    } else {
      img = j['image'].toString();
    }
    if (img.isNotEmpty) {
      j['image'] = img.startsWith('http') ? img : '${Constants.apiOrigin}$img';
    }
  }

  // 2.6 Sync Status & Availability
  j['status'] = j['status']?.toString() ?? 'Available';
  j['isAvailable'] = j['isAvailable'] == true;
  j['isActive'] = j['isActive'] ?? true;
  j['isSoldOut'] = j['status'] == 'Sold Out' || j['isSoldOut'] == true;

  // 3. Normalize top-level images
  final imgs = j['images'];
  if (imgs is List) {
    j['images'] = _normalizeImages(imgs);
  }

  // 4. Normalize variants (old recursive or new grouped)
  final variants = j['variants'];
  bool anyAvailable = false;
  bool allSoldOut = true;
  bool hasVariants = false;

  if (variants is List) {
    j['variants'] = variants.map((v) {
      if (v is Map) {
        final vm = Map<String, dynamic>.from(v);
        if (vm.containsKey('sizes')) {
          hasVariants = true;
          // New Grouped Structure (ColorVariant)
          if (vm['image'] != null) {
            String img = (vm['image'] is Map)
                ? (vm['image']['url']?.toString() ?? '')
                : vm['image'].toString();
            if (img.isNotEmpty) {
              vm['image'] = img.startsWith('http')
                  ? img
                  : '${Constants.apiOrigin}$img';
            }
          }
          // Normalize variant images list
          final vImgs = vm['images'];
          if (vImgs is List) {
            vm['images'] = _normalizeImages(vImgs);
          }

          if (vm['sizes'] is List) {
            vm['sizes'] = (vm['sizes'] as List).map((s) {
              if (s is Map) {
                final sc = Map<String, dynamic>.from(s);
                // SizeVariant normalization
                if (sc['id'] == null && sc['_id'] != null)
                  sc['id'] = sc['_id'].toString();
                if (sc['price'] != null)
                  sc['price'] = (sc['price'] as num).toDouble();
                sc['status'] = sc['status']?.toString() ?? 'Available';
                sc['isAvailable'] = sc['isAvailable'] == true;

                // Track availability
                if (sc['isAvailable'] &&
                    sc['isActive'] != false &&
                    sc['status'] == 'Available') {
                  anyAvailable = true;
                }
                if (sc['status'] != 'Sold Out' && (sc['stock'] ?? 0) > 0) {
                  allSoldOut = false;
                }

                return sc;
              }
              return s;
            }).toList();
          }
          return vm;
        } else {
          // Old recursive structure
          return _prepareProductJson(vm);
        }
      }
      return v;
    }).toList();
  }

  // 4.5 Deduce status if API status is default "Available" but no variant is available
  if (hasVariants && j['status'] == 'Available') {
    if (!anyAvailable) {
      j['status'] = 'Disabled';
      j['isAvailable'] = false;
    } else if (allSoldOut) {
      j['status'] = 'Sold Out';
      j['isSoldOut'] = true;
    }
  }

  // 5. Ensure price is double
  if (j['price'] != null) {
    j['price'] = (j['price'] as num).toDouble();
  }

  return j;
}

class ProductApi {
  ProductApi({required ApiService api}) : _api = api;
  final ApiService _api;

  Future<List<ProductModel>> listProducts({
    int page = 1,
    int limit = 20,
    bool? featured,
    bool? available,
    String? color,
    String? search,
    String? categoryId,
  }) async {
    final q = <String>['page=$page', 'limit=$limit'];
    if (featured != null) q.add('featured=$featured');
    if (available != null) q.add('available=$available');
    if (color != null) q.add('color=${Uri.encodeComponent(color)}');
    if (search != null) q.add('search=${Uri.encodeComponent(search)}');
    if (categoryId != null && categoryId.isNotEmpty)
      q.add('categoryId=${Uri.encodeComponent(categoryId)}');

    final res = await _api.request('/products?${q.join('&')}', method: 'GET');
    print('Products loaded: ${res}');

    final data = (res as Map?)?['data'] as Map?;
    final list = (data?['products'] as List?) ?? [];

    return list
        .map(
          (e) => ProductModel.fromJson(
            _prepareProductJson(Map<String, dynamic>.from(e as Map)),
          ),
        )
        .toList();
  }

  /// GET /products/featured. Public.
  Future<List<ProductModel>> listFeatured() async {
    final res = await _api.request('/products/featured', method: 'GET');
    final data = (res as Map?)?['data'] as Map?;
    final list = (data?['products'] as List?) ?? [];
    return list
        .map(
          (e) => ProductModel.fromJson(
            _prepareProductJson(Map<String, dynamic>.from(e as Map)),
          ),
        )
        .toList();
  }

  Future<ProductModel> getProduct(String id) async {
    final res = await _api.request('/products/$id', method: 'GET');
    final data = (res as Map?)?['data'];
    if (data is! Map) throw Exception('No data');
    return ProductModel.fromJson(
      _prepareProductJson(Map<String, dynamic>.from(data)),
    );
  }
}
