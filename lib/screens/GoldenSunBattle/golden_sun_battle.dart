import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/djinn.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/widgets/battle_menu.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/manager/battle_manager.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/enemy.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/player.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/states/battle_menu_states.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/widgets/player_status_card.dart';

class GoldenSunBattle extends StatefulWidget {
  const GoldenSunBattle({super.key});

  @override
  State<GoldenSunBattle> createState() => _GoldenSunBattleState();
}

class _GoldenSunBattleState extends State<GoldenSunBattle> {
  late BattleManager manager;

  BattleMenuState menuState = BattleMenuState.root;

  late Player currentPlayer;
  @override
  void initState() {
    super.initState();
    manager = BattleManager(
      players: [
        Player(
          name: "Isaac",
          maxHp: 100,
          maxMp: 50,
          agility: 12,
          djinns: [Djinn(name: "Marte")],
          spells: [Spells.tormenta.spell, Spells.fuego.spell],
          items: [Item.potion, Item.ether],
        ),
        Player(
          name: "Garet",
          maxHp: 120,
          maxMp: 30,
          agility: 8,
          djinns: [],
          spells: [Spells.tormenta.spell, Spells.fuego.spell],
          items: [Item.potion, Item.ether],
        ),
      ],
      enemies: [
        Enemy(
          name: "Goblin",
          maxHp: 80,
          maxMp: 20,
          agility: 10,
          spells: [Spells.garra.spell],
          items: [Item.potion, Item.ether],
        ),
        Enemy(
          name: "Mago",
          maxHp: 60,
          maxMp: 40,
          agility: 14,
          spells: [Spells.explosion.spell, Spells.fuego.spell],
          items: [Item.potion, Item.ether],
        ),
      ],
    );

    currentPlayer = manager.players.first;
  }

  int currentPlayerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildPlayerHud(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildEnemies(), _buildPlayers()],
              ),
            ),
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHud() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: manager.players.map((p) {
          return PlayerStatusCard(
            name: p.name,
            hp: p.hp,
            mp: p.mp,
            maxHp: p.maxHp,
            maxMp: p.maxMp,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnemies() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: manager.enemies.map((e) {
        return Text(
          e.name,
          style: const TextStyle(color: Colors.red, fontSize: 20),
        );
      }).toList(),
    );
  }

  Widget _buildPlayers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: manager.players.map((p) {
        return Text(
          p.name,
          style: const TextStyle(color: Colors.blue, fontSize: 20),
        );
      }).toList(),
    );
  }

  Widget _buildMenu() {
    //BattleMenuState currentState = BattleMenuState.root;
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: BattleMenu(
        state: menuState,
        onRun: () {},
        onAttack: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Has elegido atacar")));
          _endTurn();
        },
        onDefend: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Has elegido defenderte")));
          _endTurn();
        },
        onBack: () {
          setState(() {
            if (menuState == BattleMenuState.fight) {
              menuState = BattleMenuState.root;
            } else {
              menuState = BattleMenuState.fight;
            }
          });
        },
        magics: currentPlayer.spells.toList(),
        djinns: currentPlayer.djinns.toList(),
        items: currentPlayer.items.toList(),
        onMagic: (spell) {
            menuState = BattleMenuState.magic;
        },
        onDjinn: (djinn) {
          menuState = BattleMenuState.djinn;
        },
        onItem: (item) {
          menuState = BattleMenuState.items;
        },
      ),
    );
  }

  void _endTurn() {
    setState(() {
      currentPlayerIndex++;
      if (currentPlayerIndex >= manager.players.length) {
        currentPlayerIndex = 0; // reinicia o luego pasamos a enemigos
      }
    });
  }
}
