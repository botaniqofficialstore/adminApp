import 'dart:ui';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../../CommonPopupViews/CommonSuccessPopup/CommonSuccessPopup.dart';
import '../../../../Utility/NetworkImageLoader.dart';
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      physics: const NeverScrollableScrollPhysics(),
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
          productListView(),
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

  Widget productListView(){
    final state = ref.watch(sellerNewOrderScreenProvider);
    final notifier = ref.read(sellerNewOrderScreenProvider.notifier);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0.dp, 0.dp, 0.dp, 0.dp),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.dp,
        crossAxisSpacing: 10.dp,
        childAspectRatio: 0.68,
      ),
      itemCount: state.productList.length,
      itemBuilder: (context, index) {
        final product = state.productList[index];
        return buildProductCard(product);
      },
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(35),
              blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.dp, right: 5.dp, top: 5.dp),
              child: NetworkImageLoader(
                imageUrl: product['image'],
                placeHolder: objConstantAssest.placeholderImage,
                size: 80.dp,
                imageSize: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(context, product['name'], 10.5, Colors.black, objConstantFonts.montserratMedium),
                SizedBox(height: 4.dp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    objCommonWidgets.customText(context, "₹${product['price']}/_", 12, const Color(
                        0xFF588E03), objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, product['quantity'], 11, Colors.black54, objConstantFonts.montserratMedium)
                  ],
                ),
                objCommonWidgets.customText(context, 'Item count: ${product['count']}', 10, Colors.black, objConstantFonts.montserratMedium)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return CupertinoButton(
      onPressed: () => showConfirmPopup(context),
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 12.dp),
          decoration: BoxDecoration(color: const Color(0xFF06AC0B), borderRadius: BorderRadius.circular(20.dp)),
          child: Center(child: objCommonWidgets.customText(context, 'Confirm Order', 13, objConstantColor.white, objConstantFonts.montserratSemiBold))),
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