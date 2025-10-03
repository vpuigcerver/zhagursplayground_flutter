import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EconomyProvider extends ChangeNotifier {
  int _coins = 0;
  int _tickets = 0;
  int _pityCounter = 0;

  int get coins => _coins;
  int get tickets => _tickets;
  int get pityCounter => _pityCounter;

  int pityThreshold = 50;

  EconomyProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Revisamos si ya fue inicializado
    final initialized = prefs.getBool('economy_initialized') ?? false;

    if (!initialized) {
      // Primera vez → asignamos valores iniciales
      _coins = 1000;
      _tickets = 0;

      // Guardamos
      await prefs.setInt('coins', _coins);
      await prefs.setInt('tickets', _tickets);
      await prefs.setBool('economy_initialized', true);
    } else {
      // Ya inicializado → cargamos lo guardado
      _coins = prefs.getInt('coins') ?? 0;
      _tickets = prefs.getInt('tickets') ?? 0;
    }
    _pityCounter = prefs.getInt('pityCounter') ?? 0;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _coins);
    await prefs.setInt('tickets', _tickets);
    await prefs.setInt('pityCounter', _pityCounter);
  }

  void addCoins(int amount) {
    _coins += amount;
    _save();
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  bool spendTickets(int amount) {
    if (_tickets >= amount) {
      _tickets -= amount;
      _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  void addTickets(int amount) {
    _tickets += amount;
    _save();
    notifyListeners();
  }

  void incrementPity() {
    _pityCounter++;
    _save();
    notifyListeners();
  }

  void resetPity() {
    _pityCounter = 0;
    _save();
    notifyListeners();
  }

  bool reachedPity() => _pityCounter >= pityThreshold;
}
