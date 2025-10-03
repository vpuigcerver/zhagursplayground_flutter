import 'package:flutter/material.dart';

class FloatingArrow extends StatefulWidget {
  final Color color;

  const FloatingArrow({super.key, this.color = Colors.yellowAccent});

  @override
  State<FloatingArrow> createState() => _FloatingArrowState();
}

class _FloatingArrowState extends State<FloatingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Icon(Icons.arrow_drop_down, size: 40, color: widget.color),
        );
      },
    );
  }
}