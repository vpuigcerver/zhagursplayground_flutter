
import 'package:zhagurplayground/screens/GachaStyle/utils/utils.dart';
enum Rarity { common, rare, epic, legendary }

class GachaItem {
  GachaItem({
    required this.id,
    required this.unlocked,
    required this.imagen,
    required this.title,
    required this.rareza,
    this.isNew = false,
    this.probabilidad = 0.0,
  });

  final int id;
  final bool unlocked;
  final String imagen;
  final String title;
  final Rarity rareza;
  final bool isNew;
  double probabilidad;

  GachaItem copyWith({
    int? id,
    bool? unlocked,
    String? imagen,
    String? title,
    Rarity? rareza,
    bool? isNew,
    double? probabilidad,
  }) {
    return GachaItem(
      id: id ?? this.id,
      unlocked: unlocked ?? this.unlocked,
      imagen: imagen ?? this.imagen,
      title: title ?? this.title,
      rareza: rareza ?? this.rareza,
      isNew: isNew ?? this.isNew,
      probabilidad: probabilidad ?? this.probabilidad,
    );
  }
}

void asignarProbabilidades(List<GachaItem> items) {
  // Agrupa items por rareza
  Map<Rarity, List<GachaItem>> grouped = {};
  for (var item in items) {
    grouped.putIfAbsent(item.rareza, () => []).add(item);
  }

  // Asigna probabilidad individual
  grouped.forEach((rarity, itemList) {
    double totalProb = probRaridad[rarity] ?? 0.0;
    double probPorItem = totalProb / itemList.length;
    for (var item in itemList) {
      item.probabilidad = probPorItem;
    }
  });
}

