import 'dart:ui';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerDashboardScreenState.dart';

class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  SellerDashboardScreenState createState() => SellerDashboardScreenState();
}

class SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> orderMenuList = [
    {
      'title': 'New Orders',
      'subtitle': 'Fresh orders not confirmed yet',
      'count': '30',
      'icon': objConstantAssest.newOrder,
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Confirmed Orders',
      'subtitle': "Order's confirmed by sellers",
      'count': '130',
      'icon': objConstantAssest.confirmedOrder,
      'color': Color(0xFF2196F3),
    },
    {
      'title': 'Packed Products',
      'subtitle': 'Products ready for delivery',
      'count': '47',
      'icon': objConstantAssest.packedOrder,
      'color': Color(0xFFFF9800),
    },
    {
      'title': 'Completed Delivery',
      'subtitle': "Delivery completed orders",
      'count': '5',
      'icon': objConstantAssest.completedOrder,
      'color': Color(0xFF009688),
    },
  ];


  final List<Map<String, dynamic>> orderDetailList = [

    {
      'title': 'Cancelled Orders',
      'subtitle': 'Orders cancelled by customer',
      'count': '8',
      'icon': objConstantAssest.cancelledOrder,
      'color': Color(0xFFFF0300), // Red
    },

    {
      'title': 'Returned Orders',
      'subtitle': 'Products returned after delivery',
      'count': '3',
      'icon': objConstantAssest.returnedOrder,
      'color': Color(0xFF795548), // Brown / Neutral
    },
  ];




  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var userScreenNotifier = ref.watch(SellerDashboardScreenStateProvider.notifier);
      userScreenNotifier.updateCurrentDay();
    });

  }


  @override
  Widget build(BuildContext context) {
    var dashboardScreenState = ref.watch(SellerDashboardScreenStateProvider);
    var dashboardScreenNotifier = ref.watch(
        SellerDashboardScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(
        SellerMainScreenGlobalStateProvider.notifier);

    return SafeArea(
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: const Color(0xFFF4F4F4), // removed solid background
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  color: Colors.transparent, // Off-white background
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1 & 2. Header: Side Menu & Welcome
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                objCommonWidgets.customText(context, 'Welcome back',
                                    11, Colors.black.withAlpha(110),
                                    objConstantFonts.montserratMedium),
                                objCommonWidgets.customText(context, 'Nourish Organics',
                                    18, Colors.black,
                                    objConstantFonts.montserratSemiBold),
                              ],
                            ),
                            // Premium Side Menu Button
                            CupertinoButton(
                              onPressed: (){
                                mainSellerScaffoldKey.currentState?.openDrawer();
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                padding: EdgeInsets.all(10.dp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.dp),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(20),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                    Icons.notes_rounded, color: Color(0xFF1A1A1B)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.dp),
      
                      // 3. Highlight Today's Delivery (The "Hero" Widget)
                      _buildDeliveryHeroCard(),
      
                      SizedBox(height: 30.dp),
      
                      // Menu List: Orders Grid
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.dp),
                        child: objCommonWidgets.customText(context,
                            'Order Overview', 14, Colors.black, objConstantFonts.montserratSemiBold),
                      ),
                      SizedBox(height: 10.dp),
      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.dp),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderMenuList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.98,
                          ),
                          itemBuilder: (context, index) {
                            final item = orderMenuList[index];
                            return _buildOrderGridCard(
                              context: context,
                              title: item['title'],
                              subtitle: item['subtitle'],
                              count: item['count'],
                              icon: item['icon'],
                              accentColor: item['color'],
                              onTap: () {
                                dashboardScreenNotifier.callSubModuleScreenNavigation(index, userScreenNotifier);
                              },
                            );
                          },
                        ),
                      ),
      
                      SizedBox(height: 25.dp),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.dp),
                        child: objCommonWidgets.customText(context,
                            'Order Status Details', 14, Colors.black, objConstantFonts.montserratSemiBold),
                      ),
                      SizedBox(height: 10.dp),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.dp),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderDetailList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.98,
                          ),
                          itemBuilder: (context, index) {
                            final item = orderDetailList[index];
                            return _buildOrderGridCard(
                              context: context,
                              title: item['title'],
                              subtitle: item['subtitle'],
                              count: item['count'],
                              icon: item['icon'],
                              accentColor: item['color'],
                              onTap: () {
                                dashboardScreenNotifier.callSubCancelAndReturnsModuleScreenNavigation(index, userScreenNotifier);
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 10.dp),
      
      
      
      
                    ],
                  ),
                ),
              )
          )
      ),
    );
  }


  Widget _buildOrderGridCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String count,
    required String icon,
    required Color accentColor,
    required VoidCallback onTap
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.dp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.dp),
          child: Stack(
            children: [
              /// 1. Abstract Background Geometry (Modern Glass Effect)
              Positioned(
                right: 5.dp,
                bottom: 5.dp,
                child: Image.asset(
                  icon,
                  width: 65.dp,
                  height: 65.dp,
                  color: accentColor.withAlpha(110),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(
                          context,
                          title,
                          15,
                          objConstantColor.navyBlue,
                          objConstantFonts.montserratSemiBold,
                        ),
                        SizedBox(height: 4.dp),
                        objCommonWidgets.customText(
                          context,
                          subtitle,
                          10,
                          Colors.grey.shade500,
                          objConstantFonts.montserratMedium,
                        ),
                      ],
                    ),

                    const Spacer(),



                    objCommonWidgets.customText(
                      context,
                      count,
                      25,
                      accentColor,
                      objConstantFonts.montserratBold,
                    ),



                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  // Hero Card for Today's Delivery
  Widget _buildDeliveryHeroCard() {
    var dashboardScreenState = ref.watch(SellerDashboardScreenStateProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.dp),
      padding: EdgeInsets.all(20.dp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1B), Color(0xFF2D2D2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.dp),
        // More rounded for modern look
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        // Subtle inner glow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Title and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(
                      context,
                      "Today's Delivery", 16, Colors.white,
                      objConstantFonts.montserratSemiBold
                  ),
                  SizedBox(height: 4.dp),
                  objCommonWidgets.customText(
                      context,
                      '${dashboardScreenState.currentDay}', 12, Colors.white70,
                      objConstantFonts.montserratMedium
                  ),
                ],
              ),
              // Item Count Badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.dp, vertical: 10.dp),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [

                      Color(0xFFC9A227),
                      Color(0xFFA57F24),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.dp),
                ),
                child: objCommonWidgets.customText(
                    context,
                    '18 items', 12, Colors.white,
                    objConstantFonts.montserratSemiBold
                ),
              )
            ],
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.dp),
            child: Divider(color: Colors.white.withAlpha(25), thickness: 1),
          ),

          // Bottom Row: Total Revenue
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(25),
                    radius: 18.dp,
                    child: Icon(Icons.account_balance_wallet_outlined,
                        color: Colors.white, size: 18.dp),
                  ),
                  SizedBox(width: 5.dp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(
                          context,
                          'Total Revenue', 12, Colors.white,
                          objConstantFonts.montserratMedium
                      ),
                      objCommonWidgets.customText(
                          context,
                          '12 Dec - 19 Dec 2025', 10, Colors.white70,
                          objConstantFonts.montserratMedium
                      ),
                    ],
                  ),
                ],
              ),
              // Highlighted Revenue Value
              objCommonWidgets.customText(
                  context,
                  '₹15,240.0', 20, Colors.white, // Replace with dynamic value
                  objConstantFonts.montserratSemiBold
              ),
            ],
          ),
        ],
      ),
    );
  }


















}

