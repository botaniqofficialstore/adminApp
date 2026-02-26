import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import 'SellerConfirmOrderScreenState.dart';

class SellerConfirmOrderScreen extends ConsumerStatefulWidget {
  const SellerConfirmOrderScreen({super.key});

  @override
  SellerConfirmOrderScreenState createState() => SellerConfirmOrderScreenState();
}

class SellerConfirmOrderScreenState extends ConsumerState<SellerConfirmOrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerConfirmOrderScreenStateProvider);
    final notifier = ref.read(sellerConfirmOrderScreenStateProvider.notifier);

    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      onRefresh: () async {
        // Add your refresh logic here if needed
      },
      child: GestureDetector(
        onTap: () => CodeReusability.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent, // Professional clean background
            body: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: buildOrderCard(context, item, notifier),
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

  Widget buildSearchBar(SellerConfirmOrderScreenStateNotifier notifier) {
    final state = ref.watch(sellerConfirmOrderScreenStateProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
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
          controller: state.searchController,
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
    );
  }

  Widget buildOrderCard(BuildContext context, Map<String, dynamic> item, SellerConfirmOrderScreenStateNotifier notifier) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.dp),
      decoration: BoxDecoration(
        color: objConstantColor.white,
        borderRadius: BorderRadius.circular(15.dp),
        border: Border.all(color: Colors.grey.withAlpha(50)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          // Top section: Order ID and Date
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                objCommonWidgets.customText(context, "Order ID: #OR4888245448454${item['id']}",
                    10, Colors.black, objConstantFonts.montserratRegular),
              ],
            ),
          ),
          const Divider(height: 1),
          // Middle section: Product details
          Padding(
            padding: EdgeInsets.all(12.dp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.dp),
                  child: SizedBox(
                    width: 80.dp,
                    height: 80.dp,
                    child: NetworkImageLoader(
                      imageUrl: item['image'],
                      placeHolder: objConstantAssest.placeholderImage,
                      size: 80.dp,
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
                      objCommonWidgets.customText(context, "Qty: ${item['quantity']}", 10,
                          Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Items: ${item['count']}", 10,
                          Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Ordered Date: ${item['orderDate']}",
                          10, Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Confirm Date: ${item['confirmDate']}",
                          10, Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 3. SEPARATE WIDGET: Shipping Address
          buildShippingInfo(context, item),
          // Bottom section: Action Button
          Padding(padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
          child: CupertinoButton(
              onPressed: (){
            var mainNotifier = ref.read(SellerMainScreenGlobalStateProvider.notifier);
            notifier.callUpdateAction(mainNotifier);
          },
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.dp),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(20.dp)
            ),
            child: Center(
              child: objCommonWidgets.customText(context, 'Mark as Packed', 13, Colors.white, objConstantFonts.montserratSemiBold),
            ),
          )))
        ],
      ),
    );
  }

  Widget buildShippingInfo(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(10),
          borderRadius: BorderRadius.circular(8.dp),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_pin, size: 16.dp, color: objConstantColor.black),
            SizedBox(width: 2.dp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(context, "Shipping to:", 12, Colors.black, objConstantFonts.montserratSemiBold),
                  SizedBox(height: 2.dp),
                  objCommonWidgets.customText(
                      context,
                      "${item['customerName']} | ${item['address']}",
                      10,
                      objConstantColor.black,
                      objConstantFonts.montserratMedium
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}