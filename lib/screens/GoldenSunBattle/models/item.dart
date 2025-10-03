import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';

enum Item {
  nada(name: "Nada", description: "", icon: null),
  potion(name: "Poción", description: "Recupera 30 HP", icon: Icons.healing),
  ether(name: "Éter", description: "Recupera 20 MP", icon: Icons.auto_fix_high);

  final String name;
  final String description;
  final IconData? icon;

  const Item({
    required this.name,
    required this.description,
    required this.icon,
  });

  void use(Character char) {
    switch (this) {
      case Item.potion:
        char.heal(30);
        break;
      case Item.ether:
        char.restoreMp(20);
        break;
      default:
        break;
    }
  }
}
