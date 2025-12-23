import 'dart:ui';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Utility/PreferencesManager.dart';
import 'NewOrderScreenState.dart';

class NewOrderScreen extends ConsumerStatefulWidget {
  const NewOrderScreen({super.key});

  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}

class NewOrderScreenState extends ConsumerState<NewOrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var newOrderScreenState = ref.watch(NewOrderScreenStateProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    objCommonWidgets.customText(
                      context,
                      "Fresh Order's",
                      20,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),

                  ],
                ),

                SizedBox(height: 15.dp),

                /// SEARCH
                CommonTextField(
                  controller: newOrderScreenState.searchController,
                  placeholder: "Search by order ID...",
                  textSize: 12,
                  fontFamily: objConstantFonts.montserratMedium,
                  textColor: objConstantColor.white,
                  isNumber: false,
                  isDarkView: true,
                  isShowIcon: true,
                  onChanged: (_) {},
                ),

                SizedBox(height: 15.dp),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.dp),
                        child: cellView(context),
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

  // ===================== DELIVERY CARD =====================

  Widget cellView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.dp),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(16.dp),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.14),
                Colors.white.withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(22.dp),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
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
                      objCommonWidgets.customText(
                        context,
                        '₹249/_',
                        18,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          objCommonWidgets.customText(
                            context,
                            'Monday',
                            9,
                            objConstantColor.white,
                            objConstantFonts.montserratSemiBold,
                          ),
                          objCommonWidgets.customText(
                            context,
                            '01/01/2026',
                            9,
                            objConstantColor.white,
                            objConstantFonts.montserratSemiBold,
                          ),
                        ],
                      ),
                      SizedBox(width: 2.dp),
                      Icon(Icons.calendar_month_sharp,
                          size: 33.dp,
                          color: objConstantColor.yellow),
                    ],
                  )

                ],
              ),

              SizedBox(height: 20.dp),

              deliveryTimeline(context),

              SizedBox(height: 20.dp),

              /// VIEW ITEMS BUTTON
              CupertinoButton(
                onPressed: () => showPurchaseBottomSheet(context),
                padding: EdgeInsets.zero,
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.dp, vertical: 12.dp),
                    decoration: BoxDecoration(
                      color: objConstantColor.yellow,
                      borderRadius: BorderRadius.circular(20.dp),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Center(
                      child: objCommonWidgets.customText(
                        context,
                        'View Details',
                        13,
                        objConstantColor.navyBlue,
                        objConstantFonts.montserratSemiBold,
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== BOTTOM SHEET =====================


  void showPurchaseBottomSheet(BuildContext context) {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.75,
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.dp)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.14),
                        Colors.white.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22.dp),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
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
                                            objConstantFonts.montserratSemiBold,),
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
                                                color: Colors.white.withOpacity(
                                                    0.15),),
                                              child: Icon(Icons.close_rounded, size: 18.dp,
                                                  color: Colors.white),),),
                                        ],),),

                                    SizedBox(height: 15.dp),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.dp),
                                      child: Row(
                                        children:
                                        [
                                          objCommonWidgets.customText(
                                            context,
                                            "Price Details",
                                            13, Colors.white,
                                            objConstantFonts.montserratSemiBold,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 5.dp),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.dp),
                                      child: Container(
                                        padding: EdgeInsets.all(14.dp),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(155),
                                          borderRadius: BorderRadius.circular(15.dp),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            pricePill(
                                                context, 'Product Price', '₹189'),
                                            pricePill(
                                                context, 'Delivery Charge', '₹80'),
                                            pricePill(context, 'Total Amount', '₹249',
                                                isPrimary: true),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 15.dp),

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

                                    SizedBox(height: 15.dp),

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
                                            objConstantFonts.montserratSemiBold,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 5.dp),
                                  ],
                                ),
                              ),


                              /// GRID LIST
                              SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: 16.dp),
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
          icon: Icons.store_mall_directory,
          title: 'BotaniQ Store',
          subtitle: 'BotaniQ, Pavodi, Vadakkathara, Chittur, Palakkad pin. 678101',
          topic: 'Seller',
        ),
        SizedBox(height: 10.dp),
        timelineRow(
          context,
          icon: Icons.location_on,
          title: 'Aswin Kumar',
          subtitle: 'Chandran Nivas, Chandra Nagar, Palakkad, Kerala, India',
          topic: 'Delivery',
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
          color: Colors.white.withOpacity(0.08),
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
