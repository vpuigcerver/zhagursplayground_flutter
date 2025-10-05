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
  bool isDefending;

  Character({
    required this.name,
    required this.maxHp,
    required this.hp,
    required this.maxMp,
    required this.mp,
    required this.agility,
    required this.spells,
    required this.items,
    required this.isDefending
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
