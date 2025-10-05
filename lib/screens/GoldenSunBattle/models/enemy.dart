import 'dart:math';

import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';

class Enemy extends Character {
  Enemy({
    required super.name,
    required super.maxHp,
    required super.maxMp,
    required super.agility,
    required super.spells,
    required super.items,
    super.isDefending= false,
  }) : super(
          hp: maxHp,
          mp: maxMp,
        );

  /// IA simplificada
  Spell chooseSpell(Character target) {
    // Prioriza hechizos fuertes si jugador tiene mucha vida
    List<Spell> usable = spells.where((s) => s.cost <= mp).toList();
    if (target.hp >= target.maxHp * 0.6) {
      Spell? strong = usable.where((s) => s.damage >= 30).isNotEmpty
          ? usable.firstWhere((s) => s.damage >= 30)
          : null;
      if (strong != null) return strong;
    }
    // Si tiene poca vida y poción disponible, curarse
    if (hp <= maxHp * 0.4) {
      Item? potion = items.firstWhere(
          (i) => i.name.toLowerCase().contains("poción"),
          orElse: () => Item.nada);
      if (potion.name != "Nada") {
        potion.use(target);
        items.remove(potion);
        return Spell(name: "Curación", cost: 0, damage: 0, icon: null, description: "");
      }
    }
    // Ataque básico si no puede usar nada
    return usable.isNotEmpty ? usable[Random().nextInt(usable.length)] : Spell(name: "Ataque", cost: 0, damage: 15, icon: null, description: "");
  }

  void attack(Character target, int damage) {
    target.takeDamage(damage);
  }

  void castSpell(Spell spell, Character target) {
    if (spell.name == "Curación") return; // ya se curó en chooseSpell
    useMp(spell.cost);
    target.takeDamage(spell.damage);
  }
}
