import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../Constants/ConstantVariables.dart';
import '../../Utility/PreferencesManager.dart';
import '../ScheduleDeliveryPopup/ScheduleDeliveryPopup.dart';

class DeliveryConfirmPopup extends StatelessWidget {
  final DateTime selectedDate;
  final DeliveryBoy deliveryBoy;

  const DeliveryConfirmPopup({
    super.key,
    required this.selectedDate,
    required this.deliveryBoy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.65),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 18.dp),
            padding: EdgeInsets.all(18.dp),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24.dp),
              border: Border.all(color: Colors.white.withAlpha(40)),
              boxShadow: [
                BoxShadow(
                  color: objConstantColor.yellow.withOpacity(0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Center(
                  child: objCommonWidgets.customText(
                    context,
                    'Confirm Delivery',
                    15,
                    Colors.white,
                    objConstantFonts.montserratSemiBold,
                  ),
                ),

                SizedBox(height: 14.dp),
                Divider(color: Colors.white.withAlpha(60)),
                SizedBox(height: 16.dp),

                /// DELIVERY DATE CARD
                _infoCard(
                  context,
                  icon: Icons.calendar_today_sharp,
                  title: 'Delivery Date',
                  value:
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate
                      .year}',
                ),

                SizedBox(height: 12.dp),

                /// DELIVERY PARTNER CARD
                Container(
                  padding: EdgeInsets.all(14.dp),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(18),
                    borderRadius: BorderRadius.circular(10.dp),
                    border: Border.all(color: Colors.white.withAlpha(45)),
                  ),
                  child: Row(
                    children: [

                      /// AVATAR
                      Container(
                        width: 30.dp,
                        height: 30.dp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: objConstantColor.white,
                            width: 1.5.dp,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            deliveryBoy.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12.dp),

                      /// DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Delivery Partner',
                              11.5,
                              objConstantColor.yellow,
                              objConstantFonts.montserratMedium,
                            ),
                            objCommonWidgets.customText(
                              context,
                              deliveryBoy.name,
                              13,
                              Colors.white,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.dp),

                /// ACTION BUTTONS
                Row(
                  children: [

                    /// CANCEL
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          PreferencesManager.getInstance().then((prefs) {
                            prefs.setBooleanValue(
                                PreferenceKeys.isDialogOpened, false);
                            Navigator.of(context).pop(false);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.dp),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(25.dp),
                            border: Border.all(
                                color: Colors.white.withAlpha(40)),
                          ),
                          child: Center(
                            child: objCommonWidgets.customText(
                              context,
                              'Cancel',
                              14,
                              Colors.white,
                              objConstantFonts.montserratMedium,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10.dp),

                    /// CONFIRM
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          PreferencesManager.getInstance().then((prefs) {
                            prefs.setBooleanValue(
                                PreferenceKeys.isDialogOpened, false);
                            Navigator.of(context).pop(true);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.dp),
                          decoration: BoxDecoration(
                            color: objConstantColor.yellow,
                            borderRadius: BorderRadius.circular(25.dp),
                          ),
                          child: Center(
                            child: objCommonWidgets.customText(
                              context,
                              'Confirm',
                              14,
                              Colors.black,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 REUSABLE INFO CARD
  Widget _infoCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Container(
      padding: EdgeInsets.all(14.dp),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(10.dp),
        border: Border.all(color: Colors.white.withAlpha(45)),
      ),
      child: Row(
        children: [
          Icon(icon, color: objConstantColor.yellow, size: 30.dp),
          SizedBox(width: 10.dp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(
                context,
                title,
                11.5,
                objConstantColor.yellow,
                objConstantFonts.montserratMedium,
              ),
              objCommonWidgets.customText(
                context,
                value,
                13,
                Colors.white,
                objConstantFonts.montserratSemiBold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}



