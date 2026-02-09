import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../CommonPopupViews/CalendarFilterPopup/CalendarFilterPopup.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../MainScreen/MainScreenState.dart';
import 'ScheduledDeliveryScreenState.dart';

class ScheduledDeliveryScreen extends ConsumerStatefulWidget {
  const ScheduledDeliveryScreen({super.key});

  @override
  ScheduledDeliveryScreenState createState() => ScheduledDeliveryScreenState();
}

class ScheduledDeliveryScreenState extends ConsumerState<ScheduledDeliveryScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    Future.microtask((){
      var screenNotifier = ref.watch(ScheduledDeliveryScreenStateProvider.notifier);
      screenNotifier.setDefaultDates();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenState = ref.watch(ScheduledDeliveryScreenStateProvider);
    var screenNotifier = ref.watch(ScheduledDeliveryScreenStateProvider.notifier);

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
                  children: [
                    CupertinoButton(
                        minimumSize: Size(0, 0),
                        padding: EdgeInsets.zero, child: SizedBox(width: 20.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                        onPressed: (){
                          var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                          userScreenNotifier.showFooter();
                          userScreenNotifier.callNavigation(ScreenName.home);
                        }),
                    SizedBox(width: 2.5.dp),
                    objCommonWidgets.customText(
                      context,
                      'Scheduled Delivery',
                      18,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                  ],
                ),

                SizedBox(height: 15.dp),

                /// SEARCH
                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        controller: screenState.searchController,
                        placeholder: "Search by order ID...",
                        textSize: 12,
                        fontFamily: objConstantFonts.montserratMedium,
                        textColor: objConstantColor.white,
                        isNumber: false,
                        isDarkView: true,
                        isShowIcon: true,
                        onChanged: (_) {},
                      ),
                    ),

                    SizedBox(width: 8.dp),

                    CupertinoButton(padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),onPressed: () async {
                          final result = await showCalendarFilterPopup(context);

                          if (result != null) {
                            screenNotifier.updateDateRange(result);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.2.dp, horizontal: 10.dp),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(7.dp),
                            border: Border.all(color: Colors.white.withAlpha(180)),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.filter_list_alt,
                                color: objConstantColor.yellow,
                              size: 19.dp,),
                              objCommonWidgets.customText(
                                context,
                                'Filter',
                                8.5,
                                objConstantColor.yellow,
                                objConstantFonts.montserratMedium,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),

                SizedBox(height: 20.dp),

                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        if (screenState.filterStartDate != null)
                        dateFilterView(context),


                        SizedBox(height: 20.dp),

                        /// LIST
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.dp),
                              child: cellView(context),
                            );
                          },
                        ),
                      ],
                    ),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget dateFilterView(BuildContext context) {
    var screenState = ref.watch(ScheduledDeliveryScreenStateProvider);
    final bool hasRange = screenState.filterEndDate != null;
    var screenNotifier = ref.watch(ScheduledDeliveryScreenStateProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(35),
        borderRadius: BorderRadius.circular(10.dp),
        border: Border.all(color: Colors.white.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(Icons.calendar_month, size: 35.dp, color: Colors.white,),
          SizedBox(width: 3.5.dp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(
                context,
                hasRange
                    ? 'Scheduled delivery from'
                    : 'Scheduled delivery on',
                10,
                Colors.white,
                objConstantFonts.montserratSemiBold,
              ),

              SizedBox(height: 2.dp),
              Row(
                children: [

                  if (!hasRange)...{
                    objCommonWidgets.customText(
                      context,
                      screenNotifier.dateLocalFormat(screenState.filterStartDate!),
                      12.5,
                      objConstantColor.yellow,
                      objConstantFonts.montserratSemiBold,
                    ),
                  } else...{

                    objCommonWidgets.customText(
                      context,
                      screenNotifier.dateLocalFormat(screenState.filterStartDate!),
                      12.5,
                      objConstantColor.yellow,
                      objConstantFonts.montserratSemiBold,
                    ),

                    SizedBox(width: 5.dp),

                    objCommonWidgets.customText(
                      context,
                      'to',
                      12.5,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),

                    SizedBox(width: 5.dp),

                    objCommonWidgets.customText(
                      context,
                      screenNotifier.dateLocalFormat(screenState.filterEndDate!),
                      12.5,
                      objConstantColor.yellow,
                      objConstantFonts.montserratSemiBold,
                    ),
                  }
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<DateRangeResult?> showCalendarFilterPopup(BuildContext context) {
    return showDialog<DateRangeResult>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const CalendarFilterPopup()
      ),
    );
  }



  // ===================== DELIVERY CARD =====================

  Widget cellView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.dp),
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
                          12,
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    objCommonWidgets.customText(
                      context,
                      'Delivery Date',
                      10,
                      Colors.white,
                      objConstantFonts.montserratMedium,
                    ),

                    objCommonWidgets.customText(
                      context,
                      '10, Dec 2026',
                      13,
                      objConstantColor.yellow,
                      objConstantFonts.montserratSemiBold,
                    ),

                  ],
                )

              ],
            ),

            SizedBox(height: 18.dp),

            /// TIMELINE
            deliveryTimeline(context),

            SizedBox(height: 16.dp),

            /// PERSON CARDS
            Row(
              children: [
                miniPersonCard(
                  context,
                  icon: Icons.person,
                  title: 'Customer',
                  value: 'Aswin',
                ),

                SizedBox(width: 5.dp),

                miniPersonCard(
                  context,
                  icon: Icons.calendar_today_rounded,
                  title: 'Order Date',
                  value: '10/12/2025',
                ),
              ],
            ),

            SizedBox(height: 5.dp),

            Row(
              children: [

                miniPersonCard(
                  context,
                  icon: Icons.delivery_dining,
                  title: 'Rider',
                  value: 'Arjun',
                ),
                SizedBox(width: 5.dp),
                distanceCard(context, icon: objConstantAssest.distance, title: 'Total Distance', value: '18km'),
              ],
            ),

            SizedBox(height: 16.dp),

            /// PRICE STRIP
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 10.dp),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(80),
                borderRadius: BorderRadius.circular(10.dp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pricePill(context, 'Product Price', '₹189'),
                  pricePill(context, 'Delivery Charge', '₹80'),
                  pricePill(context, 'Total Amount', '₹249', isPrimary: true),
                ],
              ),
            ),

            SizedBox(height: 20.dp),

            /// VIEW ITEMS BUTTON
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => showPurchaseBottomSheet(context),
                    padding: EdgeInsets.zero,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.dp),
                        decoration: BoxDecoration(
                          color: objConstantColor.yellow,
                          borderRadius: BorderRadius.circular(5.dp),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Center(
                          child: objCommonWidgets.customText(
                            context,
                            'View Items',
                            11.5,
                            objConstantColor.navyBlue,
                            objConstantFonts.montserratSemiBold,
                          ),
                        )
                    ),
                  ),
                ),

                SizedBox(width: 10.dp),

                Expanded(
                  child: CupertinoButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.dp),
                      decoration: BoxDecoration(
                        color: objConstantColor.yellow,
                        borderRadius: BorderRadius.circular(5.dp),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          objCommonWidgets.customText(
                            context,
                            'Download Invoice',
                            11.5,
                            Colors.black,
                            objConstantFonts.montserratSemiBold,
                          ),
                          SizedBox(width: 2.5.dp),
                          Icon(Icons.download_rounded, size: 15.dp, color: Colors.black,)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
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
                      color: Colors.white,
                      child: Column(
                        children: [

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.dp),
                            child: Container(
                              width: 40.dp,
                              height: 4.dp,
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(50),
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
                                              Colors.black,
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
                                                  color: Colors.black.withAlpha(
                                                      15),),
                                                child: Icon(Icons.close_rounded,
                                                    size: 18.dp,
                                                    color: Colors.black),),),
                                          ],),),

                                      SizedBox(height: 20.dp),

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.dp),
                                        child: Row(
                                          children:
                                          [
                                            objCommonWidgets.customText(
                                              context,
                                              "Price Details",
                                              13, Colors.black,
                                              objConstantFonts
                                                  .montserratSemiBold,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10.dp),

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.dp),
                                        child: Container(
                                          padding: EdgeInsets.all(14.dp),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(25),
                                            borderRadius: BorderRadius.circular(
                                                5.dp),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children:
                                                [
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "Total Product Price",
                                                    13, Colors.black,
                                                    objConstantFonts
                                                        .montserratMedium,
                                                  ),
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "389/_",
                                                    13, Colors.black,
                                                    objConstantFonts
                                                        .montserratMedium,
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children:
                                                [
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "Delivery Charge",
                                                    13, Colors.black,
                                                    objConstantFonts
                                                        .montserratMedium,
                                                  ),
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "69/_",
                                                    13, Colors.black,
                                                    objConstantFonts
                                                        .montserratMedium,
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children:
                                                [
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "Discount",
                                                    13, Colors.black,
                                                    objConstantFonts
                                                        .montserratMedium,
                                                  ),
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "49/_",
                                                    13, Colors.black,
                                                    objConstantFonts
                                                        .montserratMedium,
                                                  ),
                                                ],
                                              ),

                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.dp),
                                                child: Divider(
                                                  color: Colors.black45,
                                                  height: 1.5.dp,),
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children:
                                                [
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "Total Amount",
                                                    14.5, Colors.black,
                                                    objConstantFonts
                                                        .montserratSemiBold,
                                                  ),
                                                  objCommonWidgets.customText(
                                                    context,
                                                    "415/_",
                                                    14.5, Colors.black,
                                                    objConstantFonts
                                                        .montserratSemiBold,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
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
                                              13, Colors.black,
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
                                      childCount: 2,
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
          topic: 'Pickup',
        ),
        SizedBox(height: 10.dp),
        timelineRow(
          context,
          icon: Icons.location_on,
          title: 'Aswin Kumar',
          subtitle: 'Chandran Nivas, Chandra Nagar, Palakkad, Kerala, India',
          topic: 'Drop',
        ),
      ],
    );
  }

  Widget timelineRow(
      BuildContext context, {
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
                Colors.white,
                objConstantFonts.montserratSemiBold,
              ),
              objCommonWidgets.customText(
                context,
                subtitle,
                10,
                Colors.white.withAlpha(210),
                objConstantFonts.montserratMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget miniPersonCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 2.dp),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
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


  Widget distanceCard(
      BuildContext context, {
        required String icon,
        required String title,
        required String value,
      }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.dp, horizontal: 2.dp),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(8.dp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 22.dp, color: Colors.white),
            SizedBox(width: 5.dp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(
                  context,
                  title,
                  9,
                  Colors.white,
                  objConstantFonts.montserratSemiBold,
                ),
                objCommonWidgets.customText(
                  context,
                  value,
                  12,
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

  Widget pricePill(
      BuildContext context,
      String title,
      String value, {
        bool isPrimary = false,
      }) {
    return Column(
      children: [
        objCommonWidgets.customText(
          context,
          title,
          9.5,
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
  Widget cell(
      BuildContext context,
      int index,
      String productName,
      String price,
      String gram,
      int count,
      String image,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.dp),
            border: Border.all(color: Colors.black, width: 0.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.dp),
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
          Colors.black,
          objConstantFonts.montserratSemiBold,
        ),
        /// Price
        Row(
          children: [
            objCommonWidgets.customText(
              context,
              'Price:',
              12,
              Colors.black,
              objConstantFonts.montserratMedium,
            ),
            SizedBox(width: 5.dp,),
            objCommonWidgets.customText(
              context,
              '₹$price/_',
              12,
              objConstantColor.green,
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
                Colors.black,
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
                    Colors.black,
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
