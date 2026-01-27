import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_sizer/flutter_sizer.dart';

class ConfirmClosePopup extends StatelessWidget {
  const ConfirmClosePopup({super.key});

  /// Static method to show the popup and return the user's choice
  static Future<bool?> show(BuildContext context) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Confirm Exit',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: const PopScope(
            canPop: false,
            child: ConfirmClosePopup(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -50, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: EdgeInsets.all(20.dp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.dp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium Illustration/Icon
            Container(
              height: 80.dp,
              width: 80.dp,
              decoration: BoxDecoration(
                color: Color(0xFF636362),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                size: 30.dp,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20.dp),

            objCommonWidgets.customText(context, "Confirm Exit?",
                18, Colors.black, objConstantFonts.montserratSemiBold),

            SizedBox(height: 10.dp),

            objCommonWidgets.customText(context, "You're in the middle of adding a new organic product. If you go back now, the details you've entered won’t be saved.",
                10.5, Colors.black, objConstantFonts.montserratMedium, textAlign: TextAlign.justify),

            SizedBox(height: 10.dp),

            objCommonWidgets.customText(context, "Would you like to continue adding the product or exit for now?",
                10.5, Colors.black, objConstantFonts.montserratMedium, textAlign: TextAlign.justify),

            SizedBox(height: 30.dp),

            // Action Buttons
            Row(
              children: [
                // Secondary Button: Exit
                Expanded(
                  child: CupertinoButton(
                      onPressed: () => Navigator.pop(context, true),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(20.dp)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13.dp),
                          child: Center(child: objCommonWidgets.customText(context, "Exit", 13, Colors.white, objConstantFonts.montserratSemiBold)))
                  ),
                ),

                SizedBox(width: 10.dp),

                // Primary Button: Stay
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(context, false),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20.dp)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.dp),
                        child: Center(child: objCommonWidgets.customText(context, "Stay here!", 13, Colors.white, objConstantFonts.montserratSemiBold)))
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}