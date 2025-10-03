import 'package:flutter/material.dart';

import 'package:zhagurplayground/screens/GachaStyle/models/gacha_item.dart';

const rarityBorderColors = {
  Rarity.common: Colors.grey,
  Rarity.rare: Colors.blueAccent,
  Rarity.epic: Colors.purpleAccent,
  Rarity.legendary: Colors.amber,
};

// Probabilidades totales por rareza (suma = 100%)
const Map<Rarity, double> probRaridad = {
  Rarity.legendary: 1.0,
  Rarity.epic: 10.0,
  Rarity.rare: 20.0,
  Rarity.common: 69.0,
};
