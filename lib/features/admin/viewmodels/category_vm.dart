// Category ViewModel for admin category management

import 'package:flutter/material.dart';
import 'package:e/core/api/api_exception.dart';
import '../models/category_model.dart';
import '../services/admin_api.dart';

class CategoryViewModel extends ChangeNotifier {
  CategoryViewModel({
    required AdminApi api,
    required String? Function() getToken,
  }) : _api = api,
       _getToken = getToken;

  final AdminApi _api;
  final String? Function() _getToken;

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  CategoryModel? _pendingDelete;

  // Form
  String _formName = '';
  String? _editingId;
  bool _isSaving = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  CategoryModel? get pendingDelete => _pendingDelete;
  String get formName => _formName;
  String? get editingId => _editingId;
  bool get isSaving => _isSaving;

  Future<void> loadCategories() async {
    final t = _getToken();
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _api.listCategories(token: t);
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void loadCategoryForEdit(CategoryModel category) {
    _editingId = category.id;
    _formName = category.name;
    _error = null;
    notifyListeners();
  }

  void clearCategoryForm() {
    _editingId = null;
    _formName = '';
    _error = null;
    notifyListeners();
  }

  void updateFormName(String v) {
    _formName = v;
    notifyListeners();
  }

  Future<void> saveCategory() async {
    final t = _getToken();
    if (t == null || t.isEmpty) {
      _error = 'Not logged in';
      notifyListeners();
      return;
    }
    final name = _formName.trim();
    if (name.isEmpty) {
      _error = 'Category name is required';
      notifyListeners();
      return;
    }
    if (name.length > 100) {
      _error = 'Category name must be 1-100 characters';
      notifyListeners();
      return;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      if (_editingId != null) {
        await _api.updateCategory(
          categoryId: _editingId!,
          name: name,
          token: t,
        );
        _successMessage = 'Category updated successfully';
      } else {
        await _api.createCategory(name: name, token: t);
        _successMessage = 'Category created successfully';
      }
      await loadCategories();
      clearCategoryForm();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isSaving = false;
    notifyListeners();
  }

  void requestDelete(CategoryModel category) {
    _pendingDelete = category;
    notifyListeners();
  }

  void clearPendingDelete() {
    _pendingDelete = null;
    notifyListeners();
  }

  Future<void> confirmDelete() async {
    final category = _pendingDelete;
    if (category == null) return;

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
      await _api.deleteCategory(category.id, t);
      _successMessage = 'Category deleted successfully';
      await loadCategories();
      _pendingDelete = null;
    } on ApiException catch (e) {
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
