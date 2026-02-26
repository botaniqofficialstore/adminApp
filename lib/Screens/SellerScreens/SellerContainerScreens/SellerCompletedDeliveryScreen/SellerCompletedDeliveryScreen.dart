import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../CommonPopupViews/OrderDetailsPopupView/OrderDetailsPopupView.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerCompletedDeliveryScreenState.dart';

class SellerCompletedDeliveryScreen extends ConsumerStatefulWidget {
  const SellerCompletedDeliveryScreen({super.key});
  @override
  SellerDashboardScreenState createState() => SellerDashboardScreenState();
}

class SellerDashboardScreenState extends ConsumerState<SellerCompletedDeliveryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerCompletedDeliveryScreenStateProvider);
    final notifier = ref.read(sellerCompletedDeliveryScreenStateProvider.notifier);

    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      onRefresh: () async {
        // Add your refresh logic here if needed
      },
      child: GestureDetector(
        onTap: () => CodeReusability.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: Colors.transparent, // Subtle grey for better card contrast
          body: SafeArea(
            child: AnimationLimiter(
              child: Column(
                children: [
                  // 1. Animated Header
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: -20.0,
                      child: FadeInAnimation(
                        child: Column(
                          children: [
                            SizedBox(height: 5.dp),
                            buildHeader(context),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Animated Search Bar
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: -10.0,
                      child: FadeInAnimation(
                        child: Column(
                          children: [
                            SizedBox(height: 8.dp),
                            buildSearchBar(notifier),
                            SizedBox(height: 10.dp),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Animated Orders List
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (state.productList.isEmpty) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            child: Container(
                              constraints: BoxConstraints(minHeight: constraints.maxHeight),
                              alignment: Alignment.center,
                              child: objCommonWidgets.customText(
                                context,
                                "No orders found",
                                14,
                                Colors.grey,
                                objConstantFonts.montserratMedium,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(15.dp, 5.dp, 15.dp, 15.dp),
                          itemCount: state.productList.length,
                          itemBuilder: (context, index) {
                            final item = state.productList[index];

                            // Staggered card animation
                            return AnimationConfiguration.staggeredList(
                              position: index + 2, // Start after header and search bar
                              duration: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: buildOrderCard(context, item),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Row(
        children: [
          CupertinoButton(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: 20.dp,
              child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.black),
            ),
            onPressed: () {
              var userScreenNotifier = ref.read(SellerMainScreenGlobalStateProvider.notifier);
              userScreenNotifier.callHomeNavigation();
            },
          ),
          SizedBox(width: 2.5.dp),
          objCommonWidgets.customText(
            context,
            "Completed Orders",
            14,
            objConstantColor.black,
            objConstantFonts.montserratSemiBold,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildSearchBar(SellerCompletedDeliveryScreenStateNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.dp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.dp),
                border: Border.all(color: Colors.black.withAlpha(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.black,
                onChanged: (value) => notifier.filterOrders(value),
                style: TextStyle(fontSize: 13.dp),
                decoration: InputDecoration(
                  hintText: "Search by product name or ID...",
                  hintStyle: TextStyle(fontSize: 13.dp, color: Colors.grey),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.dp, right: 4.dp),
                    child: Icon(
                      Icons.search,
                      size: 16.dp,
                      color: Colors.grey,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 30.dp,
                    minHeight: 30.dp,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.dp,
                    horizontal: 0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.dp),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.dp),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 10.dp),
          
          CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Image.asset(objConstantAssest.filterIcon, width: 20.dp), onPressed: () async {
            ref.read(sellerCompletedDeliveryScreenStateProvider.notifier).showCalendarFilterPopup(context);
          }),
          SizedBox(width: 5.dp),
        ],
      ),
    );
  }

  Widget buildOrderCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.dp),
      decoration: BoxDecoration(
        color: objConstantColor.white,
        borderRadius: BorderRadius.circular(12.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.dp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70.dp,
                  height: 70.dp,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.dp),
                    child: NetworkImageLoader(
                      imageUrl: item['image'],
                      placeHolder: objConstantAssest.placeholderImage,
                      size: 70.dp,
                      imageSize: double.infinity,
                    ),
                  ),
                ),
                SizedBox(width: 12.dp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context, item['name'], 13,
                          objConstantColor.black, objConstantFonts.montserratSemiBold),
                      objCommonWidgets.customText(context, "ID: #OR48882${item['id']}",
                          10, Colors.black, objConstantFonts.montserratRegular),
                      objCommonWidgets.customText(context, "Qty: ${item['quantity']}", 10,
                          Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Items: ${item['count']}", 10,
                          Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Delivery Date: ${item['date']}",
                          10, Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.dp, thickness: 0.5, color: Colors.black.withAlpha(80)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 10.dp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, "Total Amount", 10,
                        Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                    objCommonWidgets.customText(context, "₹${item['price']}", 17,
                        objConstantColor.black, objConstantFonts.montserratBold),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 8.dp),
                        SizedBox(width: 2.dp),
                        objCommonWidgets.customText(
                          context,
                          "Delivered on time",
                          9,
                          Colors.green,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ],
                    )
                  ],
                ),
                CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 8.dp),
                  minimumSize: Size.zero,
                  color: objConstantColor.black,
                  borderRadius: BorderRadius.circular(8.dp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const OrderDetailsPopupView(),
                      ),
                    );
                  },
                  child: objCommonWidgets.customText(context, "View Details", 10,
                      objConstantColor.white, objConstantFonts.montserratSemiBold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}