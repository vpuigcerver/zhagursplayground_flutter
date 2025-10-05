import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';

enum ActionType { attack, spell, djinn, item, defend, run }

class PlannedAction {
  final Character actor;
  final ActionType type; // attack, spell, djinn, item, defend
  final Character? target;
  final Spell? spell;
  final Item? item;

  PlannedAction({
    required this.actor,
    required this.type,
    this.target,
    this.spell,
    this.item,
  });
}
