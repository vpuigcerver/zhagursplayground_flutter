import 'package:flutter/material.dart';

class BattleEffect extends StatelessWidget {
  final Animation<double> animation;
  final EffectType type;
  final Offset position; // donde se dibuja el efecto en pantalla

  const BattleEffect({
    super.key,
    required this.animation,
    required this.type,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        switch (type) {
          case EffectType.attack:
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: Transform.translate(
                offset: Offset(0, -animation.value),
                child: const Icon(Icons.close, color: Colors.red, size: 40),
              ),
            );
          case EffectType.spell:
            double scale = 1 + animation.value * 2;
            double opacity = 1 - animation.value;
            return Positioned(
              left: position.dx - 50,
              top: position.dy - 50,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: const Icon(Icons.auto_awesome, size: 100, color: Colors.yellowAccent),
                ),
              ),
            );
          case EffectType.heal:
            double scale = 1 + animation.value;
            double opacity = 1 - animation.value;
            return Positioned(
              left: position.dx,
              top: position.dy - 30,
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: const Icon(Icons.healing, size: 50, color: Colors.greenAccent),
                ),
              ),
            );
        }
      },
    );
  }
}

enum EffectType { attack, spell, heal }