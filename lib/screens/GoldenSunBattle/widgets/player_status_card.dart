import 'package:flutter/material.dart';

class PlayerStatusCard extends StatelessWidget {
  final String name;
  final int hp;
  final int mp;
  final int maxHp;
  final int maxMp;

  const PlayerStatusCard({
    super.key,
    required this.name,
    required this.hp,
    required this.mp,
    required this.maxHp,
    required this.maxMp,
  });
@override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // 👈 ancho fijo para que todas midan lo mismo
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border.all(color: Colors.yellow.shade700, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text("HP:", style: TextStyle(color: Colors.redAccent)),
              const SizedBox(width: 4),
              Expanded(
                child: LinearProgressIndicator(
                  value: hp / maxHp,
                  color: Colors.redAccent,
                  backgroundColor: Colors.red.withOpacity(0.3),
                ),
              ),
            ],
          ),
          Text(
            "$hp/$maxHp",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text("PP:", style: TextStyle(color: Colors.blueAccent)),
              const SizedBox(width: 4),
              Expanded(
                child: LinearProgressIndicator(
                  value: mp / maxMp,
                  color: Colors.blueAccent,
                  backgroundColor: Colors.blue.withOpacity(0.3),
                ),
              ),
            ],
          ),
          Text(
            "$mp/$maxMp",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}