import 'package:flutter/material.dart';
import '../constants/constants.dart';
class GlassButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final double width;
  final VoidCallback? onTap;

  const GlassButton({
    super.key,
    this.icon,
    this.text,
    this.width = 30,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 34,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withValues(alpha: 0.6),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: 18)
              : Text(
            text ?? "",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

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
