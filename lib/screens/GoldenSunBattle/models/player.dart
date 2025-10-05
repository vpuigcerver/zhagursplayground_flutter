import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/djinn.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';

class Player extends Character {
  final List<Djinn> djinns;

  Player({
    required super.name,
    required super.maxHp,
    required super.maxMp,
    required super.agility,
    required super.spells,
    required super.items,
    required this.djinns,
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
