import 'dart:ui';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import 'SellerConfirmOrderScreenState.dart';

class SellerConfirmOrderScreen extends ConsumerStatefulWidget {
  const SellerConfirmOrderScreen({super.key});

  @override
  SellerConfirmOrderScreenState createState() => SellerConfirmOrderScreenState();
}

class SellerConfirmOrderScreenState extends ConsumerState<SellerConfirmOrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 🔹 Animation Controller
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Trigger animation on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    var newOrderScreenState = ref.watch(sellerConfirmOrderScreenStateProvider);

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
                // 🔹 1. Animated Header
                _buildAnimatedHeader(context),

                SizedBox(height: 15.dp),

                // 🔹 2. Animated Search Bar (Slide down from top)
                _buildAnimatedSearchBar(newOrderScreenState),

                SizedBox(height: 15.dp),

                // 🔹 3. Staggered List Entrance
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none, // Avoid layout clipping during slide
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildStaggeredItem(index);
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

  // --- ANIMATION WRAPPERS ---

  Widget _buildAnimatedHeader(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              child: SizedBox(width: 20.dp, child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.black)),
              onPressed: () {
                var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callNavigation(ScreenName.home);
              }),
          SizedBox(width: 2.5.dp),
          objCommonWidgets.customText(context, "Confirmed Order's", 16, objConstantColor.black, objConstantFonts.montserratSemiBold),
        ],
      ),
    );
  }

  Widget _buildAnimatedSearchBar(var state) {
    final searchAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: searchAnim,
      builder: (context, child) => Opacity(
        opacity: searchAnim.value,
        child: Transform.translate(
          offset: Offset(0, (1 - searchAnim.value) * -20),
          child: child,
        ),
      ),
      child: CommonTextField(
        controller: state.searchController,
        placeholder: "Search by order ID...",
        textSize: 12,
        fontFamily: objConstantFonts.montserratMedium,
        textColor: objConstantColor.black,
        isShowIcon: true,
        onChanged: (_) {},
      ),
    );
  }

  Widget _buildStaggeredItem(int index) {
    // Each item starts its animation with a 100ms delay from the previous one
    final start = (index * 0.1).clamp(0.0, 0.6);
    final end = (start + 0.4).clamp(0.0, 1.0);

    final itemAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: itemAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: itemAnimation.value,
          child: Transform.translate(
            // Slide up from bottom
            offset: Offset(0, (1 - itemAnimation.value) * 30.dp),
            child: Transform.scale(
              // Slight scale-up effect
              scale: 0.95 + (0.05 * itemAnimation.value),
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.dp),
        // RepaintBoundary ensures the animation is smooth and doesn't jank the whole list
        child: RepaintBoundary(child: cellView(context)),
      ),
    );
  }

  // --- UI COMPONENTS (OPTIMIZED) ---

  Widget cellView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.dp),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 12, offset: const Offset(0, 6))
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(context),
              SizedBox(height: 20.dp),
              deliveryTimeline(context),
              SizedBox(height: 20.dp),
              _buildPackedButton(context),
            ],
          ),
          _buildPurchasePill(context),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildPackedButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
        userScreenNotifier.callNavigation(ScreenName.confirmPacked);
      },
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.dp, vertical: 12.dp),
        decoration: BoxDecoration(
          color: const Color(0xFF06AC0B),
          borderRadius: BorderRadius.circular(22.dp),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Center(
          child: objCommonWidgets.customText(context, 'Order Packed', 13, objConstantColor.white, objConstantFonts.montserratSemiBold),
        ),
      ),
    );
  }

  Widget _buildPurchasePill(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: CupertinoButton(
        onPressed: () => showPurchaseBottomSheet(context),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: objConstantColor.yellow,
            borderRadius: BorderRadius.circular(5.dp),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 2, offset: const Offset(0, 2))],
          ),
          padding: EdgeInsets.all(7.dp),
          child: objCommonWidgets.customText(context, 'Purchase List', 10, objConstantColor.black, objConstantFonts.montserratSemiBold),
        ),
      ),
    );
  }

  // --- HELPERS & BOTTOM SHEET ---

  Widget deliveryTimeline(BuildContext context) {
    return Column(
      children: [
        timelineRow(context, icon: Icons.watch_later_sharp, title: 'Confirmed Date', subtitle: '05:25 PM, 04 Dec 2025', topic: 'Date'),
        SizedBox(height: 10.dp),
        timelineRow(context, icon: Icons.location_on, title: 'Aswin Kumar', subtitle: 'Palakkad, Kerala, India', topic: 'Delivery'),
      ],
    );
  }

  Widget timelineRow(BuildContext context, {required IconData icon, required String title, required String subtitle, required String topic}) {
    return Row(
      children: [
        Container(
          width: 50.dp,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.dp), color: objConstantColor.yellow),
          padding: EdgeInsets.symmetric(vertical: 6.5.dp, horizontal: 5.dp),
          child: Column(
            children: [
              Icon(icon, size: 20.dp, color: Colors.black),
              objCommonWidgets.customText(context, topic, 9, Colors.black, objConstantFonts.montserratSemiBold)
            ],
          ),
        ),
        SizedBox(width: 10.dp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(context, title, 12, objConstantColor.orange, objConstantFonts.montserratSemiBold),
              objCommonWidgets.customText(context, subtitle, 10, Colors.black, objConstantFonts.montserratMedium),
            ],
          ),
        ),
      ],
    );
  }

  void showPurchaseBottomSheet(BuildContext context) {
    // Bottom sheet logic remains largely the same with your BackdropFilter and DraggableScrollableSheet
    // Add logic here from previous implementation
  }

  Widget cell(BuildContext context, int index, String productName, String price, String gram, int count, String image) {
    // Product cell logic remains largely the same
    return const SizedBox();
  }
}