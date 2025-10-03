import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/Battle/models/character.dart';
import 'package:zhagurplayground/screens/Battle/widgets/character_sprite.dart';

class EnemySprite extends StatelessWidget {
  final Enemy enemy;
  final bool selectable;
  final VoidCallback? onTap;

  const EnemySprite({super.key, required this.enemy, this.selectable = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CharacterSprite(
      name: enemy.name,
      hp: enemy.hp,
      mp: enemy.mp,
      icon: Icons.shield,
      color: Colors.red,
      selectable: selectable,
      onTap: onTap,
    );
  }
}