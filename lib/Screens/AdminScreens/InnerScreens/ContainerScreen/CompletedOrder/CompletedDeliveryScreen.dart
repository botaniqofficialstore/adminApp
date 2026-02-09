import 'dart:ui';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../CommonPopupViews/CalendarFilterPopup/CalendarFilterPopup.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../../../CommonPopupViews/ScheduleDeliveryPopup/ScheduleDeliveryPopup.dart';
import '../../MainScreen/MainScreenState.dart';
import 'CompletedDeliveryScreenState.dart';

class CompletedDeliveryScreen extends ConsumerStatefulWidget {
  const CompletedDeliveryScreen({super.key});

  @override
  CompletedDeliveryScreenState createState() => CompletedDeliveryScreenState();
}

class CompletedDeliveryScreenState extends ConsumerState<CompletedDeliveryScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey filterKey = GlobalKey();
  OverlayEntry? filterOverlay;
  late AnimationController popupController;
  late Animation<double> popupAnimation;


  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var screenNotifier = ref.watch(CompletedDeliveryScreenStateProvider.notifier);
      screenNotifier.getFilteredDate(DateFilterType.last7Days);
    });

    popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    popupAnimation = CurvedAnimation(
      parent: popupController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    hideFilterPopup();
  }

  @override
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(CompletedDeliveryScreenStateProvider);

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
                      "Completed Delivery's",
                      18,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),

                  ],
                ),

                SizedBox(height: 15.dp),

                /// SEARCH
                CommonTextField(
                  controller: userScreenState.searchController,
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    objCommonWidgets.customText(
                        context, 'Filtered list', 14, Colors.white,
                        objConstantFonts.montserratSemiBold),

                    CupertinoButton(
                      key: filterKey,
                      minimumSize: Size(0, 0),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showFilterPopup();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.dp, horizontal: 10.dp),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(5.dp),
                          border: Border.all(color: Colors.white.withAlpha(65)),
                        ),
                        child: Row(
                          children: [
                            objCommonWidgets.customText(
                                context, userScreenState.filterType ?? '', 12,
                                objConstantColor.yellow,
                                objConstantFonts.montserratSemiBold),
                            Icon(Icons.arrow_drop_down_outlined, size: 22.dp,
                              color: objConstantColor.yellow,)
                          ],
                        ),
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
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                          ],
                        ),

                      ],
                    ),


                    distanceCard(
                        context,
                        icon: objConstantAssest.distance,
                        title: 'Total Distance :',
                        value: '18km'),
                  ],
                ),

                objCommonWidgets.customText(
                  context,
                  '₹249/_',
                  18,
                  objConstantColor.yellow,
                  objConstantFonts.montserratSemiBold,
                )
              ],
            ),

            SizedBox(height: 10.dp),

            Container(
              padding: EdgeInsets.symmetric(vertical: 12.dp, horizontal: 10.dp),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(65),
                borderRadius: BorderRadius.circular(10.dp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  pricePill(
                      context, 'Product Price', '₹189'),
                  pricePill(
                      context, 'Delivery Charge', '₹80'),
                  pricePill(context, 'Total Amount', '₹249'),
                ],
              ),
            ),

            SizedBox(height: 10.dp),

            Container(
              padding: EdgeInsets.symmetric(vertical: 12.dp, horizontal: 10.dp),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(65),
                borderRadius: BorderRadius.circular(10.dp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceAround,
                children: [
                  deliveryPill(
                      context, 'Ordered Date', '20/12/2025', '06:23 PM'),
                  deliveryPill(
                      context, 'Delivered Date', '04/01/2026', '03:45 PM'),
                ],
              ),
            ),


            SizedBox(height: 12.5.dp),


              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () {
                      CommonWidget().showFullScreenImageViewer(
                        context,
                        imageUrl:
                        'https://drive.google.com/uc?export=view&id=1E6BJdw_VtaekKeY50Qd9vCy7_ul7f0uT',
                        title: 'Package Image',
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(22.dp),
                        border: Border.all(color: Colors.white.withAlpha(45)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 18.5.dp, color: objConstantColor.yellow,),
                          SizedBox(width: 2.5.dp),

                          Flexible(
                            child: objCommonWidgets.customText(
                              context,
                              'Packed Photo',
                              11,
                              objConstantColor.yellow,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                SizedBox(width: 8.dp),

                /// VIEW ITEMS BUTTON
                Expanded(
                  child: CupertinoButton(
                    onPressed: (){
                      CommonWidget().showFullScreenImageViewer(
                        context,
                        imageUrl:
                        'https://drive.usercontent.google.com/download?id=1GxhyPtudSpzg5IDSoaOqXXIN1aVjrWK5&export=view&authuser=0',
                        title: 'Package Image',
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(22.dp),
                          border: Border.all(color: Colors.white.withAlpha(45)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 18.5.dp, color: objConstantColor.yellow,),
                            SizedBox(width: 2.5.dp),
                            Flexible(
                              child: objCommonWidgets.customText(
                                context,
                                'Delivery Photo',
                                11,
                                objConstantColor.yellow,
                                objConstantFonts.montserratSemiBold,
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
              ],
            ),


            SizedBox(height: 15.dp),


            CupertinoButton(
              onPressed: () => showPurchaseBottomSheet(context),
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.dp),
                decoration: BoxDecoration(
                  color: objConstantColor.yellow,
                  borderRadius: BorderRadius.circular(25.dp),
                ),
                child: Center(
                  child: objCommonWidgets.customText(
                    context,
                    'View Details',
                    12.5,
                    objConstantColor.black,
                    objConstantFonts.montserratSemiBold,
                  ),
                )
              ),
            ),


          ],
        ),
      ),
    );
  }


  Future<ScheduleDeliveryResult?> showScheduleDeliveryPopup(
      BuildContext context, {
        required List<DeliveryBoy> deliveryBoys,
      }) {
    return showGeneralDialog<ScheduleDeliveryResult>(
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
                                        child: Row(
                                          children:
                                          [
                                            objCommonWidgets.customText(
                                              context,
                                              "Delivery Details",
                                              13, Colors.white,
                                              objConstantFonts
                                                  .montserratSemiBold,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10.dp),

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.dp,),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.dp,
                                              vertical: 10.dp),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(25),
                                            borderRadius: BorderRadius.circular(
                                                10.dp),
                                            border: Border.all(
                                                color: Colors.white.withAlpha(
                                                    10)),
                                          ),
                                          child: deliveryTimeline(context),
                                        ),
                                      ),

                                      SizedBox(height: 10.dp),


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
          icon: Icons.store_mall_directory,
          title: 'BotaniQ Store',
          subtitle: 'BotaniQ, Pavodi, Vadakkathara, Chittur, Palakkad pin. 678101',
          topic: 'Seller',
        ),
        SizedBox(height: 10.dp),
        Divider(color: Colors.white, height: 0.2.dp, thickness: 0.5.dp,),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        objCommonWidgets.customText(
          context,
          title,
          12.5,
          Colors.white,
          objConstantFonts.montserratSemiBold,
        ),

        SizedBox(width: 5.dp),

        objCommonWidgets.customText(
          context,
          value,
          15,
          objConstantColor.yellow,
          objConstantFonts.montserratSemiBold,
        ),
      ],
    );
  }

  Widget pricePill(BuildContext context,
      String title,
      String value,) {
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
          13,
          objConstantColor.yellow,
          objConstantFonts.montserratSemiBold,
        ),
      ],
    );
  }

  Widget deliveryPill(BuildContext context,
      String title,
      String date,
      String time,) {
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
          time,
          12,
          objConstantColor.yellow,
          objConstantFonts.montserratSemiBold,
        ),
        objCommonWidgets.customText(
          context,
          date,
          12,
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








  void showFilterPopup() {
    var screenNotifier = ref.watch(CompletedDeliveryScreenStateProvider.notifier);

    if (filterOverlay != null) {
      hideFilterPopup();
      return;
    }

    final renderBox = filterKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    filterOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // tap outside to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: hideFilterPopup,
              ),
            ),

            Positioned(
                left: position.dx - -85,
                top: position.dy + size.height,
                child: FilledTriangle(color: Colors.white, size: 10)

            ),

            // popup with shutter animation
            Positioned(
              left: position.dx - 10.dp,
              top: position.dy + size.height + 12,
              child: AnimatedBuilder(
                animation: popupAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    alignment: Alignment.topCenter,
                    scaleY: popupAnimation.value,  // shutter-style vertical opening
                    child: child,
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 115.dp,
                    height: 200.dp,
                    decoration: BoxDecoration(
                        color: Colors.black.withAlpha(475),
                        borderRadius: BorderRadius.circular(5.dp),
                        border: Border.all(
                          color: Colors.white.withAlpha(65),
                          width: 1,
                        )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        filterItem("Today", () {
                          screenNotifier.getFilteredDate(DateFilterType.today);
                        }),
                        Divider(color: objConstantColor.white.withAlpha(65), height: 0.1,),
                        filterItem("Last 7 days", () {
                          screenNotifier.getFilteredDate(DateFilterType.last7Days);
                        }),
                        Divider(color: objConstantColor.white.withAlpha(65), height: 0.5,),
                        filterItem("Last 6 months", () {
                          screenNotifier.getFilteredDate(DateFilterType.last6Months);
                        }),
                        Divider(color: objConstantColor.white.withAlpha(65), height: 0.5,),
                        filterItem("Last one year", () {
                          screenNotifier.getFilteredDate(DateFilterType.lastYear);
                        }),
                        Divider(color: objConstantColor.white.withAlpha(65), height: 0.5,),
                        filterItem("Custom Range", () async {
                          final result = await showCalendarFilterPopup(context);
                          if (result != null) {
                            screenNotifier.updateCustomRangeTitle(DateFilterType.customRange);
                          }

                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(filterOverlay!);

    // start shutter opening
    popupController.forward(from: 0);
  }

  void hideFilterPopup() {
    filterOverlay?.remove();
    filterOverlay = null;
  }

  Widget filterItem(String title, VoidCallback onTap) {
    return CupertinoButton(
      onPressed: () {
        hideFilterPopup();
        onTap();
      },
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 100.dp,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.5.dp, horizontal: 10.dp),
            child: Row(
              children: [
                objCommonWidgets.customText(context,
                    title,
                    12,
                    objConstantColor.white,
                    objConstantFonts.montserratMedium
                ),
                Spacer()
              ],
            )
        ),
      ),
    );
  }



  Future<DateRangeResult?> showCalendarFilterPopup(BuildContext context) async {
    final prefs = await PreferencesManager.getInstance();
    prefs.setBooleanValue(PreferenceKeys.isCommonPopup, true);

    final result = await showDialog<DateRangeResult>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF2B2B2B).withAlpha(220),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: const CalendarFilterPopup(isCustomRange: true),
      ),
    );

    prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);

    return result;
  }





}
