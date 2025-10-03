import 'package:flutter/material.dart';
import '../models/battle_state.dart';
import '../models/item.dart';

class BattleMenu extends StatelessWidget {
  final BattleState state;
  final List<Item> items;
  final bool summonAvailable;
  final VoidCallback? onAttack;
  final VoidCallback? onPsynergy;
  final VoidCallback? onSummon;
  final VoidCallback? onItem;
  final VoidCallback? onRun;

  const BattleMenu({
    super.key,
    required this.state,
    required this.items,
    required this.summonAvailable,
    required this.onAttack,
    required this.onPsynergy,
    required this.onSummon,
    required this.onItem,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    if (state == BattleState.victory) {
      return const Center(
        child: Text("¡Victoria!", style: TextStyle(color: Colors.green, fontSize: 24)),
      );
    } else if (state == BattleState.defeat) {
      return const Center(
        child: Text("Has sido derrotado...", style: TextStyle(color: Colors.red, fontSize: 24)),
      );
    } else if (state == BattleState.enemyTurn) {
      return const Center(
        child: Text("Turno del enemigo...", style: TextStyle(color: Colors.white)),
      );
    }

    // Menú del jugador
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tu turno", style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: onAttack, child: const Text("Atacar")),
            ElevatedButton(onPressed: onPsynergy, child: const Text("Psinergia")),
            ElevatedButton(onPressed: summonAvailable ? onSummon : null, child: const Text("Invocación")),
            ElevatedButton(onPressed: items.isNotEmpty ? onItem : null, child: const Text("Objeto")),
            ElevatedButton(onPressed: onRun, child: const Text("Huir")),
          ],
        ),
      ],
    );
  }
}