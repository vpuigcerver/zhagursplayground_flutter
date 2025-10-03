import 'package:shared_preferences/shared_preferences.dart';

class EconomyService {
  static const _coinsKey = 'coins';
  static const _ticketsKey = 'tickets';
  static const _pityKey = 'pityCounter';


  Future<void> saveCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_coinsKey, coins);
  }

  Future<int> loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  Future<void> saveTickets(int tickets) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_ticketsKey, tickets);
  }

  Future<int> loadTickets() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_ticketsKey) ?? 0;
  }

  Future<void> savePityCounter(int pity) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_pityKey, pity);
  }

  Future<int> loadPityCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pityKey) ?? 0;
  }
}