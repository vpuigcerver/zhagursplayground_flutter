import 'package:flutter/material.dart';

class ButtonRepeat extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonRepeat({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.1),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      onEnd: () {
        // para que haga loop infinito
        Future.delayed(const Duration(milliseconds: 100), () {
          (context as Element).markNeedsBuild();
        });
      },
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.replay),
        label: const Text("Repetir tirada"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}