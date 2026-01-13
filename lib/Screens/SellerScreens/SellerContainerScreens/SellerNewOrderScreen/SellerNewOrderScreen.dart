import 'dart:ui';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../../Utility/CommonSuccessPopup.dart';
import 'SellerNewOrderScreenState.dart';

class SellerNewOrderScreen extends ConsumerStatefulWidget {
  const SellerNewOrderScreen({super.key});

  @override
  SellerNewOrderScreenState createState() => SellerNewOrderScreenState();
}

class SellerNewOrderScreenState extends ConsumerState<SellerNewOrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Start entrance animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 15.dp),

                /// THE ANIMATED LIST
                Expanded(
                  child: ListView.builder(
                    // Critical: Clip.none prevents the "cut-off" look during slide-in
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      // Staggering Logic
                      final itemStart = (index * 0.1).clamp(0.0, 0.6);
                      final itemEnd = (itemStart + 0.4).clamp(0.0, 1.0);

                      final itemAnimation = CurvedAnimation(
                        parent: _controller,
                        curve: Interval(itemStart, itemEnd, curve: Curves.easeOutCubic),
                      );

                      return AnimatedBuilder(
                        animation: itemAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: itemAnimation.value,
                            child: Transform.translate(
                              // Using 40.dp instead of 100 for a more stable/smooth feel
                              offset: Offset((1 - itemAnimation.value) * 40.dp, 0),
                              child: child,
                            ),
                          );
                        },
                        // RepaintBoundary isolates the card so it doesn't trigger
                        // a full list rebuild on every animation frame.
                        child: RepaintBoundary(
                          child: cellView(context),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CupertinoButton(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            child: SizedBox(
                width: 20.dp,
                child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.black)),
            onPressed: () {
              var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
              userScreenNotifier.callNavigation(ScreenName.home);
            }),
        SizedBox(width: 2.5.dp),
        objCommonWidgets.customText(context, "New Order's", 16, objConstantColor.black, objConstantFonts.montserratSemiBold),
      ],
    );
  }

  Widget cellView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.dp),
      padding: EdgeInsets.all(16.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.dp),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          SizedBox(height: 20.dp),
          deliveryTimeline(context),
          SizedBox(height: 20.dp),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                objCommonWidgets.customText(context, 'Order', 15, objConstantColor.orange, objConstantFonts.montserratSemiBold),
                SizedBox(width: 5.dp),
                objCommonWidgets.customText(context, '578421015455', 12, Colors.black, objConstantFonts.montserratSemiBold),
              ],
            ),
            objCommonWidgets.customText(context, '₹249/_', 18, Colors.black, objConstantFonts.montserratSemiBold),
          ],
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                objCommonWidgets.customText(context, 'Monday', 9, objConstantColor.black, objConstantFonts.montserratSemiBold),
                objCommonWidgets.customText(context, '01/01/2026', 9, objConstantColor.black, objConstantFonts.montserratSemiBold),
              ],
            ),
            SizedBox(width: 2.dp),
            Icon(Icons.calendar_month_sharp, size: 33.dp, color: objConstantColor.black.withAlpha(200)),
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoButton(
            onPressed: () => showPurchaseBottomSheet(context),
            padding: EdgeInsets.zero,
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 12.dp),
                decoration: BoxDecoration(color: objConstantColor.yellow, borderRadius: BorderRadius.circular(20.dp)),
                child: Center(child: objCommonWidgets.customText(context, 'View Details', 13, objConstantColor.black, objConstantFonts.montserratSemiBold))),
          ),
        ),
        SizedBox(width: 10.dp),
        Expanded(
          child: CupertinoButton(
            onPressed: () => showConfirmPopup(context),
            padding: EdgeInsets.zero,
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 12.dp),
                decoration: BoxDecoration(color: const Color(0xFF06AC0B), borderRadius: BorderRadius.circular(20.dp)),
                child: Center(child: objCommonWidgets.customText(context, 'Confirm Order', 13, objConstantColor.white, objConstantFonts.montserratSemiBold))),
          ),
        ),
      ],
    );
  }

  // (The rest of your Bottom Sheet and Timeline helper functions remain here...)

  Widget deliveryTimeline(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.dp,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.dp), color: objConstantColor.yellow),
          padding: EdgeInsets.symmetric(vertical: 6.5.dp, horizontal: 5.dp),
          child: Column(
            children: [
              Icon(Icons.location_on, size: 20.dp, color: Colors.black),
              objCommonWidgets.customText(context, 'Delivery', 9, Colors.black, objConstantFonts.montserratSemiBold)
            ],
          ),
        ),
        SizedBox(width: 10.dp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(context, 'Aswin Kumar', 12, objConstantColor.orange, objConstantFonts.montserratSemiBold),
              objCommonWidgets.customText(context, 'Chandran Nivas, Chandra Nagar, Palakkad, Kerala, India', 10, Colors.black, objConstantFonts.montserratMedium),
            ],
          ),
        ),
      ],
    );
  }

  void showPurchaseBottomSheet(BuildContext context) {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF424242),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.dp)),
            ),
            child: Center(child: Text("Product List Here", style: TextStyle(color: Colors.white))),
          ),
        ),
      ).then((_) => prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false));
    });
  }

  void showConfirmPopup(BuildContext context) {
    PreferencesManager.getInstance().then((pref) {
      pref.setBooleanValue(PreferenceKeys.isDialogOpened, true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonSuccessPopup(
        title: 'Order Confirmed',
        subTitle: 'The order has been successfully confirmed.',
        onClose: () {
          pref.setBooleanValue(PreferenceKeys.isDialogOpened, false);
        },
      ),
    );
    });
  }
}