import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
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

    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Professional light grey background
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 5.dp),
              // Header & Search Section (Sticky)
              buildHeader(context),

              SizedBox(height: 15.dp),
              buildSearchBar(notifier),

              // Orders List
              Expanded(
                child: state.productList.isEmpty
                    ? Center(child: objCommonWidgets.customText(context, "No orders found", 14, Colors.grey, objConstantFonts.montserratMedium))
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(15.dp),
                  itemCount: state.productList.length,
                  itemBuilder: (context, index) {
                    final item = state.productList[index];
                    return buildOrderCard(context, item);
                  },
                ),
              ),
            ],
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
              child: SizedBox(width: 20.dp, child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.black)),
              onPressed: () {
                var userScreenNotifier = ref.read(SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callHomeNavigation();
              }),
          SizedBox(width: 2.5.dp),
          objCommonWidgets.customText(context, "Completed Orders", 14, objConstantColor.black, objConstantFonts.montserratSemiBold),
          const Spacer(),

        ],
      ),
    );
  }

  Widget buildSearchBar(SellerCompletedDeliveryScreenStateNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.dp),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => notifier.filterOrders(value),
          decoration: InputDecoration(
            hintText: "Search by product name or ID...",
            hintStyle: TextStyle(fontSize: 14.dp, color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.dp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.dp),
              borderSide: BorderSide(
                color: Colors.black.withAlpha(80), // border color when not focused
                width: 1,
              ),
            ),
          ),
        ),
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
                // Product Image
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
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Adjusting name width to ensure it doesn't collide with the badge
                      objCommonWidgets.customText(context, item['name'], 13,
                          objConstantColor.black, objConstantFonts.montserratSemiBold),
                      objCommonWidgets.customText(context, "ID: #OR48882${item['id']}",
                          10, Colors.black, objConstantFonts.montserratRegular),
                      objCommonWidgets.customText(context, "Qty: ${item['quantity']}", 10, Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Items: ${item['count']}", 10, Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, "Delivery Date: ${item['date']}", 10, Colors.black.withAlpha(180), objConstantFonts.montserratMedium),
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
                    objCommonWidgets.customText(context, "Total Amount", 10, Colors.grey[600]!, objConstantFonts.montserratMedium),
                    objCommonWidgets.customText(context, "₹${item['price']}", 17, objConstantColor.black, objConstantFonts.montserratBold),
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
                  child: objCommonWidgets.customText(context, "View Details", 10, objConstantColor.white, objConstantFonts.montserratSemiBold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}