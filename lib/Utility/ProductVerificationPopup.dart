import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../Constants/ConstantVariables.dart';

class ProductVerificationPopup extends StatelessWidget {
  const ProductVerificationPopup({super.key});

  /// Static method to show the popup with custom animation
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // ⛔ disable outside tap
      barrierLabel: '',
      barrierColor: Colors.black.withAlpha(120),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: PopScope(
            canPop: false, // ⛔ disable back button
            child: const ProductVerificationPopup(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(anim1),
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
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.all(30.dp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.dp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Header with Soft Glow
            Container(
              padding: EdgeInsets.all(20.dp),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.eco_rounded,
                size: 50.dp,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 25.dp),


            objCommonWidgets.customText(
                context,
                "Submission Received",
                20,
                Colors.black,
                objConstantFonts.montserratSemiBold,
            ),

            SizedBox(height: 5.dp),


            objCommonWidgets.customText(
              context,
              "Your organic product is currently under verification. Our team is reviewing the quality standards to ensure the best for our community.",
              11,
              Colors.black,
              objConstantFonts.montserratMedium,
                textAlign: TextAlign.justify
            ),


            SizedBox(height: 10.dp),

            // Status Highlight
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 8.dp),
              decoration: BoxDecoration(
                color: Colors.yellowAccent.withAlpha(45),
                borderRadius: BorderRadius.circular(8.dp),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 20.dp, color: Colors.deepOrange),
                   SizedBox(width: 5.dp),
                  Flexible(
                    child: objCommonWidgets.customText(
                      context,
                      "After the review your product will be available to customers zoon!",
                      9,
                      Colors.deepOrange,
                      objConstantFonts.montserratSemiBold,
                    ),
                  )

                ],
              ),
            ),

            SizedBox(height: 30.dp),

            // Action Button
            CupertinoButton(padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15.dp),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20.dp)
                  ),
                  child: Center(
                    child: objCommonWidgets.customText(
                      context,
                      "Got it!",
                      14,
                      Colors.white,
                      objConstantFonts.montserratBold,
                    ),
                  ),

            ), onPressed: () => Navigator.pop(context))
          ],
        ),
      ),
    );
  }
}