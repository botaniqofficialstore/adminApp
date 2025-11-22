import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../Constants/ConstantVariables.dart';
import '../Constants/Constants.dart';

class SideMenu extends StatelessWidget {
  final Function(ScreenName)? onMenuClick;

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

          border: Border(
            top: BorderSide(color: Colors.white, width: 1.dp),
            right: BorderSide(color: Colors.white, width: 1.dp),
            bottom: BorderSide(color: Colors.white, width: 1.dp),
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
                menuCard(context, objConstantAssest.addAdmin, 'Contracts', ScreenName.contracts),
                menuCard(context, objConstantAssest.addProduct, 'Products', ScreenName.products),
                menuCard(context, objConstantAssest.reels, 'Reels', ScreenName.reels),
                menuCard(context, objConstantAssest.addDeliveryPartner, 'Delivery Partner', ScreenName.deliveryPartner),
                menuCard(context, objConstantAssest.adv, 'New Advertisement', ScreenName.advertisement),
                menuCard(context, objConstantAssest.changePassword, 'Change Password', ScreenName.changePassword),
                menuCard(context, objConstantAssest.logout, 'Logout', ScreenName.logout),

                Spacer(),

                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        objConstantAssest.logo,
                        height: 60.dp,
                      ),
                      objCommonWidgets.customText(context,
                          'Since 2025', 6.5,
                          objConstantColor.white,
                          objConstantFonts.montserratMedium),
                    ],
                  ),
                ),

                SizedBox(height: 20.dp),

              ],
            ),
          ),
        ),
      ),
      )

    );
  }

  Widget menuCard(BuildContext context, String icon, String title, ScreenName module){
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
