import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/theme/theme.dart';
import 'buttons.dart';
import '../constants/constants.dart';

class TitleBar extends StatelessWidget {
  final List<Widget>? actions;
  final String? title;
  final String subtitle;
  final bool useBackButton;
  final VoidCallback? onBackTap;

  const TitleBar({
    super.key,
    required this.subtitle,
    this.useBackButton = true,
    this.actions,
    this.onBackTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = title != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            useBackButton
                ? IconActionButton(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 150), () {
                        Get.back();
                      });
                    },
                    icon: Icons.arrow_back_ios_new,
                    color: getIconColor(context),
                    size: secondaryIcon(context) * 0.7,
                  )
                : IconActionButton(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    icon: Icons.menu,
                    color: getIconColor(context),
                    size: secondaryIcon(context),
                  ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (hasTitle)
                          Text(title!, style: titleMediumStyle(context)),
                        Text(
                          subtitle,
                          style: (hasTitle
                              ? bodyLargeStyle(context)
                              : titleMediumStyle(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
