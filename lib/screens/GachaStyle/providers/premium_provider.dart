import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumCurrencyProvider extends ChangeNotifier {
  int _gems = 0;

  int get gems => _gems;

  PremiumCurrencyProvider() {
    _loadFromPrefs();
  }

  void addGems(int amount) {
    _gems += amount;
    _save();
    notifyListeners();
  }

  bool spendGems(int amount) {
    if (_gems >= amount) {
      _gems -= amount;
      _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('premiumGems', _gems);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Revisamos si ya fue inicializado
    final initialized = prefs.getBool('premium_initialized') ?? false;

    if (!initialized) {
      // Primera vez → asignamos valores iniciales
      _gems = 10;

      // Guardamos
      await prefs.setInt('premiumGems', _gems);
      await prefs.setBool('premium_initialized', true);
    } else {
      // Ya inicializado → cargamos lo guardado
      _gems = prefs.getInt('premiumGems') ?? 0;
    }
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('premiumGems', _gems);
  }
}
