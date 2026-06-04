import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class CStatCard extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String num;
  final String label;
  final String? sub;
  final bool isTaka;

  const CStatCard({
    super.key,
    required this.gradient,
    required this.icon,
    required this.num,
    required this.label,
    this.sub,
    this.isTaka = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black18,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Circle
          Positioned(
            right: -22,
            bottom: -22,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.13),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.white, size: 17),
              ),
              const SizedBox(height: 14),
              Text(
                num,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: -0.02,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white.withValues(alpha: 0.95),
                ),
              ),
              if (sub != null)
                Text(
                  sub!,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withValues(alpha: 0.74),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
