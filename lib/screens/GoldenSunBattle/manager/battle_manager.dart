import 'package:zhagurplayground/screens/GoldenSunBattle/models/enemy.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/planned_action.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/player.dart';

class BattleManager {
  List<Player> players;
  List<Enemy> enemies;
  List<PlannedAction> plannedActions = [];

  BattleManager({required this.players, required this.enemies});

  bool get isBattleOver =>
      players.every((p) => !p.isAlive) || enemies.every((e) => !e.isAlive);

  void addPlayerAction(PlannedAction action) {
    plannedActions.add(action);
  }

  void removeLastPlayerAction() {
  if (plannedActions.isNotEmpty) {
    plannedActions.removeLast();
  }
}

  /// ¿Han planeado todos los jugadores vivos?
  bool get allPlayersPlanned {
    final alivePlayers = players.where((p) => p.isAlive).length;
    final playerActions = plannedActions.where((a) => a.actor is Player).length;
    return playerActions >= alivePlayers;
  }

  void enemyDecideActions() {
    //IA enemy
    for (var enemy in enemies.where((e) => e.isAlive)) {
      var target = players.firstWhere((p) => p.isAlive);
      plannedActions.add(
        PlannedAction(actor: enemy, type: ActionType.attack, target: target),
      );
    }
  }

  List<PlannedAction> resolveTurnOrder() {
    plannedActions.sort((a, b) => b.actor.agility.compareTo(a.actor.agility));
    return plannedActions;
  }

  void clearActions() {
    plannedActions.clear();
  }

  void _clearDefendStatus(){
    for (var player in players.where((p) => p.isDefending)) {
      print("${player.name} is defending");
      player.isDefending = false;
    }
  }

  Future<void> executePlannedActions({
    Duration perActionDelay = const Duration(milliseconds: 1000),
    void Function(String message)? logCallback,
  }) async {
    final order = resolveTurnOrder();

    for (final action in List<PlannedAction>.from(order)) {
      if (!action.actor.isAlive) {
        // actor muerto antes de actuar -> saltar
        continue;
      }

      switch (action.type) {
        case ActionType.attack:
          if (action.target != null && action.target!.isAlive) {
            // TODO hace daño en funcion del valor del equipo
            final int dmg = (action.actor is Player) ? 20 : 10;

            action.target!.takeDamage(action.target!.isDefending ? (dmg/2).floor() : dmg);
            logCallback?.call(
              "${action.actor.name} ataca a ${action.target!.name} por $dmg",
            );
          }
          break;

        case ActionType.spell:
          if (action.spell != null) {
            // ejemplo: resta mp y aplica daño simple
            final spell = action.spell!;
            if (action.actor.mp >= spell.cost) {
              action.actor.mp -= spell.cost;
              if (action.target != null && action.target!.isAlive) {
                action.target!.takeDamage(spell.damage);
                logCallback?.call(
                  "${action.actor.name} usa ${spell.name} sobre ${action.target!.name}",
                );
              } else {
                logCallback?.call("${action.actor.name} usa ${spell.name}");
              }
            } else {
              logCallback?.call(
                "${action.actor.name} no tiene MP para ${spell.name}",
              );
            }
          }
          break;

        case ActionType.item:
          if (action.item != null && action.target != null) {
            // implementar item.apply(...) según tu modelo
            //action.item!.apply(action.actor, action.target!);
            if (action.actor.name == action.target?.name) {
              logCallback?.call(
                "${action.actor.name} usa ${action.item!.name}",
              );
            } else {
              logCallback?.call(
                "${action.actor.name} usa ${action.item!.name} en ${action.target!.name}",
              );
            }
          }
          break;

        case ActionType.defend:
          action.actor.isDefending = true;
          logCallback?.call("${action.actor.name} se defiende");
          break;

        case ActionType.djinn:
          // lógica de djinn
          logCallback?.call(
            "${action.actor.name} usa DJIN ${action.spell?.name ?? ''}",
          );
          break;

        case ActionType.run:
          // marca huida -> puedes manejarlo fuera
          logCallback?.call("${action.actor.name} huye");
          break;
      }

      // pequeña pausa entre acciones (simula animación)
      await Future.delayed(perActionDelay);
    }

    // limpiar acciones planeadas al final de la ronda
    _clearDefendStatus();
    plannedActions.clear();
  }
}
