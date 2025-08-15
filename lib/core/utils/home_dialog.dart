import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/constants.dart';
import '/core/theme/theme.dart';

class HomeDialogs {
  static Future<bool?> showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: getBgColor(context),
          elevation: 4,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: roundedDecor(context),
                child: Padding(
                  padding: const EdgeInsets.all(kElementGap),
                  child: Icon(Icons.question_mark, color: kWhite),
                ),
              ),
              const Gap(kGap),
              Text('Exit App', style: TextStyle(color: secondaryText(context))),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Do you really want to exit the app?',
                style: TextStyle(color: secondaryText(context)),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: roundedInnerDecor(context).copyWith(
                      borderRadius: BorderRadius.circular(kGap),
                      color: getSecondaryColor(context),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: primaryText(context)),
                      ),
                    ),
                  ),
                ),
                const Gap(kGap),
                Expanded(
                  child: Container(
                    decoration: roundedInnerDecor(context).copyWith(
                      borderRadius: BorderRadius.circular(kGap),
                      color: getSecondaryColor(context),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Exit',
                        style: TextStyle(color: primaryText(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
