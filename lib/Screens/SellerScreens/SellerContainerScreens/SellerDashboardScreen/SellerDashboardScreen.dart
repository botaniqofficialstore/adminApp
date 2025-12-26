import 'dart:ui';
import 'package:botaniq_admin/Constants/Constants.dart';
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
  final List<String> menuList = [
    'New Orders',
    'Confirmed Orders',
    'Packed Products',
    'Scheduled Delivery',
    'Completed Delivery',
  ];

  final List<String> menu2List = [
    'Cancelled Orders',
    'Return Requests',
  ];

  final List<String> menuSubList = [
    'Fresh orders not confirmed yet.',
    "Order's confirmed by seller's.",
    "Products ready for delivery",
    "Assigned order's for delivery partner",
    "Delivery completed order's",
  ];

  final List<String> menu2SubList = [
    "Order's Cancelled by customers.",
    "Order return request's by customers",
  ];

  final List<String> menuSubCount = [
    '30',
    '130',
    '47',
    '15',
    '5',
  ];

  final List<String> menu2SubCount = [
    '2',
    '10'
  ];

  final List<String> menuSubIcons = [
    objConstantAssest.newOrder,
    objConstantAssest.confirmedOrder,
    objConstantAssest.packedOrder,
    objConstantAssest.deliveryCar,
    objConstantAssest.completedOrder,
  ];


  final List<String> menu2SubIcons = [
    objConstantAssest.cancelledOrder,
    objConstantAssest.returnedOrder,
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

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color(0xFFF8F9FA), // removed solid background
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                color: const Color(0xFFF8F9FA), // Off-white background
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1 & 2. Header: Side Menu & Welcome
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
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
                                  Icons.notes_rounded, color: Color(0xFF1A1A1B)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Highlight Today's Delivery (The "Hero" Widget)
                    _buildDeliveryHeroCard(),

                    SizedBox(height: 25.dp),

                    // Menu List: Orders Grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.dp),
                      child: Text(
                        "Order's",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 15.dp),

                    _buildMenuTile('New Orders', '12', Icons.access_alarm_sharp, Colors.white)

                  ],
                ),
              ),
            )
        )
    );
  }

  // Hero Card for Today's Delivery
  Widget _buildDeliveryHeroCard() {
    var dashboardScreenState = ref.watch(SellerDashboardScreenStateProvider);
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 15.dp),
      padding:  EdgeInsets.symmetric(vertical: 20.dp, horizontal: 15.dp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1B), Color(0xFF373738)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Today's Delivery", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(
                '${dashboardScreenState.currentDay}', // Dynamic Date
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC9A227),
                  Color(0xFF8B6B1F),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              "24 Items",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  // Menu Tile Widget
  Widget _buildMenuTile(String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }
  }

