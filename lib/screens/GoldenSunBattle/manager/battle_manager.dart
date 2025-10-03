

import 'package:zhagurplayground/screens/GoldenSunBattle/models/enemy.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/planned_action.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/player.dart';

class BattleManager {
  List<Player> players;
  List<Enemy> enemies;
  List<PlannedAction> plannedActions = [];

  BattleManager({
    required this.players,
    required this.enemies,
  });

  bool get isBattleOver =>
      players.every((p) => !p.isAlive) || enemies.every((e) => !e.isAlive);

  void addPlayerAction(PlannedAction action) {
    plannedActions.add(action);
  }

  void enemyDecideActions() {
    for (var enemy in enemies.where((e) => e.isAlive)) {
      var target = players.firstWhere((p) => p.isAlive);
      plannedActions.add(PlannedAction(
        actor: enemy,
        type: ActionType.attack,
        target: target,
      ));
    }
  }

  List<PlannedAction> resolveTurnOrder() {
    plannedActions.sort((a, b) => b.actor.agility.compareTo(a.actor.agility));
    return plannedActions;
  }

  void clearActions() {
    plannedActions.clear();
  }
}