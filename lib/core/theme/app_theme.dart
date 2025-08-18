import 'package:flutter/material.dart';
import 'theme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: lightBgColor,
    colorScheme: ColorScheme.light(
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      surface: lightBgColor,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: textWhiteColor),
      bodyMedium: TextStyle(color: textWhiteColor),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: darkBgColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      surface: darkBgColor,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: textBlackColor),
      bodyMedium: TextStyle(color: textGreyColor),
    ),
  );
}

//decoration
BoxDecoration roundedDecor(BuildContext context) => BoxDecoration(
  gradient: kContainerGradient(context),
  borderRadius: BorderRadius.circular(24),
  boxShadow: [
    BoxShadow(
      color: kBlack.withValues(alpha: 0.3),
      blurRadius: 6,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ],
);

BoxDecoration todayCardDecoration(bool isToday) => BoxDecoration(
  boxShadow: isToday
      ? [
          BoxShadow(
            color: const Color(0xFF01474E).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ]
      : [],
  gradient: isToday
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF075A47), Color(0xFF029C78), Color(0xFF013847)],
        )
      : null,
  borderRadius: BorderRadius.circular(12),
);

BoxDecoration roundedInnerDecor(BuildContext context) => BoxDecoration(
  color: kWhite.withValues(alpha: 0.5),
  borderRadius: BorderRadius.circular(24),
  boxShadow: [
    BoxShadow(
      color: kBlack.withValues(alpha: 0.3),
      blurRadius: 6,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ],
);

BoxDecoration roundedForecastDecor(BuildContext context) => BoxDecoration(
  color: context.isDark
      ? secondaryColorLight.withValues(alpha: 0.9)
      : kWhite.withValues(alpha: 0.9),
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(100),
    topLeft: Radius.circular(100),
  ),
);

BoxDecoration roundedSelectionDecoration(
  BuildContext context, {
  required bool isSelected,
}) {
  final isDark = context.isDark;

  return BoxDecoration(
    color: isDark
        ? (isSelected
              ? kWhite.withValues(alpha: 0.6)
              : kWhite.withValues(alpha: 0.25))
        : (isSelected ? null : unselectedColor),
    gradient: isDark ? null : (isSelected ? kSelectedGradient(context) : null),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: kBlack.withValues(alpha: 0.3),
        blurRadius: 6,
        spreadRadius: 1,
        offset: Offset(0, 2),
      ),
    ],
  );
}

Color getPrimaryColor(BuildContext context) =>
    context.isDark ? primaryColorDark : primaryColorLight;

Color getSecondaryColor(BuildContext context) => context.isDark
    ? secondaryColorDark.withValues(alpha: 0.1)
    : secondaryColorLight;

Color getSearchBgColor(BuildContext context) => context.isDark
    ? secondaryColorDark.withValues(alpha: 0.1)
    : primaryColorLight;

Color getBgColor(BuildContext context) =>
    context.isDark ? darkBgColor : lightBgColor;

Color secondaryText(BuildContext context) =>
    context.isDark ? textWhiteColor : textBlackColor;

Color primaryText(BuildContext context) =>
    context.isDark ? textWhiteColor : textWhiteColor;

Color coloredText(BuildContext context) =>
    context.isDark ? textWhiteColor : textPrimaryColor;

Color getIconColor(BuildContext context) => context.isDark ? kWhite : kWhite;

LinearGradient kGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: context.isDark
        ? [kWhite.withValues(alpha: 0.08), kWhite.withValues(alpha: 0.06)]
        : [primaryColorLight, secondaryColorLight],
    stops: [0.3, 0.95],
  );
}

final BoxDecoration roundedDecorationWithShadow = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: hourlyRow.withValues(alpha: 0.7),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      spreadRadius: 2,
      blurRadius: 6,
      offset: Offset(4, 4),
    ),
  ],
);

final BoxDecoration bgGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDark2, bgDark, bgPrimary, bgSecondary],
  ),
);

LinearGradient kContainerGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: context.isDark
        ? [kWhite.withValues(alpha: 0.4), kWhite.withValues(alpha: 0.2)]
        : [primaryColorLight, secondaryColorLight],
    stops: [0, 0.95],
  );
}

LinearGradient kSelectedGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: context.isDark
        ? [kWhite.withValues(alpha: 0.04), kWhite.withValues(alpha: 0.05)]
        : [selectedLightColor, selectedDarkColor],
    stops: [0, 0.9],
  );
}
