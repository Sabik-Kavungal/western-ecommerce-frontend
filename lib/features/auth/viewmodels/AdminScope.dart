import 'package:flutter/material.dart';

class AdminScope extends ChangeNotifier {
  bool enabled = false;

  void enable() {
    if (!enabled) {
      enabled = true;
      notifyListeners();
    }
  }

  void disable() {
    if (enabled) {
      enabled = false;
      notifyListeners();
    }
  }
}
