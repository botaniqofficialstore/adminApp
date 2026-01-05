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
    return SafeArea(
      bottom: false,
      child: Drawer(
          backgroundColor: Colors.transparent,
          width: 260.dp,
          child: (currentUser == UserRole.admin) ? blurView(context) :
          normalView(context)
      ),
    );
  }

  Widget blurView(BuildContext context){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        decoration: BoxDecoration(
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
        child: contentView(context),
      ),
    );
  }

  Widget normalView(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.dp),
          bottomRight: Radius.circular(25.dp),
        ),

        border: Border(
          top: BorderSide(color: Colors.white, width: (currentUser == UserRole.admin) ? 1.dp : 0.5.dp),
          right: BorderSide(color: Colors.white, width: (currentUser == UserRole.admin) ? 1.dp : 0.5.dp),
          bottom: BorderSide(color: Colors.white, width: (currentUser == UserRole.admin) ? 1.dp : 0.5.dp),
        ),
      ),
      child: contentView(context),
    );
  }

  Widget contentView(BuildContext context){
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          // HEADER
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  (currentUser == UserRole.admin) ? const [Colors.transparent, Colors.transparent] : const [Color(0xFF1A1A1B), Color(0xFF373738)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.dp),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 15.dp, horizontal: 15.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      SizedBox(height: 10.dp,),
                    objCommonWidgets.customText(context,
                        (currentUser == UserRole.admin) ? 'Vikas C' : 'Nourish Organics', 20,
                        (currentUser == UserRole.admin) ? Colors.white : Color(0xFFF8D38E),
                        objConstantFonts.montserratSemiBold),
                    SizedBox(height: 5.dp),
                    objCommonWidgets.customText(context,
                        (currentUser == UserRole.admin) ? 'botaniqofficialstore@gmail.com' : 'nourishorganics@gmail.com', 12.5,
                        Colors.white,
                        objConstantFonts.montserratMedium),

                  if (currentUser != UserRole.admin)
                      SizedBox(height: 10.dp,)
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 15.dp, horizontal: 15.dp),
              child: Column(
                children: [

                  // MENU OPTIONS
                  if (currentUser == UserRole.admin)...{
                    adminMenuList(context)
                  }else...{
                    sellerMenuList(context)
                  },


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
                            getColorForUSerRole(),
                            objConstantFonts.montserratMedium),
                      ],
                    ),
                  ),

                  SizedBox(height: 25.dp),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  Color getColorForUSerRole() {
    return (currentUser == UserRole.admin) ? Colors.white : Colors.black;
}

  Widget menuCard(BuildContext context, String icon, String title,
      ScreenName module) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 5.dp),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => onMenuClick?.call(module),
        child: Row(
          children: [
            Image.asset(icon, width: 22.dp, color: getColorForUSerRole(),),
            SizedBox(width: 10.dp),
            objCommonWidgets.customText(context,
                title, 13.5,
                getColorForUSerRole(),
                objConstantFonts.montserratSemiBold),
          ],
        ),
      ),
    );
  }

  Widget adminMenuList(BuildContext context){
    return Column(
      children: [
        menuCard(context, objConstantAssest.addAdmin, 'Contracts',
            ScreenName.contracts),
        menuCard(context, objConstantAssest.addProduct, 'Products',
            ScreenName.products),
        menuCard(context, objConstantAssest.reels, 'Reels',
            ScreenName.reels),
        menuCard(context, objConstantAssest.addDeliveryPartner,
            'Delivery Partner', ScreenName.deliveryPartner),
        menuCard(
            context, objConstantAssest.adv, 'New Advertisement',
            ScreenName.advertisement),
        menuCard(context, objConstantAssest.changePassword,
            'Change Password', ScreenName.changePassword),
        menuCard(context, objConstantAssest.logout, 'Logout',
            ScreenName.logout),
      ],
    );
  }

  Widget sellerMenuList(BuildContext context){
    return Column(
      children: [
        menuCard(context, objConstantAssest.reels, 'Reels',
            ScreenName.reels),
        Divider(color: Colors.black.withAlpha(50), height: 0.5.dp,),
        menuCard(context, objConstantAssest.addProduct, 'Products',
            ScreenName.products),
        Divider(color: Colors.black.withAlpha(50), height: 0.5.dp,),
        menuCard(context, objConstantAssest.changePassword,
            'Change Password', ScreenName.changePassword),
        Divider(color: Colors.black.withAlpha(50), height: 0.5.dp,),
        menuCard(context, objConstantAssest.logout, 'Logout',
            ScreenName.logout),
        Divider(color: Colors.black.withAlpha(50), height: 0.5.dp,),
      ],
    );
  }
}
