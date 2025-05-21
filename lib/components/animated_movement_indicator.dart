import 'package:flutter/material.dart';

class AnimatedMovementIndicator extends StatefulWidget {
  final bool isIncome;
  final double size;

  const AnimatedMovementIndicator({
    super.key,
    required this.isIncome,
    this.size = 24.0,
  });

  @override
  State<AnimatedMovementIndicator> createState() =>
      _AnimatedMovementIndicatorState();
}

class _AnimatedMovementIndicatorState extends State<AnimatedMovementIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        widget.isIncome ? Colors.green.shade500 : Colors.red.shade500;

    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: baseColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(0.5),
              blurRadius: widget.size * 0.4,
              spreadRadius: widget.size * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
