import 'package:zhagurplayground/screens/GachaStyle/models/gacha_item.dart';
import 'dart:math' as math;

const probabilidades = {
  0: 6.0,
  1: 2.5,
  2: 1.0,
  3: 0.5
};

final dummyData = [
  GachaItem(
    id: 0,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-00-the-fool.png",
    title: "Tarot 0 el Loco",
    rareza: Rarity.legendary,
    probabilidad: probabilidades[Rarity.legendary.index]!,
  ),
  GachaItem(
    id: 1,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-01-the-magician.png",
    title: "Tarot 1 el Mago",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 2,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-02-the-high-priestess.png",
    title: "Tarot 2 la Sacerdotisa",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 3,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-03-the-empress.png",
    title: "Tarot 3 la Emperatriz",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 4,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-04-the-emperor.png",
    title: "Tarot 4 el Emperador",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 5,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-05-the-hierophant.png",
    title: "Tarot 5 el Hierofante",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 6,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-06-the-lovers.png",
    title: "Tarot 6 los Amantes",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 7,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-07-the-chariot.png",
    title: "Tarot 07 el Carro",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 8,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-08-strength.png",
    title: "Tarot 8 Fuerza",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 9,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-09-the-hermit.png",
    title: "Tarot 9 el Hermitaño",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 10,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/caro-asercion/tarot-10-wheel-of-fortune.png",
    title: "Tarot 10 Rueda de la fortuna",
    rareza: Rarity.epic,
    probabilidad: probabilidades[Rarity.epic.index]!,
  ),
  GachaItem(
    id: 11,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-ace-clubs.png",
    title: "As treboles",
    rareza: Rarity.legendary,
    probabilidad: probabilidades[Rarity.legendary.index]!,
  ),
  GachaItem(
    id: 12,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-ace-diamonds.png",
    title: "As diamantes",
    rareza: Rarity.legendary,
    probabilidad: probabilidades[Rarity.legendary.index]!,
  ),
  GachaItem(
    id: 12,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-ace-hearts.png",
    title: "As corazones",
    rareza: Rarity.legendary,
    probabilidad: probabilidades[Rarity.legendary.index]!,
  ),
  GachaItem(
    id: 13,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-ace-spades.png",
    title: "As espadas",
    rareza: Rarity.legendary,
    probabilidad: probabilidades[Rarity.legendary.index]!,
  ),
  GachaItem(
    id: 14,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-2-clubs.png",
    title: "2 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 15,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-2-diamonds.png",
    title: "2 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 16,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-2-hearts.png",
    title: "2 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 17,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-2-clubs.png",
    title: "2 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //3
    GachaItem(
    id: 18,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-3-clubs.png",
    title: "3 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 19,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-2-diamonds.png",
    title: "3 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 20,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-3-hearts.png",
    title: "3 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 21,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-3-clubs.png",
    title: "3 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //4
    GachaItem(
    id: 22,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-4-clubs.png",
    title: "4 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 23,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-4-diamonds.png",
    title: "4 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 24,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-4-hearts.png",
    title: "4 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 25,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-4-clubs.png",
    title: "4 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //5
    GachaItem(
    id: 26,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-5-clubs.png",
    title: "5 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 27,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-5-diamonds.png",
    title: "5 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 28,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-5-hearts.png",
    title: "5 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 29,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-5-clubs.png",
    title: "5 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //6
    GachaItem(
    id: 30,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-6-clubs.png",
    title: "6 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 31,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-6-diamonds.png",
    title: "6 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 32,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-6-hearts.png",
    title: "6 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 33,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-6-clubs.png",
    title: "6 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //7
    GachaItem(
    id: 34,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-7-clubs.png",
    title: "7 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 35,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-7-diamonds.png",
    title: "7 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 36,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-7-hearts.png",
    title: "7 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 37,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-7-clubs.png",
    title: "7 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //8
    GachaItem(
    id: 38,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-8-clubs.png",
    title: "8 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 39,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-8-diamonds.png",
    title: "8 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 40,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-8-hearts.png",
    title: "8 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 41,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-8-clubs.png",
    title: "8 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //9
    GachaItem(
    id: 42,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-9-clubs.png",
    title: "9 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 43,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-9-diamonds.png",
    title: "9 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 44,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-9-hearts.png",
    title: "9 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 45,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-9-clubs.png",
    title: "9 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //10
    GachaItem(
    id: 46,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-10-clubs.png",
    title: "10 treboles",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 47,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-10-diamonds.png",
    title: "10 diamantes",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 48,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-10-hearts.png",
    title: "10 corazones",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  GachaItem(
    id: 49,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-10-clubs.png",
    title: "10 espadas",
    rareza: Rarity.common,
    probabilidad: probabilidades[Rarity.common.index]!,
  ),
  //J
    GachaItem(
    id: 50,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-jack-clubs.png",
    title: "J treboles",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 51,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-jack-diamonds.png",
    title: "J diamantes",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 52,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-jack-hearts.png",
    title: "J corazones",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 53,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-jack-clubs.png",
    title: "J espadas",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  //Q
    GachaItem(
    id: 54,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-queen-clubs.png",
    title: "Q treboles",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 55,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-queen-diamonds.png",
    title: "Q diamantes",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 56,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-queen-hearts.png",
    title: "Q corazones",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 57,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-queen-clubs.png",
    title: "Q espadas",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  //K
    GachaItem(
    id: 58,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-king-clubs.png",
    title: "K treboles",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 59,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-king-diamonds.png",
    title: "K diamantes",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 60,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-king-hearts.png",
    title: "K corazones",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
  GachaItem(
    id: 61,
    unlocked: false,
    imagen:
        "https://game-icons.net/icons/ffffff/000000/1x1/aussiesim/card-king-clubs.png",
    title: "K espadas",
    rareza: Rarity.rare,
    probabilidad: probabilidades[Rarity.rare.index]!,
  ),
];

GachaItem randomGacha = dummyData[math.Random().nextInt(dummyData.length)];
