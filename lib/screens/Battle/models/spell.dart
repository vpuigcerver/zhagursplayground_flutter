import 'package:flutter/material.dart';

class Spell {
  final String name;
  final int cost;
  final int damage;
  final IconData? icon;
  final String description;

  const Spell({
    required this.name,
    required this.cost,
    required this.damage,
    required this.icon,
    required this.description,
  });
}

enum Spells {
  fuego(
    Spell(
      name: "Fuego",
      cost: 10,
      damage: 30,
      icon: Icons.local_fire_department,
      description: "Un ataque de fuego moderado.",
    ),
  ),
  tormenta(
    Spell(
      name: "Tormenta",
      cost: 15,
      damage: 40,
      icon: Icons.cloud,
      description: "Invoca una tormenta poderosa.",
    ),
  ),
  rayo(
    Spell(
      name: "Rayo",
      cost: 20,
      damage: 50,
      icon: Icons.bolt,
      description: "Un rayo que inflige gran daño.",
    ),
  ),
  garra(
    Spell(name: "Garra", cost: 0, damage: 15, icon: null, description: "")
  ),
  acido(
    Spell(name: "Fuego", cost: 10, damage: 25, icon: null, description: ""),
  ),
  explosion(
    Spell(name: "Explosión", cost: 15, damage: 35, icon: null, description: ""),
  );

  //
  final Spell spell;

  /// Constructor
  const Spells(this.spell);
}
