// feature-first: Cart ViewModel. Uses CartApi (auth required). Load, add, update, remove, clear.

import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../services/cart_api.dart';
import '../../products/models/product_model.dart';
import '../../auth/viewmodels/auth_vm.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({required CartApi cartApi, required AuthViewModel authVm})
    : _cartApi = cartApi,
      _authVm = authVm;

  final CartApi _cartApi;
  final AuthViewModel _authVm;

  List<CartItemWithId> _items = [];
  double _totalPrice = 0;
  int _itemCount = 0;
  bool _isLoading = false;
  String? _error;

  List<CartItemWithId> get items => List.unmodifiable(_items);
  double get totalPrice => _totalPrice;
  int get itemCount => _itemCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load cart from API. No-op if not logged in. Call from CartPage, HomePage, or after login.
  Future<void> loadCart() async {
    final token = _authVm.token;
    if (token == null || token.isEmpty) {
      _items = [];
      _totalPrice = 0;
      _itemCount = 0;
      _error = null;
      notifyListeners();
      return;
    }
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _cartApi.getCart(token);
      _items = res.items;
      _totalPrice = res.totalPrice;
      _itemCount = res.itemCount;
    } catch (e) {
      _error = e.toString();
      _items = [];
      _totalPrice = 0;
      _itemCount = 0;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Add product to cart via API. Requires login. On success refreshes from API response.
  Future<void> addProduct(
    ProductModel p,
    String size,
    int qty, {
    String? color,
  }) async {
    final token = _authVm.token;
    if (token == null || token.isEmpty) {
      _error = 'Please sign in to add to cart';
      notifyListeners();
      return;
    }
    final stock = _getEffectiveStock(p, size, color);
    final currentInCart = _items
        .where((x) =>
            x.item.product.id == p.id &&
            x.item.selectedSize == size &&
            x.item.selectedColor == color)
        .fold(0, (sum, x) => sum + x.item.quantity);

    if (currentInCart + qty > stock) {
      _error = 'Only $stock items available in stock';
      notifyListeners();
      return;
    }

    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _cartApi.addItem(
        token,
        p.id,
        selectedSize: size,
        selectedColor: color,
        quantity: qty,
      );
      _items = res.items;
      _totalPrice = res.totalPrice;
      _itemCount = res.itemCount;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  void removeFromCartById(String itemId) {
    final token = _authVm.token;
    if (token == null || itemId.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    _cartApi
        .removeItem(token, itemId)
        .then((res) {
          _items = res.items;
          _totalPrice = res.totalPrice;
          _itemCount = res.itemCount;
          _isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          _error = e.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  void updateQuantity(String itemId, int qty) {
    if (itemId.isEmpty) return;

    // 1. Optimistic Update (Immediate UI Feedback)
    final originalItems = List<CartItemWithId>.from(_items);
    final originalTotal = _totalPrice;
    final originalCount = _itemCount;

    if (qty < 1) {
      _items = _items.where((x) => x.id != itemId).toList();
    } else {
      // Check stock for the item
      final cartItemWithId = _items.firstWhere((x) => x.id == itemId);
      final stock = _getEffectiveStock(
        cartItemWithId.item.product,
        cartItemWithId.item.selectedSize,
        cartItemWithId.item.selectedColor,
      );

      if (qty > stock) {
        _error = 'Only $stock items available in stock';
        notifyListeners();
        return;
      }

      _items = _items.map((x) {
        if (x.id == itemId) {
          return CartItemWithId(
            id: x.id,
            item: x.item.copyWith(quantity: qty),
          );
        }
        return x;
      }).toList();
    }

    // Recalculate totals immediately
    _totalPrice = _items.fold(0, (sum, x) => sum + x.item.totalPrice);
    _itemCount = _items.fold(0, (sum, x) => sum + x.item.quantity);
    notifyListeners();

    // 2. Perform Backend Update
    if (qty < 1) {
      removeFromCartById(itemId);
      return;
    }

    final token = _authVm.token;
    if (token == null) {
      // Rollback if no token (shouldn't happen if user is in cart)
      _items = originalItems;
      _totalPrice = originalTotal;
      _itemCount = originalCount;
      notifyListeners();
      return;
    }

    _cartApi.updateItem(token, itemId, qty).then((res) {
      // Sync with server's final state
      _items = res.items;
      _totalPrice = res.totalPrice;
      _itemCount = res.itemCount;
      notifyListeners();
    }).catchError((e) {
      // Rollback on Error
      _error = e.toString();
      _items = originalItems;
      _totalPrice = originalTotal;
      _itemCount = originalCount;
      notifyListeners();
    });
  }

  /// Clear cart via API.
  Future<void> clearCart() async {
    final token = _authVm.token;
    if (token == null) return;
    try {
      await _cartApi.clearCart(token);
      _items = [];
      _totalPrice = 0;
      _itemCount = 0;
    } catch (_) {}
    notifyListeners();
  }

  bool isInCart(String productId, String size, {String? color}) => _items.any(
    (x) =>
        x.item.product.id == productId &&
        x.item.selectedSize == size &&
        x.item.selectedColor == color,
  );

  int _getEffectiveStock(ProductModel p, String size, String? color) {
    if (p.variants == null || p.variants!.isEmpty) {
      return p.quantity ?? 999;
    }

    final variant = p.variants!.firstWhere(
      (v) => v.color.toLowerCase() == color?.toLowerCase(),
      orElse: () => p.variants!.first,
    );

    final sizeVar = variant.sizes.firstWhere(
      (s) => s.size.toLowerCase() == size.toLowerCase(),
      orElse: () => variant.sizes.isNotEmpty
          ? variant.sizes.first
          : const SizeVariant(
            id: '',
            name: '',
            size: '',
            price: 0,
            stock: 0,
            isAvailable: false,
            isActive: false,
          ),
    );

    return sizeVar.stock;
  }
}
