import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/djinn.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/planned_action.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/widgets/battle_menu.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/manager/battle_manager.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/enemy.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/player.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/states/battle_menu_states.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/widgets/character_sprite.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/widgets/player_status_card.dart';

class GoldenSunBattle extends StatefulWidget {
  const GoldenSunBattle({super.key});

  @override
  State<GoldenSunBattle> createState() => _GoldenSunBattleState();
}

class _GoldenSunBattleState extends State<GoldenSunBattle> {
  late BattleManager manager;

  BattleMenuState menuState = BattleMenuState.root;
  int currentPlayerIndex = 0;
  String battleLog = "¡Comienza!";

  Player get currentPlayer => manager.players[currentPlayerIndex];

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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hudHeight = size.height * 0.15;
    final menuHeight = size.height * 0.30;
    final battleLogHeight = 50.0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // --------------------
            // 0️⃣ BACKGROUND
            // --------------------
            Positioned.fill(
              child: Image.asset(
                "assets/images/battle/backgrounds/background_h_forest2.png",
                fit: BoxFit.contain,
                repeat: ImageRepeat.repeatX,
              ),
            ),
            // --------------------
            // 1️⃣ HUD de los jugadores arriba
            // --------------------
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              //height: hudHeight.clamp(80, 200), // mínimo 80px, máximo 200px
              child: _buildPlayerHud(),
            ),

            // --------------------
            // 2️⃣ Zona de combate en el centro
            // --------------------
            Positioned(
              top: hudHeight.clamp(80, 200),
              bottom: menuHeight + battleLogHeight,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_buildEnemies(), _buildPlayers()],
              ),
            ),

            // --------------------
            // 3️⃣ Battle log encima del menú
            // --------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: menuHeight / 2,
              height: battleLogHeight,
              child: manager.allPlayersPlanned
                  ? Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.6),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        battleLog,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontFamily: "monospace",
                        ),
                      ),
                    )
                  : Container(),
            ),

            // 4️⃣ Menú de acciones en la parte inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: menuHeight.clamp(60, 160), // mínimo 60px, máximo 120px
              child: manager.allPlayersPlanned ? Container() : _buildMenu(),
            ),
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
    return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: manager.players.asMap().entries.map((entry) {
      int index = entry.key;
      Player player = entry.value;

      bool selectable = currentPlayer != null && player.isAlive;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CharacterSprite(
          character: player,
          selectable: selectable,
          onTap: selectable
              ? () {
                  //_onTargetChosen(player);
                }
              : null,
        ),
      );
    }).toList(),
    );
  }

  Widget _buildMenu() {
    return Container(
      //color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: BattleMenu(
        state: menuState,
        onRun: () {},
        onAttack: () {
          // por ahora selecciona el primer enemigo TODO _selectTarget();
          final enemyTarget = manager.enemies.firstWhere(
            (e) => e.isAlive,
            orElse: () => manager.enemies.first,
          );
          _onPlayerActionChosen(
            PlannedAction(
              actor: currentPlayer,
              type: ActionType.attack,
              target: enemyTarget,
            ),
          );
        },
        onDefend: () {
          _onPlayerActionChosen(
            PlannedAction(actor: currentPlayer, type: ActionType.defend),
          );
        },
        onBack: () {
          setState(() {
            if (manager.plannedActions.isEmpty) {
              if (menuState == BattleMenuState.fight) {
                battleLog = "¡Comienza!";
                menuState = BattleMenuState.root;
              } else {
                battleLog =
                    "Elige acción: ${manager.players[currentPlayerIndex].name}";
                menuState = BattleMenuState.fight;
              }
            } else {
              _onBackPressed();
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

  void _onBackPressed() {
    setState(() {
      if (manager.plannedActions.isNotEmpty) {
        // eliminar la última acción guardada
        manager.removeLastPlayerAction();

        // retroceder al jugador anterior
        currentPlayerIndex = (currentPlayerIndex - 1);
        if (currentPlayerIndex < 0) {
          currentPlayerIndex = 0; // seguridad
        }

        battleLog = "Elige acción: ${manager.players[currentPlayerIndex].name}";
      } else {
        // si no hay acciones planificadas, volvemos al menú raíz
        battleLog = "¡Comienza!";
        menuState = BattleMenuState.root;
      }
    });
  }

  void _onPlayerActionChosen(PlannedAction action) {
    manager.addPlayerAction(action);
    print("fin del turno de ${currentPlayer.name}");
    _advanceToNextPlayerOrResolve();
  }

  void _advanceToNextPlayerOrResolve() {
    // Avanzar índice al siguiente jugador vivo
    setState(() {
      int next = currentPlayerIndex;
      bool found = false;
      for (int i = 0; i < manager.players.length; i++) {
        next = (currentPlayerIndex + 1 + i) % manager.players.length;
        if (manager.players[next].isAlive) {
          currentPlayerIndex = next;
          found = true;

          battleLog =
              "Elige acción: ${manager.players[currentPlayerIndex].name}";
          break;
        }
      }

      if (!found) {
        // no hay siguiente jugador vivo (poco probable). Reiniciar a 0.
        currentPlayerIndex = 0;
      }
    });

    // Si todos los jugadores han planeado, pedimos acciones a enemigos y resolvemos la ronda.
    if (manager.allPlayersPlanned) {
      print("todos han seleccionado la opcion, turno de los enemigos");
      _resolveRound();
    }
  }

  Future<void> _resolveRound() async {
    manager.enemyDecideActions();

    setState(() => battleLog = "Resolviendo acciones...");
    await manager.executePlannedActions(
      logCallback: (msg) {
        setState(() => battleLog = msg);
      },
      perActionDelay: const Duration(milliseconds: 1000),
    );

    // Ronda terminada -> volver a selección de jugadores (el índice queda en el primer jugador vivo)
    setState(() {
      currentPlayerIndex = manager.players.indexWhere((p) => p.isAlive);
      if (currentPlayerIndex == -1) {
        // todos muertos -> derrota
        battleLog = "Derrota";
      } else {
        battleLog = "Elige acción: ${manager.players[currentPlayerIndex].name}";
      }
    });
  }

  // Ejemplo: si desde el menú eliges "Atacar", abres el target selector y al confirmar llamas:
  void onAttackConfirmed(Character target) {
    final action = PlannedAction(
      actor: currentPlayer,
      type: ActionType.attack,
      target: target,
    );
    _onPlayerActionChosen(action);
  }

  // Si eliges magia:
  void onMagicConfirmed(Spell spell, Character target) {
    final action = PlannedAction(
      actor: currentPlayer,
      type: ActionType.spell,
      spell: spell,
      target: target,
    );
    _onPlayerActionChosen(action);
  }
}
