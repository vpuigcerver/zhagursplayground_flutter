import 'dart:math';
import 'package:flutter/material.dart';

class StarWithParticles extends StatefulWidget {

  final Color color;

  const StarWithParticles({super.key, required this.color});

  @override
  State<StarWithParticles> createState() => _StarWithParticlesState();
}

class _StarWithParticlesState extends State<StarWithParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _particles = List.generate(20, (_) => _Particle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Curves.elasticOut,
            ),
            child: Icon(Icons.star, color: widget.color),
          ),
        );
      },
    );
  }
}

class _Particle {
  final double dx;
  final double dy;
  final double radius;
  final double speed;

  _Particle()
    : dx = cos(Random().nextDouble() * 2 * pi),
      dy = sin(Random().nextDouble() * 2 * pi),
      radius = 2 + Random().nextDouble() * 3,
      speed = 20 + Random().nextDouble() * 40;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 1 - progress)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final offset = Offset(
        center.dx + p.dx * p.speed * progress,
        center.dy + p.dy * p.speed * progress,
      );
      canvas.drawCircle(offset, p.radius * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
