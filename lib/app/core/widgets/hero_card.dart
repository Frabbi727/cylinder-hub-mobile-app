import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class AppHeroCard extends StatelessWidget {
  final String label;
  final String amount;
  final List<HeroFootItem>? foot;
  final IconData icon;

  const AppHeroCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    this.foot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        gradient: AppColors.homeGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black45, // Approximation of color-mix shadow
            blurRadius: 32,
            offset: Offset(0, 16),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Circle
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.white.withValues(alpha: 0.9)),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: -0.025,
                  height: 1,
                ),
              ),
              if (foot != null && foot!.isNotEmpty) ...[
                const SizedBox(height: 18),
                Row(
                  children: foot!.map((item) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white82,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class HeroFootItem {
  final String label;
  final String value;

  HeroFootItem({required this.label, required this.value});
}
