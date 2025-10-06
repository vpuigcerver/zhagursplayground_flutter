import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/models/character.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/states/character_state.dart';

class CharacterSprite extends StatefulWidget {
  final Character character;
  final bool selectable;
  final VoidCallback? onTap;

  const CharacterSprite({
    super.key,
    required this.character,
    this.selectable = false,
    this.onTap,
  });

  @override
  State<CharacterSprite> createState() => _CharacterSpriteState();
}

class _CharacterSpriteState extends State<CharacterSprite>
    with TickerProviderStateMixin {
  late AnimationController _attackController;
  late AnimationController _magicController;
  late AnimationController _hurtController;

  @override
  void initState() {
    super.initState();

    _attackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _magicController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _hurtController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _attackController.dispose();
    _magicController.dispose();
    _hurtController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CharacterSprite oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animaciones según el estado
    switch (widget.character.state) {
      case CharacterState.attack:
        _attackController.forward(from: 0);
        break;
      case CharacterState.cast:
        _magicController.forward(from: 0);
        break;
      case CharacterState.hurt:
        _hurtController.forward(from: 0);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.selectable ? widget.onTap : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sprite base (idle, defend, item)
          //Image.asset("assets/images/battle/characters/players/${widget.character.name}_${widget.character.state.name}.png"),
          Image.asset("assets/images/battle/characters/players/player1_${widget.character.state.name}.png"),
          // Ejemplo de animaciones overlay
          AnimatedBuilder(
            animation: _attackController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_attackController.value * 20, 0),
                child: child,
              );
            },
            child: widget.character.state == CharacterState.attack
                ? const Icon(Icons.flash_on, color: Colors.red, size: 40)
                : null,
          ),
        ],
      ),
    );
  }
}
