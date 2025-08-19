import 'package:flutter/material.dart';

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kGap = 8.0;

/// ========== Border ==========
const double kCircularBorderRadius = 50.0;
const double kBorderRadius = 14.0;

/// ========== Icon Sizes ==========
double primaryIcon(BuildContext context) => mobileWidth(context) * 0.4;
double secondaryIcon(BuildContext context) => mobileWidth(context) * 0.07;
double mediumIcon(BuildContext context) => mobileWidth(context) * 0.19;

/// ========== MediaQuery Helpers ==========
double mobileWidth(BuildContext context) => MediaQuery.of(context).size.width;
double mobileHeight(BuildContext context) => MediaQuery.of(context).size.height;
