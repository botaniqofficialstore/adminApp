import 'dart:io';
import 'dart:ui';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerPackedOrderScreenState.dart';

class SellerPackedOrderScreen extends ConsumerStatefulWidget {
  const SellerPackedOrderScreen({super.key});

  @override
  ConsumerState<SellerPackedOrderScreen> createState() => _SellerPackedOrderScreenState();
}

class _SellerPackedOrderScreenState extends ConsumerState<SellerPackedOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Start animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            /// 1. Animated Header
            _buildAnimatedSection(
              intervalStart: 0.0,
              intervalEnd: 0.3,
              beginOffset: const Offset(0, -0.3),
              child: _buildHeader(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15.dp),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // Stagger order cards
                    final cardStart = (0.2 + (index * 0.15)).clamp(0.0, 0.8);
                    final cardEnd = (cardStart + 0.4).clamp(0.0, 1.0);

                    return _buildAnimatedSection(
                      intervalStart: cardStart,
                      intervalEnd: cardEnd,
                      beginOffset: const Offset(0, 0.1),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.dp),
                        child: _orderCard(context, ref),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ANIMATION WRAPPER ---
  Widget _buildAnimatedSection({
    required double intervalStart,
    required double intervalEnd,
    required Offset beginOffset,
    required Widget child,
  }) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOutQuart),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: beginOffset * (1.0 - animation.value) * 100,
          child: child,
        ),
      ),
      child: child,
    );
  }

  // --- UI FRAGMENTS ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () => ref.read(SellerMainScreenGlobalStateProvider.notifier).callNavigation(ScreenName.home),
            child: Image.asset(objConstantAssest.backIcon, width: 20.dp, color: objConstantColor.black),
          ),
          SizedBox(width: 8.dp),
          objCommonWidgets.customText(context, "Packed Order's", 16, objConstantColor.black, objConstantFonts.montserratSemiBold),
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sellerPackedOrderScreenStateProvider);

    return Container(
      padding: EdgeInsets.all(16.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.dp),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfo(context),
          SizedBox(height: 10.dp),
          objCommonWidgets.customText(context, 'Order Status', 13, Colors.black, objConstantFonts.montserratSemiBold),
          orderTimeline(context),
          objCommonWidgets.customText(context, 'Purchase List', 13, Colors.black, objConstantFonts.montserratSemiBold),
          SizedBox(height: 10.dp),

          /// 🔹 Grid Items with Internal Staggered Pop-in
          productListView(),
          SizedBox(height: 20.dp),
          _buildViewPhotoButton(context),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    return Row(
      children: [
        objCommonWidgets.customText(context, 'Order ID:', 14, objConstantColor.orange, objConstantFonts.montserratSemiBold),
        SizedBox(width: 5.dp),
        objCommonWidgets.customText(context, '578421015455', 12, Colors.black, objConstantFonts.montserratSemiBold),
        const Spacer(),
        objCommonWidgets.customText(context, '₹249/_', 18, Colors.black, objConstantFonts.montserratSemiBold),
      ],
    );
  }

  Widget productListView(){
    final state = ref.watch(sellerPackedOrderScreenStateProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0.dp, 0.dp, 0.dp, 0.dp),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.dp,
        crossAxisSpacing: 10.dp,
        childAspectRatio: 0.68,
      ),
      itemCount: state.productList.length,
      itemBuilder: (context, index) {
        final product = state.productList[index];
        return buildProductCard(product);
      },
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(35),
              blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.dp, right: 5.dp, top: 5.dp),
              child: NetworkImageLoader(
                imageUrl: product['image'],
                placeHolder: objConstantAssest.placeholderImage,
                size: 80.dp,
                imageSize: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(context, product['name'], 10.5, Colors.black, objConstantFonts.montserratMedium),
                SizedBox(height: 4.dp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    objCommonWidgets.customText(context, "₹${product['price']}/_", 12, const Color(
                        0xFF588E03), objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, product['quantity'], 11, Colors.black54, objConstantFonts.montserratMedium)
                  ],
                ),
                objCommonWidgets.customText(context, 'Item count: ${product['count']}', 10, Colors.black, objConstantFonts.montserratMedium)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewPhotoButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        CommonWidget().showFullScreenImageViewer(
          context,
          imageUrl: 'https://drive.google.com/uc?export=view&id=1E6BJdw_VtaekKeY50Qd9vCy7_ul7f0uT',
          title: 'Package Image',
        );
      },
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.5.dp),
        decoration: BoxDecoration(
          color: objConstantColor.orange,
          borderRadius: BorderRadius.circular(22.dp),
          boxShadow: [BoxShadow(color: objConstantColor.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 18.5.dp, color: Colors.white),
            SizedBox(width: 5.dp),
            objCommonWidgets.customText(context, 'View Package Photo', 12, Colors.white, objConstantFonts.montserratSemiBold),
          ],
        ),
      ),
    );
  }

  Widget orderTimeline(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.dp),
      child: EasyStepper(
        activeStep: 2,
        direction: Axis.horizontal,
        stepRadius: 18,
        internalPadding: 25.dp,
        activeStepBorderColor: objConstantColor.orange,
        activeStepIconColor: Colors.white,
        activeStepBackgroundColor: objConstantColor.orange,
        finishedStepBackgroundColor: objConstantColor.orange.withOpacity(0.15),
        finishedStepIconColor: objConstantColor.orange,
        unreachedStepBackgroundColor: Colors.grey.withOpacity(0.15),
        unreachedStepIconColor: Colors.grey,
        showLoadingAnimation: false,
        showTitle: true,
        steps: [
          _easyStep(icon: Icons.shopping_cart, title: 'Ordered', subtitle: '08 Jun', context: context),
          _easyStep(icon: Icons.check_circle_rounded, title: 'Confirmed', subtitle: '09 Jun', context: context),
          _easyStep(icon: Icons.shopping_bag_rounded, title: 'Packed', subtitle: '10 Jun', context: context),
        ],
      ),
    );
  }

  EasyStep _easyStep({required IconData icon, required String title, required String subtitle, required BuildContext context}) {
    return EasyStep(
      icon: Icon(icon, size: 16.dp),
      title: title,
      customTitle: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          objCommonWidgets.customText(context, title, 11, Colors.black, objConstantFonts.montserratMedium),
          objCommonWidgets.customText(context, subtitle, 8, Colors.black45, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }
}