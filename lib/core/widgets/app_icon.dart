import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.color,
    this.size = 22,
    this.strokeWidth = 1.8,
  });

  final List<List<dynamic>> icon;
  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: icon,
      color: color,
      size: size,
      strokeWidth: strokeWidth,
    );
  }
}
