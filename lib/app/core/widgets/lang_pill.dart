import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class LangPill extends StatelessWidget {
  final String langCode;
  final VoidCallback onToggle;
  final bool onDark;

  const LangPill({
    super.key,
    required this.langCode,
    required this.onToggle,
    this.onDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: onDark
            ? Colors.white.withValues(alpha: 0.16)
            : Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn('EN', 'en'),
          _btn('বাং', 'bn'),
        ],
      ),
    );
  }

  Widget _btn(String label, String code) {
    final isOn = langCode == code;
    return GestureDetector(
      onTap: isOn ? null : onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOn ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isOn
                ? AppColors.blueInk
                : (onDark
                    ? Colors.white.withValues(alpha: 0.78)
                    : AppColors.text3Light),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
