import 'package:flutter/material.dart';
import 'dart:math';


class ParticleEmitter extends StatefulWidget {
  final double size;
  final Color color;
  const ParticleEmitter({super.key, required this.size, required this.color});

  @override
  State<ParticleEmitter> createState() => _ParticleEmitterState();
}

class _ParticleEmitterState extends State<ParticleEmitter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_RadialParticle> _particles;
  final int particleCount = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _particles = List.generate(particleCount, (_) => _RadialParticle(widget.size / 2));
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
          
          size: Size(widget.size+25, widget.size+25),
          painter: _RadialEmitterPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _RadialParticle {
  double angle;
  double radius;
  double speed;
  double size;

  _RadialParticle(double emitterRadius)
      : angle = Random().nextDouble() * 2 * pi,
        radius = emitterRadius,
        speed = 20 + Random().nextDouble() * 40,
        size = 1 + Random().nextDouble() * 2;

  void update() {
    radius += speed * 0.02; // mover hacia afuera
    if (radius > 100) {
      radius = 50 + Random().nextDouble() * 10; // reinicia cerca del borde
      angle = Random().nextDouble() * 2 * pi;
      size = 1 + Random().nextDouble() * 2;
      speed = 20 + Random().nextDouble() * 40;
    }
  }
}

class _RadialEmitterPainter extends CustomPainter {
  final List<_RadialParticle> particles;
  final double progress;
  final Color color;

  _RadialEmitterPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final x = center.dx + p.radius * cos(p.angle);
      final y = center.dy + p.radius * sin(p.angle);
      canvas.drawCircle(Offset(x, y), p.size, paint);
      p.update(); // actualizar posición
    }
  }

  @override
  bool shouldRepaint(covariant _RadialEmitterPainter oldDelegate) => true;

}
