import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/Battle/widgets/floating_arrow.dart';

class CharacterSprite extends StatelessWidget {
  final String name;
  final int hp;
  final int mp;
  final IconData icon;
  final bool selectable;
  final VoidCallback? onTap;
  final Color color;

  const CharacterSprite({
    super.key,
    required this.name,
    required this.hp,
    required this.mp,
    required this.icon,
    required this.color,
    this.selectable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectable ? onTap : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 120, color: hp > 0 ? color : Colors.grey),
          //if (selectable)
          //  const Positioned(top: -10, child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.yellowAccent)),
          if (selectable)
            const Positioned(
              top: -10,
              child: FloatingArrow(color: Colors.yellowAccent),
            ),
          Positioned(bottom: 0, child: Text("HP: $hp", style: const TextStyle(color: Colors.white))),
          Positioned(bottom: 20, child: Text("MP: $mp", style: const TextStyle(color: Colors.cyanAccent))),
        ],
      ),
    );
  }
}