import 'package:flutter/material.dart';
import '../constants/constants.dart';

class IconActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool isCircular;

  const IconActionButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.color,
    this.size,
    this.padding = const EdgeInsets.all(kGap),
    this.backgroundColor,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? secondaryIcon(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(kGap),
        ),
        child: Icon(icon, color: color, size: resolvedSize),
      ),
    );
  }
}
