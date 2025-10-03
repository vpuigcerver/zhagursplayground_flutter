import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/Battle/models/battle_state.dart';
import 'package:zhagurplayground/screens/Battle/models/character.dart';
import 'package:zhagurplayground/screens/Battle/models/item.dart';
import 'package:zhagurplayground/screens/Battle/models/spell.dart';
import 'package:zhagurplayground/screens/Battle/screens/battle_menu.dart';
import 'package:zhagurplayground/screens/Battle/screens/items_dialog.dart';
import 'package:zhagurplayground/screens/Battle/screens/spell_dialog.dart';
import 'package:zhagurplayground/screens/Battle/widgets/enemy_sprite.dart';
import 'package:zhagurplayground/screens/Battle/widgets/player_sprite.dart';
import 'dart:async';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with TickerProviderStateMixin {
  late List<Player> players;
  late List<Enemy> enemies;

  BattleState state = BattleState.playerTurn;
  bool summonAvailable = true;
  Player? currentActingPlayer;
  Function(Character target)? pendingAction;
  String battleLog = "¡Comienza el combate!";

  // Animaciones
  late AnimationController _attackController;
  late Animation<double> _attackAnimation;
  late AnimationController _spellEffectController;

  // Control de flujo de turnos
  List<Character> _turnOrder = [];
  Completer<void>? _playerActionCompleter;

  @override
  void initState() {
    super.initState();

    // -------------------
    // Inicialización de jugadores
    // -------------------
    players = [
      Player(
        name: "Isaac",
        maxHp: 100,
        maxMp: 50,
        agility: 12,
        spells: [Spells.tormenta.spell, Spells.fuego.spell],
        items: [Item.potion, Item.ether],
      ),
      Player(
        name: "Garet",
        maxHp: 120,
        maxMp: 30,
        agility: 8,
        spells: [Spells.fuego.spell],
        items: [Item.potion],
      ),
      Player(
        name: "Paras",
        maxHp: 120,
        maxMp: 30,
        agility: 8,
        spells: [Spells.acido.spell],
        items: [Item.potion],
      ),
      Player(
        name: "Fluffy",
        maxHp: 120,
        maxMp: 30,
        agility: 8,
        spells: [],
        items: [Item.potion, Item.potion, Item.potion],
      ),
    ];

    // -------------------
    // Inicialización de enemigos
    // -------------------
    enemies = [
      Enemy(
        name: "Goblin",
        maxHp: 80,
        maxMp: 20,
        agility: 10,
        spells: [Spells.garra.spell],
        items: [],
      ),
      Enemy(
        name: "Mago",
        maxHp: 60,
        maxMp: 40,
        agility: 14,
        spells: [Spells.acido.spell, Spells.explosion.spell],
        items: [Item.potion],
      ),Enemy(
        name: "Goblin",
        maxHp: 80,
        maxMp: 20,
        agility: 10,
        spells: [Spells.garra.spell],
        items: [],
      ),
      Enemy(
        name: "Mago",
        maxHp: 60,
        maxMp: 40,
        agility: 14,
        spells: [Spells.acido.spell, Spells.explosion.spell],
        items: [Item.potion],
      ),
    ];

    // -------------------
    // Animaciones
    // -------------------
    _attackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _attackAnimation = Tween<double>(
      begin: 0,
      end: 40,
    ).animate(_attackController);
    _spellEffectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // -------------------
    // Iniciar turnos
    // -------------------
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTurnOrder();
      _nextTurn();
    });
  }

  @override
  void dispose() {
    _attackController.dispose();
    _spellEffectController.dispose();
    super.dispose();
  }

  // -------------------
  // Inicializa el orden de turnos por agilidad
  // -------------------
  void _initializeTurnOrder() {
    _turnOrder = [
      ...players.where((p) => p.isAlive),
      ...enemies.where((e) => e.isAlive),
    ];
    _turnOrder.sort((a, b) => b.agility.compareTo(a.agility));
  }

  // -------------------
  // Manejo de turnos secuenciales
  // -------------------
  Future<void> _nextTurn() async {
    if (_turnOrder.isEmpty) {
      _initializeTurnOrder();
    }

    if (players.every((p) => !p.isAlive) || enemies.every((e) => !e.isAlive)) {
      return;
    }

    Character current = _turnOrder.removeAt(0);

    if (!current.isAlive) {
      await _nextTurn();
      return;
    }

    if (current is Player) {
      currentActingPlayer = current;
      state = BattleState.playerTurn;
      setState(() {});

      // Esperar a que el jugador seleccione acción y objetivo
      _playerActionCompleter = Completer();
      await _playerActionCompleter!.future;
    } else if (current is Enemy) {
      state = BattleState.enemyTurn;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 800));
      await _enemyAction(current);
    }

    // Revisar fin de batalla
    if (players.every((p) => !p.isAlive)) {
      setState(() => state = BattleState.defeat);
      battleLog = "¡Tu grupo ha caído!";
    } else if (enemies.every((e) => !e.isAlive)) {
      setState(() => state = BattleState.victory);
      battleLog = "¡Todos los enemigos han sido derrotados!";
    } else {
      await _nextTurn();
    }
  }

  // -------------------
  // Animaciones de ataque
  // -------------------
  Future<void> _playAttackAnimation() async {
    await _attackController.forward();
    await _attackController.reverse();
  }

  // -------------------
  // Acción del jugador
  // -------------------
  void _onTargetChosen(Character target) async {
    if (currentActingPlayer != null && pendingAction != null) {
      await pendingAction!(target);
      pendingAction = null;
      currentActingPlayer = null;

      // Completar el flujo de espera
      _playerActionCompleter?.complete();
      _playerActionCompleter = null;
    }
  }

  void _playerAttack(Player player) {
    pendingAction = (target) async {
      await _playAttackAnimation();
      setState(() {
        player.attack(target, 20);
        battleLog = "${player.name} atacó a ${target.name} y causó 20 de daño";
      });
    };
  }

  void _playerPsynergy(Player player, Spell spell) {
    if (player.mp < spell.cost) return;
    pendingAction = (target) async {
      _spellEffectController.forward(from: 0);
      await _playAttackAnimation();
      setState(() {
        player.castSpell(spell, target);
        battleLog =
            "${player.name} lanzó ${spell.name} sobre ${target.name} y causó ${spell.damage} de daño";
      });
    };
  }

  void _playerSummon() {
    if (!summonAvailable || currentActingPlayer == null) return;
    summonAvailable = false;

    pendingAction = (target) async {
      _spellEffectController.forward(from: 0);
      await _playAttackAnimation();
      setState(() {
        target.takeDamage(50);
        battleLog =
            "${currentActingPlayer!.name} invocó y causó 50 de daño a ${target.name}";
      });
    };
  }

  void _useItem(Item item) {
    if (currentActingPlayer == null) return;
    pendingAction = (target) async {
      await _playAttackAnimation();
      setState(() {
        currentActingPlayer!.useItem(item, target);
        battleLog =
            "${currentActingPlayer!.name} usó ${item.name} en ${target.name}";
      });
    };
  }

  void _runAway() {
    setState(() {
      state = BattleState.defeat;
      battleLog = "¡${currentActingPlayer!.name} huyó del combate!";
    });
  }

  // -------------------
  // IA del enemigo
  // -------------------
  Future<void> _enemyAction(Enemy enemy) async {
    Spell chosen = enemy.chooseSpell(players.firstWhere((p) => p.isAlive));
    await _playAttackAnimation();
    setState(() {
      enemy.castSpell(chosen, players.firstWhere((p) => p.isAlive));
      battleLog = "${enemy.name} usó ${chosen.name}";
    });
  }

  // -------------------
  // Selección de objetivo
  // -------------------
  void _selectTarget() {
    if (currentActingPlayer == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text(
          "Elige un objetivo",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...enemies.where((e) => e.isAlive).map((enemy) {
              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  leading: const Icon(Icons.shield, color: Colors.red),
                  title: Text(
                    enemy.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onTargetChosen(enemy);
                  },
                ),
              );
            }).toList(),
            ...players.where((p) => p.isAlive).map((ally) {
              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(
                    ally.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onTargetChosen(ally);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // -------------------
  // UI
  // -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/feria.png", fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 4, child: _buildBattleZone()),
                Container(
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
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[900]!.withOpacity(0.9),
                    child: BattleMenu(
                      state: state,
                      items: currentActingPlayer?.items ?? [],
                      summonAvailable: summonAvailable,
                      onAttack: currentActingPlayer != null
                          ? () {
                              _playerAttack(currentActingPlayer!);
                              _selectTarget();
                            }
                          : null,
                      onPsynergy: currentActingPlayer != null
                          ? _showPsynergyMenu
                          : null,
                      onSummon: currentActingPlayer != null
                          ? () {
                              _playerSummon();
                              _selectTarget();
                            }
                          : null,
                      onItem: currentActingPlayer != null
                          ? _showItemsDialog
                          : null,
                      onRun: currentActingPlayer != null ? _runAway : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleZone() {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Stack(
          children: enemies.asMap().entries.map((entry) {
              int index = entry.key;
              Enemy e = entry.value;
              bool selectable = currentActingPlayer != null && e.isAlive;
              return Positioned(
                top: 60,
                right: 80.0*index,
                child: EnemySprite(
                  enemy: e,
                  selectable: selectable,
                  onTap: selectable ? () => _onTargetChosen(e) : null,
                ),
              );
            }).toList(),
          
        ),
        AnimatedBuilder(
          animation: _spellEffectController,
          builder: (context, child) {
            double scale = 1 + _spellEffectController.value * 2;
            double opacity = 1 - _spellEffectController.value;
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: const Icon(
                  Icons.auto_awesome,
                  size: 100,
                  color: Colors.yellowAccent,
                ),
              ),
            );
          },
        ),
        Stack(
          children: players.asMap().entries.map((entry) {
            int index = entry.key;
            Player p = entry.value;
            bool selectable = currentActingPlayer != null && p.isAlive;
            return Positioned(
              bottom: 60,
              left: 70.0 * index ,
              child: PlayerSprite(
                player: p,
                selectable: selectable,
                onTap: selectable ? () => _onTargetChosen(p) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showPsynergyMenu() {
    if (currentActingPlayer == null) return;
    showDialog(
      context: context,
      builder: (context) => SpellDialog(
        psinergia: currentActingPlayer!.spells,
        playerMp: currentActingPlayer!.mp,
        onCast: (spell) {
          _playerPsynergy(currentActingPlayer!, spell);
          _selectTarget();
        },
      ),
    );
  }

  void _showItemsDialog() {
    if (currentActingPlayer == null) return;
    showDialog(
      context: context,
      builder: (context) => ItemsDialog(
        items: currentActingPlayer!.items,
        onUse: (item) {
          _useItem(item);
          _selectTarget();
        },
      ),
    );
  }
}

  // Widget _buildBattleZone() {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       Positioned(
  //         top: 60,
  //         right: 60,
  //         child: Row(
  //           children: enemies.map((e) {
  //             final selectable = currentActingPlayer != null && e.isAlive;
  //             return EnemySprite(
  //               enemy: e,
  //               selectable: selectable,
  //               onTap: selectable ? () => _onTargetChosen(e) : null,
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //       Positioned(
  //         bottom: 60,
  //         left: 60,
  //         child: Row(
  //           children: players.map((p) {
  //             final selectable = currentActingPlayer != null && p.isAlive;
  //             return PlayerSprite(
  //               player: p,
  //               selectable: selectable,
  //               onTap: selectable ? () => _onTargetChosen(p) : null,
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     ],
  //   );
  // }
