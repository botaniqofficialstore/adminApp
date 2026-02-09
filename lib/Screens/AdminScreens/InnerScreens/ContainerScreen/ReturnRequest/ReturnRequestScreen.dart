
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../../../CommonPopupViews/ScheduleDeliveryPopup/ScheduleDeliveryPopup.dart';
import '../../MainScreen/MainScreenState.dart';
import 'ReturnRequestScreenState.dart';

class ReturnRequestScreen extends ConsumerStatefulWidget {
  const ReturnRequestScreen({super.key});

  @override
  ReturnRequestScreenState createState() => ReturnRequestScreenState();
}

class ReturnRequestScreenState extends ConsumerState<ReturnRequestScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(ReturnRequestScreenStateProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoButton(
                        minimumSize: Size(0, 0),
                        padding: EdgeInsets.zero,
                        child: SizedBox(width: 20.dp,
                            child: Image.asset(objConstantAssest.backIcon,
                              color: objConstantColor.white,)),
                        onPressed: () {
                          var userScreenNotifier = ref.watch(
                              MainScreenGlobalStateProvider.notifier);
                          userScreenNotifier.showFooter();
                          userScreenNotifier.callHomeNavigation();
                        }),
                    SizedBox(width: 2.5.dp),
                    objCommonWidgets.customText(
                      context,
                      "Return Request's",
                      18,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),

                    CupertinoButton(
                      minimumSize: Size(0, 0),
                      onPressed: () {

                      },
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Icon(Icons.calendar_month_sharp,
                            color: objConstantColor.yellow,
                            size: 25.dp,),
                          objCommonWidgets.customText(
                            context,
                            'History',
                            8,
                            objConstantColor.yellow,
                            objConstantFonts.montserratSemiBold,
                          ),
                        ],
                      ),
                    )

                  ],
                ),

                SizedBox(height: 15.dp),


                /// LIST
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.dp),
                          child: cellView(context),
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

  // ===================== DELIVERY CARD =====================

  Widget cellView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.dp),
      child: Stack(
        children: [

          Container(
            padding: EdgeInsets.all(16.dp),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(22.dp),
              border: Border.all(color: Colors.white.withAlpha(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Order',
                              15,
                              objConstantColor.yellow,
                              objConstantFonts.montserratSemiBold,
                            ),
                            SizedBox(width: 5.dp),
                            objCommonWidgets.customText(
                              context,
                              '578421015455',
                              12,
                              Colors.white,
                              objConstantFonts.montserratMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Refund Amount:',
                              13,
                              objConstantColor.yellow,
                              objConstantFonts.montserratSemiBold,
                            ),
                            SizedBox(width: 5.dp),
                            objCommonWidgets.customText(
                              context,
                              '₹249/_',
                              14,
                              Colors.white,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),

                SizedBox(height: 20.dp),

                deliveryTimeline(context),

                SizedBox(height: 20.dp),


                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 8.dp),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(10.dp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(
                          context,
                          'Reason for return',
                          10,
                          objConstantColor.yellow,
                          objConstantFonts.montserratSemiBold,
                        ),
                        objCommonWidgets.customText(
                          context,
                          'Product is in out of expiry date',
                          10,
                          objConstantColor.white.withAlpha(245),
                          objConstantFonts.montserratMedium,
                        )
                      ],
                    )
                ),


                    SizedBox(height: 20.dp),


                CupertinoButton(
                  onPressed: () async {

                    final result = await showScheduleDeliveryPopup(
                      context,
                      deliveryBoys: [
                        DeliveryBoy('Male',
                            'https://drive.google.com/uc?export=videsw&id=1vNjNvV-ahFL4j0XiF73arYmuKyIyOHDg',
                            'PJS44178789',
                            'KL70H1661',
                            'arunkumar48@gmail.com',
                            'Chendrathil house, Vadakkathar, Chuttur, Kerala, 678101 (P.O)',
                            id: '124875',
                            name: 'Arun Kumar'),

                        DeliveryBoy('Male',
                            'https://drive.google.com/uc?export=videsw&id=1vNjNvV-ahFL4j0XiF73arYmuKyIyOHDg',
                            'PJS44178789',
                            'KL07H9461',
                            'jacobThomas@gmail.com',
                            'Chendrathil house, Vadakkathar, Chuttur, Kerala, 678101 (P.O)',
                            id: '978754',
                            name: 'Jacob Thomas'),
                      ],
                    );

                    if (result != null) {
                      debugPrint(result.deliveryBoyId); // DB001
                      debugPrint(result.utcDate);       // 2025-01-21T00:00:00Z
                    }

                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 12.dp),
                      decoration: BoxDecoration(
                        color: objConstantColor.yellow,
                        borderRadius: BorderRadius.circular(22.dp),
                      ),
                      child: Center(
                        child: objCommonWidgets.customText(
                          context,
                          'Schedule Pickup',
                          14,
                          objConstantColor.black,
                          objConstantFonts.montserratSemiBold,
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),

          Positioned(
              top: 10.dp,
              right: 10.dp,
              child: CupertinoButton(
            onPressed: () => showPurchaseBottomSheet(context),
            padding: EdgeInsets.zero,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.5.dp),
                child: Center(
                  child: objCommonWidgets.customText(
                    context,
                    'View Details',
                    11,
                    objConstantColor.yellow,
                    objConstantFonts.montserratSemiBold,
                  ),
                )
            ),
          ))



        ],
      ),
    );
  }


  Future<ScheduleDeliveryResult?> showScheduleDeliveryPopup(
      BuildContext context, {
        required List<DeliveryBoy> deliveryBoys,
      }) {
    return PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isCommonPopup, true);
      showGeneralDialog<ScheduleDeliveryResult>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'ScheduleDelivery',
        barrierColor: Colors.black.withOpacity(0.45),
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: ScheduleDeliveryPopup(
              deliveryBoys: deliveryBoys,
            ),
          );
        },
        transitionBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
      ).then((_){
        prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);
      });});
  }


  // ===================== BOTTOM SHEET =====================


  void showPurchaseBottomSheet(BuildContext context) {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        barrierColor: Colors.black.withAlpha(100),
        builder: (_) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.75,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.dp)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(22.dp),
                      border: Border.all(color: Colors.white.withAlpha(15),),
                    ),
                    child: Container(
                      color: Colors.white.withAlpha(1),
                      child: Column(
                        children: [

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.dp),
                            child: Container(
                              width: 40.dp,
                              height: 4.dp,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(150),
                                borderRadius: BorderRadius.circular(10.dp),
                              ),
                            ),
                          ),

                          Expanded(
                            child: CustomScrollView(
                              controller: scrollController, // 🔥 ONE controller
                              slivers: [

                                /// HEADER CONTENT
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [


                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.dp),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            objCommonWidgets.customText(
                                              context, 'Purchase Details', 16,
                                              Colors.white,
                                              objConstantFonts
                                                  .montserratSemiBold,),
                                            CupertinoButton(
                                              minimumSize: Size(0, 0),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                padding: EdgeInsets.all(6.dp),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white.withAlpha(
                                                      15),),
                                                child: Icon(Icons.close_rounded,
                                                    size: 18.dp,
                                                    color: Colors.white),),),
                                          ],),),

                                      SizedBox(height: 20.dp),

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.dp),
                                        child: distanceCard(
                                            context,
                                            icon: objConstantAssest.distance,
                                            title: 'Total Distance',
                                            value: '18km'
                                        ),
                                      ),

                                      SizedBox(height: 25.dp),

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.dp),
                                        child: Row(
                                          children:
                                          [
                                            objCommonWidgets.customText(
                                              context,
                                              "Product's List",
                                              13, Colors.white,
                                              objConstantFonts
                                                  .montserratSemiBold,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10.dp),
                                    ],
                                  ),
                                ),


                                /// GRID LIST
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.dp),
                                  sliver: SliverGrid(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.65,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        return cell(
                                          context,
                                          index,
                                          'Red Amaranthus',
                                          '189',
                                          '100g',
                                          2,
                                          'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
                                        );
                                      },
                                      childCount: 5,
                                    ),
                                  ),
                                ),

                                SliverToBoxAdapter(
                                    child: Column(
                                        children: [
                                          SizedBox(height: 20.dp),
                                        ]
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ).then((_){
        prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      });
    });
  }

  // ===================== HELPERS =====================

  Widget deliveryTimeline(BuildContext context) {
    return Column(
      children: [
        timelineRow(
          context,
          icon: Icons.location_on,
          title: 'Aswin Kumar',
          subtitle: 'Chandran Nivas, Chandra Nagar, Palakkad, Kerala, India',
          topic: 'Pickup',
        ),

        SizedBox(height: 10.dp),

        timelineRow(
          context,
          icon: Icons.store_mall_directory,
          title: 'BotaniQ Store',
          subtitle: 'BotaniQ, Pavodi, Vadakkathara, Chittur, Palakkad pin. 678101',
          topic: 'Seller',
        ),

      ],
    );
  }

  Widget timelineRow(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String topic,
  }) {
    return Row(
      children: [
        Container(
          width: 50.dp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.dp),
            color: objConstantColor.yellow,
          ),
          padding: EdgeInsets.symmetric(vertical: 6.5.dp, horizontal: 5.dp),
          child: Column(
            children: [
              Icon(icon, size: 20.dp, color: Colors.black),
              SizedBox(height: 2.dp),
              objCommonWidgets.customText(
                context,
                topic,
                9,
                Colors.black,
                objConstantFonts.montserratSemiBold,
              )
            ],
          ),
        ),
        SizedBox(width: 10.dp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(
                context,
                title,
                12,
                objConstantColor.yellow,
                objConstantFonts.montserratSemiBold,
              ),
              objCommonWidgets.customText(
                context,
                subtitle,
                10,
                Colors.white,
                objConstantFonts.montserratMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget miniPersonCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 2.dp),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(8.dp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22.dp, color: Colors.white),
            SizedBox(width: 5.dp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(
                  context,
                  title,
                  10,
                  Colors.white,
                  objConstantFonts.montserratMedium,
                ),
                objCommonWidgets.customText(
                  context,
                  value,
                  10,
                  objConstantColor.yellow,
                  objConstantFonts.montserratSemiBold,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  Widget distanceCard(BuildContext context, {
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.dp, horizontal: 12.dp),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(155),
        borderRadius: BorderRadius.circular(15.dp),
      ),
      child: Row(
        children: [
          const Spacer(),
          Image.asset(icon, height: 28.dp, color: Colors.white),
          SizedBox(width: 10.dp),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              objCommonWidgets.customText(
                context,
                title,
                15.5,
                Colors.white,
                objConstantFonts.montserratSemiBold,
              ),

              SizedBox(width: 10.dp),

              objCommonWidgets.customText(
                context,
                value,
                18,
                objConstantColor.yellow,
                objConstantFonts.montserratSemiBold,
              ),
            ],
          ),

          const Spacer(),

        ],
      ),
    );
  }

  Widget pricePill(BuildContext context,
      String title,
      String value, {
        bool isPrimary = false,
      }) {
    return Column(
      children: [
        objCommonWidgets.customText(
          context,
          title,
          10.5,
          Colors.white,
          objConstantFonts.montserratMedium,
        ),
        SizedBox(height: 10.dp),
        objCommonWidgets.customText(
          context,
          value,
          isPrimary ? 16 : 13,
          objConstantColor.yellow,
          objConstantFonts.montserratSemiBold,
        ),
      ],
    );
  }

  /// PRODUCT CELL (UNCHANGED)
  Widget cell(BuildContext context,
      int index,
      String productName,
      String price,
      String gram,
      int count,
      String image,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.dp),
            border: Border.all(color: Colors.white, width: 0.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.dp),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                image,
                fit: BoxFit.fill,
                loadingBuilder: (c, w, p) =>
                p == null ? w : const CupertinoActivityIndicator(),
                errorBuilder: (_, __, ___) =>
                    Image.asset(objConstantAssest.homeIcon),
              ),
            ),
          ),
        ),
        SizedBox(height: 6.dp),
        objCommonWidgets.customText(
          context,
          CodeReusability().cleanProductName(productName),
          12,
          Colors.white,
          objConstantFonts.montserratSemiBold,
        ),

        /// Price
        Row(
          children: [
            objCommonWidgets.customText(
              context,
              'Price:',
              12,
              Colors.white,
              objConstantFonts.montserratMedium,
            ),
            SizedBox(width: 5.dp,),
            objCommonWidgets.customText(
              context,
              '₹$price/_',
              12,
              objConstantColor.yellow,
              objConstantFonts.montserratSemiBold,
            ),

          ],
        ),

        SizedBox(height: 2.dp),

        /// Quantity
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: objCommonWidgets.customText(
                context,
                'Quantity: $count',
                10,
                Colors.white,
                objConstantFonts.montserratMedium,
              ),
            ),

          ],
        ),
        SizedBox(height: 2.dp),

        /// Net Weight
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  objCommonWidgets.customText(
                    context,
                    'Net Wt (per item): $gram',
                    10,
                    Colors.white,
                    objConstantFonts.montserratMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
