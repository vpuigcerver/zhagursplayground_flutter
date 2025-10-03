import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/Battle/models/character.dart';
import 'package:zhagurplayground/screens/Battle/widgets/character_sprite.dart';

class PlayerSprite extends StatelessWidget {
  final Player player;
  final bool selectable;
  final VoidCallback? onTap;

  const PlayerSprite({super.key, required this.player, this.selectable = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CharacterSprite(
      name: player.name,
      hp: player.hp,
      mp: player.mp,
      icon: Icons.person,
      color: Colors.blue,
      selectable: selectable,
      onTap: onTap,
    );
  }
}