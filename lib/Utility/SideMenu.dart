import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../Constants/ConstantVariables.dart';

class SideMenu extends StatelessWidget {
  final Function(ScreenNames)? onMenuClick;

  const SideMenu({super.key, this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: 260.dp,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
    child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05), // frosted glass effect
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.dp),
            bottomRight: Radius.circular(25.dp),
          ),

          border: Border.all(
            color: Colors.white,
            width: 1.dp,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 15.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context,
                          'Vikas C', 25,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold),
                      SizedBox(height: 5.dp),
                      objCommonWidgets.customText(context,
                          'botaniqofficialstore@gmail.com', 12.5,
                          objConstantColor.white,
                          objConstantFonts.montserratMedium),
                    ],
                  ),
                ),

                SizedBox(height: 20.dp),

                // MENU OPTIONS
                menuCard(context, objConstantAssest.addAdmin, 'New Admin', ScreenNames.home),
                menuCard(context, objConstantAssest.addDeliveryPartner, 'New Delivery Partner', ScreenNames.home),
                menuCard(context, objConstantAssest.reels, 'New Reels', ScreenNames.home),
                menuCard(context, objConstantAssest.adv, 'New Advertisment', ScreenNames.home),
                menuCard(context, objConstantAssest.logout, 'Logout', ScreenNames.home),

              ],
            ),
          ),
        ),
      ),
      )

    );
  }

  Widget menuCard(BuildContext context, String icon, String title, ScreenNames module){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 5.dp),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => onMenuClick?.call(module),
        child: Row(
          children: [
            Image.asset(icon, width: 22.dp, color: objConstantColor.white,),
            SizedBox(width: 10.dp),
            objCommonWidgets.customText(context,
                title, 13.5,
                objConstantColor.white,
                objConstantFonts.montserratSemiBold),
          ],
        ),
      ),
    );
  }
}
