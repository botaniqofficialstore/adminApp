import 'dart:ui';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../../../Utility/CalendarFilterPopup.dart';
import '../../../../Utility/PreferencesManager.dart';
import 'SellerCompletedDeliveryScreenState.dart';
import 'package:botaniq_admin/constants/Constants.dart';




  class SellerCompletedDeliveryScreen extends ConsumerStatefulWidget {
  const SellerCompletedDeliveryScreen({super.key});

  @override
  SellerDashboardScreenState createState() => SellerDashboardScreenState();
  }

  class SellerDashboardScreenState extends ConsumerState<SellerCompletedDeliveryScreen>
      with SingleTickerProviderStateMixin {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey filterKey = GlobalKey();
    OverlayEntry? filterOverlay;
    late AnimationController popupController;
    late Animation<double> popupAnimation;

    @override
  void initState() {
      Future.microtask((){
        var screenNotifier = ref.watch(SellerCompletedDeliveryScreenStateProvider.notifier);
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

    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      final state = ref.watch(SellerCompletedDeliveryScreenStateProvider);

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
          
              /// ================= COLLAPSIBLE HEADER =================
              SliverAppBar(
                expandedHeight: 240.dp,
                pinned: false,
                floating: false,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context),
                ),
              ),
          
              /// ================= PINNED SEARCH BAR =================
              SliverAppBar(
                pinned: true,
                primary: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                toolbarHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(padding: EdgeInsets.symmetric(horizontal: 15.dp),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: state.searchController,
                          placeholder: "Search by order ID...",
                          textSize: 14,
                          fontFamily: objConstantFonts.montserratMedium,
                          textColor: objConstantColor.black,
                          isShowIcon: true,
                          isDarkView: false,
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
                            color: Colors.white,
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
                              Icons.filter_list, size: 22.dp, color: Color(0xFF7606DC)
                          ),
                        ),
                      )
          
          
                    ],
                  ),),
                ),
              ),


              SliverAppBar(
                pinned: true,
                primary: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                toolbarHeight: 50,
                titleSpacing: 15.dp,

                title: Container(
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
                                Color(0xFF7606DC),
                                Color(0xFF7606DC).withOpacity(0.5),
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
                              '${state.filterType ?? 'All'} Delivery List',
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
              ),




              /// ================= DELIVERY LIST =================
              SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: 15.dp, vertical: 15.dp),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.dp),
                        child: _orderCard(context, ref),
                      );
                    },
                    childCount: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildHeader(BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.dp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [

              Color(0xFF52029C),
              Color(0xFF6204B8),
              Color(0xFF7606DC),
              Color(0xFF8B42F8),

            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.dp),
            bottomRight: Radius.circular(25.dp),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.dp),

              objCommonWidgets.customText(
                context,
                'Delivery Overview',
                18,
                Colors.white,
                objConstantFonts.montserratSemiBold,
              ),

              SizedBox(height: 10.dp),
              _buildStatItem("Completed Delivery's", "23750", Icons.check_circle),

              SizedBox(height: 10.dp),
              Row(
                children: [
                  Expanded(child: _buildStatItem("Pending", "12", Icons.pending_actions)),
                  SizedBox(width: 10.dp),
                  Expanded(child: _buildStatItem("Out for Delivery", "08", Icons.local_shipping)),
                ],
              ),
            ],
          ),
        ),
      );
    }


    // Helper method for the stats
    Widget _buildStatItem(String label, String count, IconData icon) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 15.dp),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(45),
          borderRadius: BorderRadius.circular(10.dp)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(
                  context,
                  count,
                  23,
                  Colors.white,
                  objConstantFonts.montserratSemiBold,
                ),

                SizedBox(height: 5.dp),

                objCommonWidgets.customText(
                  context,
                  label,
                  13,
                  Colors.white,
                  objConstantFonts.montserratSemiBold,
                ),
              ],
            ),

            Spacer(),

            Icon(icon, color: Colors.white, size: 25.dp),
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
              Color(0xFF7606DC),
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


    /// ================= ORDER CARD =================
    Widget _orderCard(BuildContext context, WidgetRef ref) {
      return Container(
        padding: EdgeInsets.all(16.dp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.dp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ORDER INFO
            Row(
              children: [
                objCommonWidgets.customText(
                  context,
                  'Order ID:',
                  14,
                  Color(0xFF7606DC),
                  objConstantFonts.montserratSemiBold,
                ),
                SizedBox(width: 5.dp),
                objCommonWidgets.customText(
                  context,
                  '578421015455',
                  12,
                  Colors.black,
                  objConstantFonts.montserratSemiBold,
                ),
                const Spacer(),
                objCommonWidgets.customText(
                  context,
                  '₹249/_',
                  18,
                  Color(0xFF7606DC),
                  objConstantFonts.montserratSemiBold,
                ),
              ],
            ),

            SizedBox(height: 10.dp),


            objCommonWidgets.customText(
              context,
              'Order Details',
              13,
              Colors.black,
              objConstantFonts.montserratSemiBold,
            ),


            SizedBox(height: 10.dp),

            deliveryDetail(context),

            SizedBox(height: 20.dp),

            CupertinoButton(
              onPressed: () => showPurchaseBottomSheet(context),
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.5.dp),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF7606DC),
                  borderRadius: BorderRadius.circular(22.dp),
                ),
                child: objCommonWidgets.customText(
                    context,
                    'View Details',
                    12,
                    objConstantColor.white,
                    objConstantFonts.montserratSemiBold,
                    textAlign: TextAlign.center
                ),
              ),
            )


          ],
        ),
      );
    }

    Widget deliveryDetail(BuildContext context) {
      return Column(
        children: [
          Row(
            children: [
              _timelineCircle(
                Icons.delivery_dining_rounded,
                Colors.green,
              ),

              SizedBox(width: 15.dp),

              _timelineCard(
                context,
                title: 'Delivered by',
                name: 'Akhil Raj',
                description: 'Delivered on: 10 Jun, 02:45 PM',
              ),
            ],
          ),


          SizedBox(height: 10.dp),
          Row(
            children: [
              _timelineCircle(
                Icons.location_on,
                objConstantColor.orange,
              ),

              SizedBox(width: 15.dp),

              Flexible(
                child: _timelineCard(
                  context,
                  title: 'Delivered to',
                  name: 'Aswin Kumar',
                  description:
                  'Chandran Nivas, Chandra Nagar, Palakkad, Kerala, India',
                ),
              ),
            ],
          )
        ],
      );
    }


    Widget _timelineCard(BuildContext context, {
      required String title,
      required String name,
      required String description,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// NAME
          objCommonWidgets.customText(
            context,
            name,
            12,
            Colors.black,
            objConstantFonts.montserratSemiBold,
          ),

          SizedBox(height: 4.dp),

          /// DESCRIPTION
          objCommonWidgets.customText(
            context,
            description,
            10,
            Colors.black54,
            objConstantFonts.montserratMedium,
          ),
        ],
      );
    }


    Widget _timelineCircle(IconData icon, Color color) {
      return Container(
        height: 36.dp,
        width: 36.dp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF7606DC).withAlpha(30),
        ),
        child: Icon(icon, color: Color(0xFF7606DC), size: 18.dp),
      );
    }


    Widget orderTimeline(BuildContext context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.zero,
            child: EasyStepper(
              activeStep: 3,
              // 0-based index (Packed)
              direction: Axis.horizontal,
              stepRadius: 18,
              internalPadding: 15.dp,


              activeStepBorderColor: Color(0xFF7606DC),
              activeStepIconColor: Colors.white,
              activeStepBackgroundColor: Color(0xFF7606DC),

              finishedStepBackgroundColor:
              Color(0xFF7606DC).withOpacity(0.15),
              finishedStepIconColor: Color(0xFF7606DC),

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
                    icon: Icons.check_circle_rounded,
                    title: 'Confirmed',
                    subtitle: '09 Jun, 12:05 PM',
                    context: context
                ),
                _easyStep(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Packed',
                    subtitle: '10 Jun, 12:20 PM',
                    context: context
                ),
                _easyStep(
                    icon: Icons.delivery_dining_outlined,
                    title: 'Delivered',
                    subtitle: '11 Jun, 09:20 AM',
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
                              color: Color(0xFF7606DC).withAlpha(150),
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
                                            context, "Delivery Details", 16,
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
                                                color: Color(0xFF7606DC).withAlpha(30),),
                                              child: Icon(Icons.close_rounded,
                                                  size: 18.dp,
                                                  color: Color(0xFF7606DC)),),),
                                        ],),),

                                    SizedBox(height: 10.dp),


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

                              SliverToBoxAdapter(child:
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.dp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    objCommonWidgets.customText(
                                      context,
                                      'Purchase List',
                                      12,
                                      objConstantColor.black,
                                      objConstantFonts.montserratSemiBold,
                                    ),

                                    SizedBox(height: 10.dp,)
                                  ],
                                ),)),


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

                                          CupertinoButton(
                                            onPressed: () {
                                              CommonWidget()
                                                  .showFullScreenImageViewer(
                                                context,
                                                imageUrl:
                                                'https://drive.google.com/uc?export=view&id=1E6BJdw_VtaekKeY50Qd9vCy7_ul7f0uT',
                                                title: 'Package Image',
                                              );
                                            },
                                            padding: EdgeInsets.zero,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12.5.dp),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF7606DC),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    22.dp),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Icon(
                                                    Icons.image, size: 18.5.dp,
                                                    color: objConstantColor
                                                        .white,),
                                                  SizedBox(width: 2.5.dp),
                                                  objCommonWidgets.customText(
                                                    context,
                                                    'View Package Photo',
                                                    12,
                                                    objConstantColor.white,
                                                    objConstantFonts
                                                        .montserratSemiBold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

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





    void showFilterPopup() {
      var screenNotifier = ref.watch(SellerCompletedDeliveryScreenStateProvider.notifier);

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
                  child: FilledTriangle(color: Colors.black, size: 10)

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





