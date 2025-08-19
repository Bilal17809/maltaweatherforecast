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

BoxDecoration todayCardDecoration(BuildContext context, bool isToday) {
  final isDark = context.isDark;
  return BoxDecoration(
    boxShadow: isToday && !isDark
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
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    kWhite.withValues(alpha: 0.08),
                    kWhite.withValues(alpha: 0.09),
                  ]
                : [
                    const Color(0xFF075A47),
                    const Color(0xFF029C78),
                    const Color(0xFF013847),
                  ],
          )
        : null,
    borderRadius: BorderRadius.circular(12),
  );
}

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

Color getIconColor(BuildContext context) => context.isDark ? kWhite : kWhite;

LinearGradient kGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: context.isDark
        ? [kWhite.withValues(alpha: 0.08), kWhite.withValues(alpha: 0.06)]
        : [bgDark2, primaryColorLight],
    stops: [0.3, 0.95],
  );
}

BoxDecoration roundedDecorationWithShadow(BuildContext context) {
  final isDark = context.isDark;
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: isDark
        ? kWhite.withValues(alpha: 0.2)
        : primaryColorLight.withValues(alpha: 0.6),
    boxShadow: [
      BoxShadow(
        color: getBgColor(context),
        spreadRadius: 2,
        blurRadius: 6,
        offset: Offset(4, 4),
      ),
    ],
  );
}

BoxDecoration bgGradient(BuildContext context) {
  final isDark = context.isDark;
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [kWhite.withValues(alpha: 0.01), darkBgColor]
          : [bgDark2, bgDark, primaryColorLight, secondaryColorLight],
    ),
  );
}

LinearGradient kContainerGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: context.isDark
        ? [kWhite.withValues(alpha: 0.4), kWhite.withValues(alpha: 0.2)]
        : [primaryColorLight, bgDark2],
    stops: [0, 0.95],
  );
}

LinearGradient kSelectedGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: context.isDark
        ? [kWhite.withValues(alpha: 0.04), kWhite.withValues(alpha: 0.05)]
        : [bgDark2, lightBgColor],
    stops: [0, 0.9],
  );
}
