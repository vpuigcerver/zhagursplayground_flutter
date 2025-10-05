import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';

enum ActionType { attack, spell, djinn, item, defend, run }

class PlannedAction {
  final Character actor;        // quien realiza la acción
  final ActionType type;
  final Character? target;      // puede ser null (ej: defender)
  final Spell? spell;           // opcional
  final Item? item;             // opcional
  final String? extra;          // cualquier dato extra (p. ej. djinn id)

  PlannedAction({
    required this.actor,
    required this.type,
    this.target,
    this.spell,
    this.item,
    this.extra,
  });
}
