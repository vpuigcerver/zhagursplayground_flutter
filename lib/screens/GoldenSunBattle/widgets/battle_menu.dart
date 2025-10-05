import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/djinn.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/item.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/spell.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/states/battle_menu_states.dart';

class BattleMenu extends StatelessWidget {
  final BattleMenuState state;
  final VoidCallback onRun;
  final VoidCallback onAttack;
  final VoidCallback onDefend;
  final VoidCallback onBack;

  // Listas dinámicas
  final List<Spell> magics;
  final List<Djinn> djinns;
  final List<Item> items;

  // Callbacks cuando se selecciona un elemento
  final Function(Spell magic)? onMagic;
  final Function(Djinn djinn)? onDjinn;
  final Function(Item item)? onItem;

  const BattleMenu({
    super.key,
    required this.state,
    required this.onRun,
    required this.onAttack,
    required this.onDefend,
    required this.onBack,
    this.magics = const [],
    this.djinns = const [],
    this.items = const [],
    this.onMagic,
    this.onDjinn,
    this.onItem,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BattleMenuState.root:
        return _buildRootMenu();
      case BattleMenuState.fight:
        return _buildFightMenu(context);
      case BattleMenuState.magic:
        return _buildMagicMenu(context);
      case BattleMenuState.djinn:
        return _buildDjinnMenu(context);
      case BattleMenuState.items:
        return _buildItemsMenu(context);
    }
  }

  Widget _buildRootMenu() {
    return _menuContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: onBack, child: const Text("Luchar")),
          ElevatedButton(onPressed: onRun, child: const Text("Huir")),
        ],
      ),
    );
  }

  Widget _buildFightMenu(context) {
    return _menuContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: onAttack, child: const Text("Atacar")),
              ElevatedButton(
                onPressed: () async {
                  final selectedMagic = await _showMagicDialog(context);

                  if (selectedMagic != null) {
                    // Aquí ya tienes la magia seleccionada
                    print("Magia seleccionada: $selectedMagic");

                    // TODO: abrir selección de objetivo
                    // _selectTargetForMagic(selectedMagic);
                  }
                  // Si es null → el usuario canceló, no cambia el estado y sigue en FightMenu
                },
                child: const Text("Magia"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedDjinn = await _showDjinnDialog(context);

                  if (selectedDjinn != null) {
                    // Aquí ya tienes el djinn seleccionado
                    print("Djinn seleccionado: ${selectedDjinn.name}");

                    // TODO: abrir selección de objetivo
                    // _selectTargetForDjinn(selectedDjinn);
                  }
                  // Si es null → el usuario canceló, no cambia el estado y sigue en FightMenu
                },
                child: const Text("Djinn"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedItem = await _showItemDialog(context);

                  if (selectedItem != null) {
                    // Aquí ya tienes el djinn seleccionado
                    print("Item seleccionado: ${selectedItem.name}");

                    // TODO: abrir selección de objetivo
                    // _selectTargetForItem(selectedItem);
                  }
                  // Si es null → el usuario canceló, no cambia el estado y sigue en FightMenu
                },
                child: const Text("Objeto"),
              ),
              ElevatedButton(
                onPressed: onDefend,
                child: const Text("Defender"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onBack,
                child: const Text(
                  "← Atrás",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Spell?> _showMagicDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Selecciona Magia",
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 250, // altura fija para el scroll
            child: ListView.builder(
              itemCount: magics.length,
              itemBuilder: (context, index) {
                final magic = magics[index];
                return Card(
                  color: Colors.grey[800],
                  child: ListTile(
                    title: Text(
                      magic.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context, magic); // cerrar el diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Has elegido ${magic.name}")),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMagicMenu(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final selectedMagic = await _showMagicDialog(context);

          if (selectedMagic != null) {
            // Aquí ya tienes la magia seleccionada
            print("Magia seleccionada: ${selectedMagic.name}");

            // TODO: abrir selección de objetivo
            // _selectTargetForMagic(selectedMagic);
          }
          // Si es null → el usuario canceló, no cambia el estado y sigue en FightMenu
        },
        child: const Text("Magia"),
      ),
    );
  }

  Future<Djinn?> _showDjinnDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Selecciona Djinn",
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 250, // altura fija para el scroll
            child: ListView.builder(
              itemCount: djinns.length,
              itemBuilder: (context, index) {
                final djinn = djinns[index];
                return Card(
                  color: Colors.grey[800],
                  child: ListTile(
                    title: Text(
                      djinn.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context, djinn); // cerrar el diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Has elegido ${djinn.name}")),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDjinnMenu(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final selectedDjinn = await _showDjinnDialog(context);

          if (selectedDjinn != null) {
            // Aquí ya tienes el djinn seleccionado
            print("Djinn seleccionado: ${selectedDjinn.name}");

            // TODO: abrir selección de objetivo
            // _selectTargetForDjinn(selectedDjinn);
          }
          // Si es null → el usuario canceló, no cambia el estado y sigue en FightMenu
        },
        child: const Text("Magia"),
      ),
    );
  }

  Future<Item?> _showItemDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "Selecciona Djinn",
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 250, // altura fija para el scroll
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  color: Colors.grey[800],
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context, item); // cerrar el diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Has elegido ${item.name}")),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemsMenu(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final selectedItem = await _showItemDialog(context);

          if (selectedItem != null) {
            // Aquí ya tienes el djinn seleccionado
            print("Item seleccionado: ${selectedItem.name}");

            // TODO: abrir selección de objetivo
            // _selectTargetForItem(selectedItem);
          }
          // Si es null → el usuario canceló, no cambia el estado y sigue en FightMenu
        },
        child: const Text("Magia"),
      ),
    );
  }

  Widget _menuContainer({required Widget child}) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
