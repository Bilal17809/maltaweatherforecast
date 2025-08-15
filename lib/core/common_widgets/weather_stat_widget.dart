import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../theme/theme.dart';

class WeatherStat extends StatelessWidget {
  final String iconPath;
  final String value;
  final String label;

  const WeatherStat({
    super.key,
    required this.iconPath,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: mediumIcon(context),
          child: Image.asset(iconPath, fit: BoxFit.contain),
        ),
        Text(
          value,
          style: titleSmallStyle(context).copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: bodyMediumStyle(context)),
      ],
    );
  }
}
