import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class CylBadge extends StatelessWidget {
  final String shortCode;
  final Color color1;
  final Color color2;
  final double size;

  const CylBadge({
    super.key,
    required this.shortCode,
    required this.color1,
    required this.color2,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
        borderRadius: BorderRadius.circular(size * 0.28), 
        boxShadow: const [
          BoxShadow(
            color: AppColors.black18,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        shortCode,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.32,
        ),
      ),
    );
  }
}
