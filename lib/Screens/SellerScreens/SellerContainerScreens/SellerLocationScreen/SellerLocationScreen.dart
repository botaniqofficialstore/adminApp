import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerLocationScreenState.dart';

class SellerLocationScreen extends ConsumerStatefulWidget {
  const SellerLocationScreen({super.key});

  @override
  SellerLocationScreenStateUI createState() => SellerLocationScreenStateUI();
}

class SellerLocationScreenStateUI extends ConsumerState<SellerLocationScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerLocationScreenStateProvider);
    final notifier = ref.read(sellerLocationScreenStateProvider.notifier);
    String btnText = state.selectedLocation == null ? 'Pick Location' : 'Change Location';

    return Scaffold(
      backgroundColor: Colors.transparent, // Clean organic off-white
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                child: objCommonWidgets.customText(context,
                    'Please provide the correct pickup location where your products will be handed over for delivery. This address helps us ensure smooth order pickup, faster deliveries, and accurate service availability.',
                    11,
                    Colors.black,
                    objConstantFonts.montserratRegular),
              ),
            ),

            if (state.selectedLocation != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 20.dp),
                child: Container(
                  padding: EdgeInsets.all(14.dp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.dp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.dp),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.deepOrange,
                          size: 20.dp,
                        ),
                      ),
                      SizedBox(width: 10.dp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(context, 'Selected location', 10, Colors.black, objConstantFonts.montserratRegular),
                            SizedBox(height: 4.dp),
                            objCommonWidgets.customText(context, state.selectPickupAddress, 12, Colors.black, objConstantFonts.montserratMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 20.dp),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
                    decoration: BoxDecoration(
                        color: Color(0xFF4D7BFA),
                        borderRadius: BorderRadius.circular(20.dp)
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location, color: Colors.white, size: 18.dp),
                          SizedBox(width: 5.dp,),
                          objCommonWidgets.customText(context, btnText, 13, Colors.white, objConstantFonts.montserratSemiBold),
                        ],
                      ),
                    ),
                  ), onPressed: ()=> notifier.callMapPopup(context)),
            )
          ],
        ),
      ),
    );
  }

  // Modern Header
  Widget _buildHeader(BuildContext context) {
    return  Container(
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
          objCommonWidgets.customText(context, 'Pickup Location', 14, objConstantColor.black, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }
}