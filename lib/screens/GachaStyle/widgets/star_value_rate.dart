
import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GachaStyle/widgets/star_with_particles.dart';

class StarValueRate extends StatefulWidget {
  const StarValueRate({
    required this.starValue,
    required this.style,
    required this.animate,
    super.key,
  });

  final int starValue;
  final StarStyles style;
  final bool animate;

  static const _colour = {
    2: Color.fromARGB(255, 192, 181, 171),
    3: Color.fromARGB(255, 168, 103, 39),
    4: Color.fromARGB(255, 144, 150, 156),
    5: Color.fromARGB(255, 224, 219, 73),
  };

  @override
  State<StarValueRate> createState() => _StarValueRateState();
}

class _StarValueRateState extends State<StarValueRate>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controllers = List.generate(widget.starValue + 2, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      // cada estrella aparece con un pequeño delay escalonado
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) c.forward();
      });

      return c;
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = StarValueRate._colour[widget.starValue + 2] ?? Colors.amber;

    return Column(
      verticalDirection: VerticalDirection.up,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: widget.style.size.spacing,
          runSpacing: 2,
          children: List.generate(widget.starValue + 2, (i) {
            return widget.animate
                ? //Animacion efecto aparece estrella
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _controllers[i],
                      curve: Curves.elasticOut,
                    ),
                    child: Transform.scale(
                      scale: widget.style.size.scale,
                      child: //Animacion fade estrella 
                      FadeTransition(
                        opacity: Tween(begin: 0.5, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controllers[i],
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: StarWithParticles(
                            color: color,
                          ),
                      ),
                    ),
                  )
                : Transform.scale(
                    scale: widget.style.size.scale,
                    child: Icon(Icons.star, color: color),
                  );
          }),
        ),
      ],
    );
  }
}

class DinamicSize {
  final double scale;
  final double spacing;

  DinamicSize({required this.scale, required this.spacing});
}

enum StarStyles { small, medium, big }

extension StarValuesStyle on StarStyles {
  DinamicSize get size {
    switch (this) {
      case StarStyles.small:
        return DinamicSize(scale: 0.5, spacing: -15.0);
      case StarStyles.medium:
        return DinamicSize(scale: 1, spacing: 0.0);
      case StarStyles.big:
        return DinamicSize(scale: 2.5, spacing: 30.0);
    }
  }
}
