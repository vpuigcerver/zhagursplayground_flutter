import 'package:flutter/material.dart';
import '../models/spell.dart';

class SpellDialog extends StatelessWidget {
  final List<Spell> psinergia;
  final int playerMp;
  final Function(Spell) onCast;

  const SpellDialog({
    super.key,
    required this.psinergia,
    required this.playerMp,
    required this.onCast,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[850],
      title: const Text("Psinergia", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: psinergia.map((spell) {
          bool canUse = playerMp >= spell.cost;
          return Card(
            color: canUse ? Colors.grey[800] : Colors.grey[700],
            child: ListTile(
              leading: Icon(spell.icon, color: Colors.orange),
              title: Text(spell.name,
                  style: TextStyle(
                      color: canUse ? Colors.white : Colors.grey, fontSize: 16)),
              subtitle: Text(
                "${spell.description}\nCoste: ${spell.cost} MP - Daño: ${spell.damage}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              onTap: canUse
                  ? () {
                      Navigator.pop(context);
                      onCast(spell);
                    }
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}