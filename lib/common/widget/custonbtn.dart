import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;
  final double height;
  final double width;
  final Color gradientStart;
  final Color gradientEnd;

  const CustomButton({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onTap,
    this.height = 100,
    this.width = 100,
    this.gradientStart = Colors.deepPurple,
    this.gradientEnd = Colors.purpleAccent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
