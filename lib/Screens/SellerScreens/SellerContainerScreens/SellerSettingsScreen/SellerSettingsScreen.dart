import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerSettingsScreenState.dart';

class SellerSettingsScreen extends ConsumerStatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  SellerSettingsScreenState createState() => SellerSettingsScreenState();
}

class SellerSettingsScreenState extends ConsumerState<SellerSettingsScreen> {




  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerSettingsScreenStateProvider);
    final notifier = ref.read(sellerSettingsScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent, // Sophisticated light mint-grey
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
                child: Row(
                  children: [
                    CupertinoButton(padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        child: Icon(Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: 23.dp),
                        onPressed: (){
                      var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                      userScreenNotifier.callNavigation(ScreenName.profile);
                    }),
                    SizedBox(width: 10.dp),
                    objCommonWidgets.customText(context, 'Settings', 14, objConstantColor.black, objConstantFonts.montserratMedium),

                  ],
                ),
              ),

              SizedBox(height: 10.dp),


              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.dp),
                child: objCommonWidgets.customText(
                  context,
                  'RECOMMENDATION & REMINDERS',
                  10,
                  objConstantColor.navyBlue,
                  objConstantFonts.montserratMedium,
                ),
              ),
              SizedBox(height: 10.dp),


              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                child: objCommonWidgets.customText(
                    context,
                    "Keep this on to avoid missing new orders and delivery updates. Notifications will be sent via app, WhatsApp, and SMS.",
                    10,
                    objConstantColor.navyBlue,
                    objConstantFonts.montserratMedium
                ),
              ),

              SizedBox(height: 5.dp),

              Column(
                children: [
                  _buildModernToggle("Push Notifications", state.pushNotify, notifier.togglePush),
                  SizedBox(height: 1.dp),
                  _buildModernToggle("WhatsApp Alerts", state.whatsappNotify, notifier.toggleWhatsapp),
                  SizedBox(height: 1.dp),
                  _buildModernToggle("SMS Updates", state.smsNotify, notifier.toggleSms),
                ],
              ),

              SizedBox(height: 12.dp),


            ],
          ),
        ),
      ),
    );
  }



  Widget _buildModernToggle(String title, bool value, Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 15.dp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            objCommonWidgets.customText(context, title, 11.5, objConstantColor.black, objConstantFonts.montserratMedium),
            Transform.scale(
                scale: 0.85, child: CupertinoSwitch(activeTrackColor: Colors.green, value: value, onChanged: onChanged)),
          ],
        ),
      ),
    );
  }


}