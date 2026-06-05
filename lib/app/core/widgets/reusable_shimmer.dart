import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReusableShimmer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ReusableShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Default colors for Light and Dark modes if not provided
    final effectiveBase = baseColor ?? 
        (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final effectiveHighlight = highlightColor ?? 
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return Shimmer.fromColors(
      baseColor: effectiveBase,
      highlightColor: effectiveHighlight,
      child: child,
    );
  }
}
