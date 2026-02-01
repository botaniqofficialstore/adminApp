import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_sizer/flutter_sizer.dart';

class ConfirmClosePopup extends StatelessWidget {
  final String title;
  final String description;

  const ConfirmClosePopup({
    super.key,
    required this.title,
    required this.description,
  });


  /// Static method to show the popup and return the user's choice
  static Future<bool?> show(BuildContext context, {required String title, required String description}) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Confirm Exit',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: PopScope(
            canPop: false,
            child: ConfirmClosePopup(title: title, description: description,),
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
            SizedBox(height: 20.dp),
            Container(
              padding: EdgeInsets.only(left: 15.dp, right: 10.dp, top: 12.dp, bottom: 12.dp),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(30),
                borderRadius: BorderRadius.circular(10.dp)
              ),
              child: SizedBox(
                height: 35.dp,
                width: 35.dp,
                child: Image.asset(
                  objConstantAssest.logout,
                  fit: BoxFit.contain,
                ),
              ),
            ),


            SizedBox(height: 15.dp),

            objCommonWidgets.customText(context, "Confirm Exit?",
                15, Colors.black, objConstantFonts.montserratSemiBold),

            SizedBox(height: 25.dp),

            objCommonWidgets.customText(context, title,
                11, Colors.black, objConstantFonts.montserratMedium, textAlign: TextAlign.center),

            SizedBox(height: 10.dp),

            objCommonWidgets.customText(context, description,
                11, Colors.black, objConstantFonts.montserratSemiBold, textAlign: TextAlign.center),

            SizedBox(height: 40.dp),

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
                              color: Colors.red,
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
                        color: Colors.black,
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