import 'package:flutter/material.dart';
import '/core/constants/constants.dart';
import 'theme.dart';

TextStyle headlineLargeStyle(BuildContext context) => TextStyle(
  fontSize: mobileHeight(context) * 0.14,
  fontWeight: FontWeight.w700,
  color: primaryText(context),
  shadows: kShadow,
);

TextStyle headlineMediumStyle(BuildContext context) => TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: primaryText(context),
);

TextStyle headlineSmallStyle(BuildContext context) => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: primaryText(context),
);

TextStyle titleMediumStyle(BuildContext context) => TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: primaryText(context),
);

TextStyle titleLargeStyle(BuildContext context) => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: getSecondaryColor(context),
);

TextStyle titleSmallStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: primaryText(context),
);

TextStyle bodyLargeStyle(BuildContext context) => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: primaryText(context),
);

TextStyle bodyMediumStyle(BuildContext context) => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: primaryText(context),
);

TextStyle bodySmallStyle(BuildContext context) => TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: primaryText(context),
);
final List<Shadow> kShadow = [
  Shadow(
    offset: Offset(3, 3),
    blurRadius: 4,
    color: kBlack.withValues(alpha: 0.7),
  ),
];
