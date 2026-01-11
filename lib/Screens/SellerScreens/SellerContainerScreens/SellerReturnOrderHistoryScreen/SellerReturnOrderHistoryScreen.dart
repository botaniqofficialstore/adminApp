import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../../../Constants/ConstantVariables.dart';
import 'SellerReturnOrderHistoryScreenState.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';

class SellerReturnOrderHistoryScreen extends ConsumerStatefulWidget {
  const SellerReturnOrderHistoryScreen({super.key});

  @override
  SellerReturnOrderHistoryScreenStateUI createState() =>
      SellerReturnOrderHistoryScreenStateUI();
}

class SellerReturnOrderHistoryScreenStateUI
    extends ConsumerState<SellerReturnOrderHistoryScreen>
    with TickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF795548);

  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    Future.microtask(() {
      ref
          .read(sellerReturnOrderHistoryScreenStateProvider.notifier)
          .loadInitialData();
      _mainController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userScreenState =
    ref.watch(sellerReturnOrderHistoryScreenStateProvider);
    final notifier =
    ref.read(sellerReturnOrderHistoryScreenStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.dp),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 10.dp),
              _buildSearchBar(context),
              SizedBox(height: 15.dp),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userScreenState.returnOrders.length,
                    itemBuilder: (context, index) {
                      final itemDelay = (index * 0.1).clamp(0.0, 1.0);
                      final Animation<double> itemAnimation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _mainController,
                          curve: Interval(
                            0.3 + itemDelay,
                            1.0,
                            curve: Curves.decelerate,
                          ),
                        ),
                      );

                      return AnimatedBuilder(
                        animation: itemAnimation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: itemAnimation,
                            child: Transform.translate(
                              offset:
                              Offset(0, 50 * (1 - itemAnimation.value)),
                              child: child,
                            ),
                          );
                        },
                        child: _buildModernOrderCard(
                          userScreenState.returnOrders[index],
                          index,
                          notifier,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
            begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(
            CurvedAnimation(parent: _mainController, curve: Curves.easeOut)),
        child: Row(
          children: [
            CupertinoButton(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              child: SizedBox(
                width: 20.dp,
                child: Image.asset(
                  objConstantAssest.backIcon,
                  color: objConstantColor.black,
                ),
              ),
              onPressed: () {
                ref
                    .read(SellerMainScreenGlobalStateProvider.notifier)
                    .callReturnOrderScreenNavigation();
              },
            ),
            SizedBox(width: 6.dp),
            objCommonWidgets.customText(
              context,
              "Return Order's History",
              16,
              objConstantColor.black,
              objConstantFonts.montserratSemiBold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final userScreenState =
    ref.watch(sellerReturnOrderHistoryScreenStateProvider);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
            begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(
            CurvedAnimation(parent: _mainController, curve: Curves.easeOut)),
        child: Row(
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
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.all(8.dp),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8.dp),
                ),
                child: Icon(Icons.filter_list_rounded,
                    size: 22.dp, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModernOrderCard(ReturnOrderModel order, int index, var notifier) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.dp),
        border: Border.all(color: primaryColor.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.dp),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.dp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(
                          context,
                          order.orderId,
                          10,
                          primaryColor,
                          objConstantFonts.montserratSemiBold),
                      objCommonWidgets.customText(
                          context,
                          'Amount: ${order.price}',
                          12,
                          Colors.black,
                          objConstantFonts.montserratSemiBold),
                    ],
                  ),
                  Column(
                    children: [
                      objCommonWidgets.customText(
                          context,
                          'Ordered Date',
                          10,
                          primaryColor,
                          objConstantFonts.montserratSemiBold),
                      objCommonWidgets.customText(
                          context,
                          order.orderedDate.split('•')[0],
                          12,
                          Colors.black,
                          objConstantFonts.montserratSemiBold),
                    ],
                  ),
                ],
              ),
            ),

            // Logistics Flow
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dp),
              child: Column(
                children: [
                  _buildLogisticsRow(
                    title: "OUTBOUND (Delivery)",
                    from: "Seller (You)",
                    to: order.customerName,
                    partner: order.outboundPartner,
                    date: order.deliveredToCustomerDate,
                    icon: Icons.local_shipping,

                    accent: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.dp),
                    child: Icon(Icons.swap_vert, color: primaryColor),
                  ),
                  _buildLogisticsRow(
                    title: "INBOUND (Return)",
                    from: order.customerName,
                    to: "Seller (You)",
                    partner: order.returnPartner,
                    date: order.returnedToSellerDate,
                    icon: Icons.assignment_return,
                    accent: Colors.white,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.dp),

            // Toggle Button
            CupertinoButton(
              onPressed: () => notifier.toggleExpansion(index),
              padding: EdgeInsets.zero,
              child: Container(
                color: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.dp),
                width: double.infinity,
                child: Center(
                  child: objCommonWidgets.customText(
                    context,
                    order.isExpanded
                        ? "Hide"
                        : "View Purchased Products",
                    12,
                    Colors.white,
                    objConstantFonts.montserratSemiBold,
                  ),
                ),
              ),
            ),

            /// ✅ SMOOTH EXPAND / COLLAPSE (ONLY ADDITION)
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: order.isExpanded
                  ? FadeTransition(
                opacity: CurvedAnimation(
                  parent: _mainController,
                  curve: Curves.easeIn,
                ),
                child: Container(
                  padding: EdgeInsets.all(16.dp),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20.dp),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(
                          context,
                          'Purchased Products',
                          9,
                          Colors.black54,
                          objConstantFonts.montserratSemiBold),
                      SizedBox(height: 10.dp),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8.dp),
                            child: Image.network(
                              order.productImage,
                              width: 50.dp,
                              height: 50.dp,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.dp),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                objCommonWidgets.customText(
                                    context,
                                    order.productName,
                                    10,
                                    primaryColor,
                                    objConstantFonts
                                        .montserratSemiBold),
                                objCommonWidgets.customText(
                                    context,
                                    "${order.quantity} x ${order.itemCount}",
                                    11,
                                    Colors.black54,
                                    objConstantFonts
                                        .montserratMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.dp),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.dp),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius:
                          BorderRadius.circular(10.dp),
                        ),
                        child: objCommonWidgets.customText(
                            context,
                            "Return Reason: ${order.returnReason}",
                            10,
                            Colors.red[800],
                            objConstantFonts.montserratMedium),
                      )
                    ],
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsRow({
    required String title,
    required String from,
    required String to,
    required String partner,
    required String date,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      padding: EdgeInsets.all(12.dp),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(15.dp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.dp, color: primaryColor),
              SizedBox(width: 5.dp),
              objCommonWidgets.customText(
                  context, title, 9, primaryColor,
                  objConstantFonts.montserratSemiBold),
              const Spacer(),
              objCommonWidgets.customText(
                  context, date, 9, primaryColor,
                  objConstantFonts.montserratSemiBold),
            ],
          ),
          SizedBox(height: 8.dp),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _node(from, "Pickup"),
              ),

              Center(
                child: Icon(
                  Icons.arrow_right_alt,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              Expanded(
                child: _node(
                  to,
                  "Destination",
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),

          Divider(height: 20.dp, color: primaryColor.withAlpha(85)),
          Row(
            children: [
              Icon(Icons.person, size: 12.dp, color: primaryColor),
              SizedBox(width: 5.dp),
              objCommonWidgets.customText(
                  context,
                  "Agent: $partner",
                  9,
                  primaryColor,
                  objConstantFonts.montserratSemiBold),
            ],
          )
        ],
      ),
    );
  }

  Widget _node(String name, String label, {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        objCommonWidgets.customText(
            context, label, 10, primaryColor,
            objConstantFonts.montserratBold),
        objCommonWidgets.customText(
            context, name, 10, primaryColor,
            objConstantFonts.montserratSemiBold),
      ],
    );
  }
}
