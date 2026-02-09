import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../Constants/ConstantVariables.dart';

class CommonSuccessPopup extends StatelessWidget {
  final String title;
  final String? subTitle;
  final VoidCallback onClose;

  const CommonSuccessPopup({
    super.key,
    required this.title,
    this.subTitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 22.dp),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.6, end: 1.0), // 🔥 small → full
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack, // premium pop effect
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: scale.clamp(0.0, 1.0), // fade-in effect
                child: child,
              ),
            );
          },
          child: _popupContent(context),
        ),
      ),
    );
  }



  Widget _popupContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// ✅ BIG SUCCESS ICON
          Container(
            width: 85.dp,
            height: 85.dp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF06AC0B),
            ),
            child: Icon(
              Icons.check,
              size: 55.dp,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 18.dp),

          /// TITLE
          objCommonWidgets.customText(
              context,
              title,
              15,
              Colors.black,
              objConstantFonts.montserratSemiBold,
              textAlign: TextAlign.center
          ),

          /// OPTIONAL SUB TITLE
          if (subTitle != null) ...[
            SizedBox(height: 8.dp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.dp),
              child: objCommonWidgets.customText(
                  context,
                  subTitle!,
                  11.5,
                  Colors.grey.shade600,
                  objConstantFonts.montserratMedium,
                  textAlign: TextAlign.center
              ),
            ),

          ],

          SizedBox(height: 22.dp),


          /// CLOSE BUTTON
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                onClose();
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.dp),
                decoration: BoxDecoration(
                  color: const Color(0xFF06AC0B),
                  borderRadius: BorderRadius.circular(20.dp),
                ),
                child: Center(
                    child: objCommonWidgets.customText(
                      context,
                      'OK',
                      15,
                      Colors.white,
                      objConstantFonts.montserratSemiBold,
                    )
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}
