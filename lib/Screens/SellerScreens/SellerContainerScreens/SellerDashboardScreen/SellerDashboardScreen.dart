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

class SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  final List<Map<String, dynamic>> orderMenuList = [
    {'title': 'New Orders', 'subtitle': 'Fresh orders not confirmed yet', 'count': '30', 'icon': objConstantAssest.newOrder, 'color': const Color(0xFF4CAF50)},
    {'title': 'Confirmed Orders', 'subtitle': "Order's confirmed by sellers", 'count': '130', 'icon': objConstantAssest.confirmedOrder, 'color': const Color(0xFF2196F3)},
    {'title': 'Packed Products', 'subtitle': 'Products ready for delivery', 'count': '47', 'icon': objConstantAssest.packedOrder, 'color': const Color(0xFFFF9800)},
    {'title': 'Completed Delivery', 'subtitle': "Delivery completed orders", 'count': '5', 'icon': objConstantAssest.completedOrder, 'color': const Color(0xFF009688)},
  ];

  final List<Map<String, dynamic>> orderDetailList = [
    {'title': 'Cancelled Orders', 'subtitle': 'Orders cancelled by customer', 'count': '8', 'icon': objConstantAssest.cancelledOrder, 'color': const Color(0xFFFF0300)},
    {'title': 'Returned Orders', 'subtitle': 'Products returned after delivery', 'count': '3', 'icon': objConstantAssest.returnedOrder, 'color': const Color(0xFF795548)},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    Future.microtask(() {
      final dashboardNotifier = ref.read(SellerDashboardScreenStateProvider.notifier);
      dashboardNotifier.updateCurrentDay();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardScreenNotifier = ref.read(SellerDashboardScreenStateProvider.notifier);
    final userScreenNotifier = ref.read(SellerMainScreenGlobalStateProvider.notifier);

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF4F4F4),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 1. Animated Header
                _buildAnimatedSection(
                  intervalStart: 0.0,
                  intervalEnd: 0.4,
                  beginOffset: const Offset(0, -0.2),
                  child: _buildHeader(context),
                ),

                SizedBox(height: 15.dp),

                // 🔹 2. Animated Delivery Hero Card
                _buildAnimatedSection(
                  intervalStart: 0.2,
                  intervalEnd: 0.6,
                  beginOffset: const Offset(0, 0.1),
                  isScale: true,
                  child: _buildDeliveryHeroCard(),
                ),

                SizedBox(height: 30.dp),

                // 🔹 3. Order Overview Title
                _buildFadeInLabel('Order Overview', 0.4),

                SizedBox(height: 10.dp),

                // 🔹 4. Main Grid (Staggered)
                _buildStaggeredGrid(
                  items: orderMenuList,
                  baseDelay: 0.4,
                  onTap: (index) => dashboardScreenNotifier.callSubModuleScreenNavigation(index, userScreenNotifier),
                ),

                SizedBox(height: 25.dp),

                // 🔹 5. Order Status Details Title
                _buildFadeInLabel('Order Status Details', 0.6),

                SizedBox(height: 10.dp),

                // 🔹 6. Details Grid (Staggered)
                _buildStaggeredGrid(
                  items: orderDetailList,
                  baseDelay: 0.7,
                  onTap: (index) => dashboardScreenNotifier.callSubCancelAndReturnsModuleScreenNavigation(index, userScreenNotifier),
                ),

                SizedBox(height: 20.dp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ANIMATION WRAPPERS ---

  Widget _buildAnimatedSection({
    required double intervalStart,
    required double intervalEnd,
    required Offset beginOffset,
    required Widget child,
    bool isScale = false,
  }) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        Widget animatedChild = Opacity(opacity: animation.value, child: child);
        if (isScale) {
          animatedChild = Transform.scale(scale: 0.8 + (0.2 * animation.value), child: animatedChild);
        }
        return Transform.translate(offset: beginOffset * (1.0 - animation.value) * 100, child: animatedChild);
      },
      child: child,
    );
  }

  Widget _buildFadeInLabel(String text, double delay) {
    return _buildAnimatedSection(
      intervalStart: delay,
      intervalEnd: delay + 0.2,
      beginOffset: const Offset(-0.05, 0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dp),
        child: objCommonWidgets.customText(context, text, 14, Colors.black, objConstantFonts.montserratSemiBold),
      ),
    );
  }

  Widget _buildStaggeredGrid({required List<Map<String, dynamic>> items, required double baseDelay, required Function(int) onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.98,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          final delay = baseDelay + (index * 0.1);

          return _buildAnimatedSection(
            intervalStart: delay.clamp(0.0, 1.0),
            intervalEnd: (delay + 0.3).clamp(0.0, 1.0),
            beginOffset: const Offset(0, 0.1),
            child: _buildOrderGridCard(
              context: context,
              title: item['title'],
              subtitle: item['subtitle'],
              count: item['count'],
              icon: item['icon'],
              accentColor: item['color'],
              onTap: () => onTap(index),
            ),
          );
        },
      ),
    );
  }

  // --- UI COMPONENTS (PRESERVED LOGIC) ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(context, 'Welcome back', 11, Colors.black.withAlpha(110), objConstantFonts.montserratMedium),
              objCommonWidgets.customText(context, 'Nourish Organics', 18, Colors.black, objConstantFonts.montserratSemiBold),
            ],
          ),
          CupertinoButton(
            onPressed: () => mainSellerScaffoldKey.currentState?.openDrawer(),
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(10.dp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.dp),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.notes_rounded, color: Color(0xFF1A1A1B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderGridCard({required BuildContext context, required String title, required String subtitle, required String count, required String icon, required Color accentColor, required VoidCallback onTap}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.dp),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.dp),
          child: Stack(
            children: [
              Positioned(
                right: 5.dp,
                bottom: 5.dp,
                child: Image.asset(icon, width: 65.dp, height: 65.dp, color: accentColor.withAlpha(110)),
              ),
              Padding(
                padding: EdgeInsets.all(20.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, title, 15, objConstantColor.navyBlue, objConstantFonts.montserratSemiBold),
                    SizedBox(height: 4.dp),
                    objCommonWidgets.customText(context, subtitle, 10, Colors.grey.shade500, objConstantFonts.montserratMedium),
                    const Spacer(),
                    objCommonWidgets.customText(context, count, 20, accentColor, objConstantFonts.montserratBold),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryHeroCard() {
    var dashboardScreenState = ref.watch(SellerDashboardScreenStateProvider);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.dp),
      padding: EdgeInsets.all(20.dp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A1A1B), Color(0xFF2D2D2E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24.dp),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(context, "Today's Delivery", 16, Colors.white, objConstantFonts.montserratSemiBold),
                  SizedBox(height: 4.dp),
                  objCommonWidgets.customText(context, '${dashboardScreenState.currentDay}', 12, Colors.white70, objConstantFonts.montserratMedium),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 10.dp),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFC9A227), Color(0xFFA57F24)]),
                  borderRadius: BorderRadius.circular(20.dp),
                ),
                child: objCommonWidgets.customText(context, '18 items', 12, Colors.white, objConstantFonts.montserratSemiBold),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.dp),
            child: Divider(color: Colors.white.withAlpha(25), thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.white.withAlpha(25), radius: 18.dp, child: Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 18.dp)),
                  SizedBox(width: 5.dp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context, 'Total Revenue', 12, Colors.white, objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, '12 Dec - 19 Dec 2025', 10, Colors.white70, objConstantFonts.montserratMedium),
                    ],
                  ),
                ],
              ),
              objCommonWidgets.customText(context, '₹15,240.0', 20, Colors.white, objConstantFonts.montserratSemiBold),
            ],
          ),
        ],
      ),
    );
  }
}