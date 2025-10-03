import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class CollectionProvider extends ChangeNotifier {
  final Set<int> _unlockedIds = {};

  CollectionProvider() {
    _loadData();
  }

  Set<int> get unlockedIds => _unlockedIds;

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('unlockedItems') ?? [];
    _unlockedIds.addAll(ids.map(int.parse));
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'unlockedItems',
      _unlockedIds.map((id) => id.toString()).toList(),
    );
  }

  bool isUnlocked(int id) => _unlockedIds.contains(id);

  void unlockItem(int id) {
    if (_unlockedIds.add(id)) {
      _save();
      notifyListeners();
    }
  }
}
