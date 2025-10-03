import 'dart:math';
import 'item.dart';
import 'spell.dart';

abstract class Character {
  String name;
  int maxHp;
  int hp;
  int maxMp;
  int mp;
  int agility;
  List<Spell> spells;
  List<Item> items;

  Character({
    required this.name,
    required this.maxHp,
    required this.hp,
    required this.maxMp,
    required this.mp,
    required this.agility,
    required this.spells,
    required this.items,
  });

  bool get isAlive => hp > 0;

  void takeDamage(int damage) {
    hp -= damage;
    if (hp < 0) hp = 0;
  }

  void heal(int amount) {
    hp += amount;
    if (hp > maxHp) hp = maxHp;
  }

  void restoreMp(int amount) {
    mp += amount;
    if (mp > maxMp) mp = maxMp;
  }

  void useMp(int cost) {
    mp -= cost;
    if (mp < 0) mp = 0;
  }
}

class Player extends Character {
  Player({
    required super.name,
    required super.maxHp,
    required super.maxMp,
    required super.agility,
    required super.spells,
    required super.items,
  }) : super(
          hp: maxHp,
          mp: maxMp,
        );

  void attack(Character target, int damage) {
    target.takeDamage(damage);
  }

  void castSpell(Spell spell, Character target) {
    if (mp >= spell.cost) {
      useMp(spell.cost);
      target.takeDamage(spell.damage);
    }
  }

  void useItem(Item item, Character target) {
    item.use(target);
    items.remove(item);
  }
}

class Enemy extends Character {
  Enemy({
    required super.name,
    required super.maxHp,
    required super.maxMp,
    required super.agility,
    required super.spells,
    required super.items,
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
