import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class QuickAction extends StatelessWidget {
  final IconData icon;
  final Color tintColor;
  final Color bgColor;
  final String label;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.tintColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: tintColor, size: 23),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.text2Light,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
