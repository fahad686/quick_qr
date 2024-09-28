import 'package:flutter/material.dart';

class AnimatedImage extends StatefulWidget {
  final String imagePath;

  final double size; // Adjust size as needed

  const AnimatedImage({
    super.key,
    required this.imagePath,
    this.size = 100,
  });

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // Infinite loop for continuous rotation

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.6)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _controller.value * 6.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                height: widget.size,
                width: widget.size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
