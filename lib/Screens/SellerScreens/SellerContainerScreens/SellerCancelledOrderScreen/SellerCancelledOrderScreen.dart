import 'dart:ui';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Utility/CalendarFilterPopup.dart';
import '../../../../../Utility/PreferencesManager.dart';
import 'SellerCancelledOrderScreenState.dart';

class SellerCancelledOrderScreen extends ConsumerStatefulWidget {
  const SellerCancelledOrderScreen({super.key});

  @override
  SellerCancelledOrderScreenState createState() => SellerCancelledOrderScreenState();
}

class SellerCancelledOrderScreenState extends ConsumerState<SellerCancelledOrderScreen>
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
      var screenNotifier = ref.watch(SellerCancelledOrderScreenStateProvider.notifier);
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
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(SellerCancelledOrderScreenStateProvider);

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
                              color: objConstantColor.black,)),
                        onPressed: () {
                          var userScreenNotifier = ref.watch(
                              SellerMainScreenGlobalStateProvider.notifier);
                          userScreenNotifier.callHomeNavigation();
                        }),
                    SizedBox(width: 2.5.dp),
                    objCommonWidgets.customText(
                      context,
                      "Cancelled Order's",
                      16,
                      objConstantColor.black,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),

                  ],
                ),

                SizedBox(height: 15.dp),

                /// SEARCH
                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        controller: userScreenState.searchController,
                        placeholder: "Search by order ID...",
                        textSize: 13,
                        fontFamily: objConstantFonts.montserratMedium,
                        textColor: objConstantColor.black,
                        isNumber: false,
                        isDarkView: false,
                        isShowIcon: true,
                        onChanged: (_) {},
                      ),
                    ),

                    SizedBox(width: 10.dp),

                    CupertinoButton(
                      key: filterKey,
                      padding: EdgeInsets.zero,
                      onPressed: showFilterPopup,
                      child: Container(
                        padding: EdgeInsets.all(8.dp),
                        decoration: BoxDecoration(
                          color: objConstantColor.orange,
                          borderRadius: BorderRadius.circular(8.dp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Icon(
                            Icons.filter_list, size: 22.dp, color: objConstantColor.white
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 15.dp),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 8.dp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.dp), // Large radius for a modern feel
                    boxShadow: [
                      // Soft ambient shadow
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      // Sharp outer definition
                      BoxShadow(
                        color: objConstantColor.orange.withOpacity(0.08),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Premium accent: A gradient vertical pill
                        Container(
                          width: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                objConstantColor.orange,
                                objConstantColor.orange.withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(width: 5.dp),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Filtered List',
                              10,
                              Colors.black.withAlpha(120), // Deep obsidian black for premium contrast
                              objConstantFonts.montserratMedium,
                            ),
                            const SizedBox(height: 2),
                            objCommonWidgets.customText(
                              context,
                              '${userScreenState.filterType ?? 'All'} Delivery List',
                              10,
                              const Color(0xFF1A1A1A), // Deep obsidian black for premium contrast
                              objConstantFonts.montserratSemiBold,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
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




  Widget cellView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.dp), // Smoother corners
        border: Border.all(color: objConstantColor.orange.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: objConstantColor.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // --- TOP SECTION: Order Header ---
          Padding(
            padding: EdgeInsets.all(20.dp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(context, 'Order', 15, objConstantColor.orange, objConstantFonts.montserratSemiBold),
                        objCommonWidgets.customText(context, '578421015455', 12, Colors.black, objConstantFonts.montserratMedium),
                      ],
                    ),
                  ],
                ),
                // Floating Price Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 8.dp),
                  decoration: BoxDecoration(
                    color: objConstantColor.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(20.dp),
                  ),
                  child: objCommonWidgets.customText(context, '₹249.00', 12, objConstantColor.orange, objConstantFonts.montserratSemiBold),
                ),
              ],
            ),
          ),

          // --- MIDDLE SECTION: User & Address ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.dp),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.dp),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Subtle contrast background
                  borderRadius: BorderRadius.circular(16.dp),
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.black.withAlpha(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.dp, horizontal: 15.dp),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15.dp,
                              backgroundColor: objConstantColor.orange.withAlpha(25),
                              child: Icon(Icons.person, color: objConstantColor.orange, size: 15.dp),
                            ),
                            SizedBox(width: 12.dp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(context, 'Johnathan Doe', 12, Colors.black, objConstantFonts.montserratSemiBold),
                                  objCommonWidgets.customText(context, '+91 98765 43210', 10, Colors.grey.shade600, objConstantFonts.montserratMedium),
                                ],
                              ),
                            ),
                            // Mini Call Button
                          ],
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: objConstantColor.orange.withAlpha(25),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on, size: 15.dp, color: objConstantColor.orange),
                            SizedBox(width: 2.5.dp),
                            Expanded(
                              child: objCommonWidgets.customText(
                                  context,
                                  'Chandra Nagar, Palakkad, Kerala, India, 678101',
                                  11, objConstantColor.orange, objConstantFonts.montserratSemiBold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- BOTTOM SECTION: Actions ---
          Padding(
            padding: EdgeInsets.all(20.dp),
            child: Row(
              children: [
                // Secondary status text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context, 'Order Cancelled on', 10, Colors.grey, objConstantFonts.montserratSemiBold),
                      objCommonWidgets.customText(context, '10:23 AM, 02 Dec 2025', 10, objConstantColor.orange, objConstantFonts.montserratSemiBold),
                    ],
                  ),
                ),
                // Modern Action Button
                GestureDetector(
                  onTap: () => showPurchaseBottomSheet(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 8.dp),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [objConstantColor.orange, objConstantColor.orange.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(20.dp),
                    ),
                    child: objCommonWidgets.customText(context, 'View Items', 10, Colors.white, objConstantFonts.montserratBold),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.dp)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.dp),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.dp),
                        child: Container(
                          width: 40.dp,
                          height: 4.dp,
                          decoration: BoxDecoration(
                            color: objConstantColor.black.withAlpha(80),
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
                                          context, "Purchase Details", 16,
                                          objConstantColor.orange,
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
                                              color: objConstantColor.orange.withAlpha(30),),
                                            child: Icon(Icons.close_rounded,
                                                size: 18.dp,
                                                color: objConstantColor.orange),),),
                                      ],),),

                                  SizedBox(height: 20.dp),


                                ],
                              ),
                            ),

                            SliverToBoxAdapter(child:
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  objCommonWidgets.customText(
                                    context,
                                    'Order Status',
                                    12,
                                    objConstantColor.black,
                                    objConstantFonts.montserratSemiBold,
                                  ),

                                  SizedBox(height: 10.dp),

                                  Container(
                                      padding: EdgeInsets.only(top: 10.dp,
                                          left: 15.dp,
                                          right: 15.dp),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            20.dp),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.1),
                                            blurRadius: 10,
                                            offset: const Offset(2, 4),
                                          )
                                        ],
                                      ),
                                      child: orderTimeline(context)),

                                  SizedBox(height: 20.dp),
                                ],
                              ),
                            )),




                            /// GRID LIST
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.dp),
                              sliver: SliverGrid(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.78,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return _productGridItem(context, index);
                                  },
                                  childCount: 2,
                                ),
                              ),
                            ),

                            SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.dp),
                                  child: Column(
                                      children: [
                                        SizedBox(height: 20.dp),



                                        SizedBox(height: 10.dp,)
                                      ]
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ).then((_) {
        prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      });
    });
  }

  Widget orderTimeline(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.zero,
          child: EasyStepper(
            activeStep: 2,
            // 0-based index (Packed)
            direction: Axis.horizontal,
            stepRadius: 18,
            internalPadding: 35.dp,

            activeStepBorderColor: objConstantColor.orange,
            activeStepIconColor: Colors.white,
            activeStepBackgroundColor: objConstantColor.orange,

            finishedStepBackgroundColor:
            objConstantColor.orange.withOpacity(0.15),
            finishedStepIconColor: objConstantColor.orange,

            unreachedStepBackgroundColor:
            Colors.grey.withOpacity(0.15),
            unreachedStepIconColor: Colors.grey,

            showLoadingAnimation: false,
            showTitle: true,

            steps: [
              _easyStep(
                  icon: Icons.shopping_cart,
                  title: 'Ordered',
                  subtitle: '08 Jun, 10:30 AM',
                  context: context
              ),
              _easyStep(
                  icon: Icons.remove_shopping_cart,
                  title: 'Cancelled',
                  subtitle: '09 Jun, 12:05 PM',
                  context: context
              ),

            ],
          ),
        );
      },
    );
  }

  EasyStep _easyStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return EasyStep(
      icon: Icon(icon, size: 16.dp),
      title: title,
      customTitle: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          objCommonWidgets.customText(context,
              title, 10,
              Colors.black,
              objConstantFonts.montserratMedium),
          SizedBox(height: 2.dp),
          objCommonWidgets.customText(context,
              subtitle, 7,
              Colors.black54,
              objConstantFonts.montserratMedium),
        ],
      ),
    );
  }


  /// ================= PRODUCT ITEM =================
  Widget _productGridItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.dp),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10.dp),
            child: Image.network(
              'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
              width: double.infinity,
              height: 115.dp,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 8.dp),

          /// PRODUCT NAME
          objCommonWidgets.customText(
            context,
            CodeReusability()
                .cleanProductName('Red Amaranthus'),
            12,
            Colors.black,
            objConstantFonts.montserratSemiBold,

          ),

          SizedBox(height: 4.dp),

          /// PRICE
          objCommonWidgets.customText(
            context,
            '₹189 / 100g',
            11,
            objConstantColor.orange,
            objConstantFonts.montserratMedium,
          ),


          /// QTY
          objCommonWidgets.customText(
            context,
            'Qty: 2',
            10,
            Colors.black54,
            objConstantFonts.montserratMedium,
          ),
        ],
      ),
    );
  }


  void showFilterPopup() {
    var screenNotifier = ref.watch(SellerCancelledOrderScreenStateProvider.notifier);

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
                left: position.dx - -15,
                top: position.dy + size.height,
                child: FilledTriangle(color: objConstantColor.black, size: 10)

            ),

            // popup with shutter animation
            Positioned(
              left: position.dx - 70.dp,
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
                            screenNotifier.updateCustomRangeTitle(result);
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
