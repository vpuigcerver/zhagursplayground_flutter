import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/states/battle_menu_states.dart';

class BattleMenu extends StatelessWidget {
  final BattleMenuState state;
  final VoidCallback onRun;
  final VoidCallback onAttack;
  final VoidCallback onDefend;
  final VoidCallback onBack;

  // Listas dinámicas
  final List<String> magics;
  final List<String> djinns;
  final List<String> items;

  // Callbacks cuando se selecciona un elemento
  final Function(String magic)? onMagic;
  final Function(String djinn)? onDjinn;
  final Function(String item)? onItem;

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
        return _buildFightMenu();
      case BattleMenuState.magic:
        return _buildMagicMenu();
      case BattleMenuState.djinn:
        return _buildDjinnMenu();
      case BattleMenuState.items:
        return _buildItemsMenu();
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

  Widget _buildFightMenu() {
    return _menuContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: onAttack, child: const Text("Atacar")),
              ElevatedButton(
                onPressed: () =>
                   _buildMagicMenu(), // Para ir a magia, se usará el state desde el padre
                child: const Text("Magia"),
              ),
              ElevatedButton(
                onPressed: () => onBack(),
                child: const Text("Djinn"),
              ),
              ElevatedButton(
                onPressed: () => onBack(),
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

  Widget _buildMagicMenu() {
    print("magia");
  return Container(
    color: Colors.grey[900],
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const Text(
          "Magias:",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 8),
        // Expanded para que el ListView ocupe el espacio disponible
        Expanded(
          child: ListView.builder(
            itemCount: magics.length,
            itemBuilder: (context, index) {
              final magic = magics[index];
              return Card(
                color: Colors.grey[800],
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    magic,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => onMagic?.call(magic),
                ),
              );
            },
          ),
        ),
        TextButton(
          onPressed: onBack,
          child: const Text("← Atrás", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

  Widget _buildDjinnMenu() {
    return _menuContainer(
      child: Column(
        children: [
          const Text("Djinn:", style: TextStyle(color: Colors.white)),
          ...djinns.map(
            (d) => ElevatedButton(
              onPressed: () => onDjinn?.call(d),
              child: Text(d),
            ),
          ),
          TextButton(
            onPressed: onBack,
            child: const Text("← Atrás", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsMenu() {
    return _menuContainer(
      child: Column(
        children: [
          const Text("Objetos:", style: TextStyle(color: Colors.white)),
          ...items.map(
            (i) => ElevatedButton(
              onPressed: () => onItem?.call(i),
              child: Text(i),
            ),
          ),
          TextButton(
            onPressed: onBack,
            child: const Text("← Atrás", style: TextStyle(color: Colors.white)),
          ),
        ],
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
