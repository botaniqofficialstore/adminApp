import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../Utility/NetworkImageLoader.dart';
import 'OrderDetailsPopupViewState.dart';

class OrderDetailsPopupView extends ConsumerWidget {
  const OrderDetailsPopupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderDetailsPopupViewStateProvider);
    final notifier = ref.read(orderDetailsPopupViewStateProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: Column(
          children: [
            _buildPremiumHeader(context, notifier),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildOrderHeroSection(context),
                    Column(
                      children: [
                        SizedBox(height: 15.dp),
                        _buildSectionTitle(context, "Order Details"),
                        SizedBox(height: 5.dp),
                        orderDetails(context),

                        SizedBox(height: 15.dp),
                        _buildSectionTitle(context, "Logistics & Contact"),
                        SizedBox(height: 5.dp),
                        _buildContactCard(context),

                        SizedBox(height: 15.dp),
                        _buildSectionTitle(context, "Purchased Items"),
                        SizedBox(height: 5.dp),
                        _buildProductList(context, state),

                        SizedBox(height: 20.dp),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderDetails(BuildContext context){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
      child: Column(
        children: [
          rowView(context, 'Order ID: ', '#5878442102'),
          rowView(context, 'Order Date: ', '10/12/2026 10:25 AM'),
          rowView(context, 'Delivered Date: ', '15/12/2026 12:39 PM'),
        ],
      ),
    );
  }

  Widget rowView(BuildContext context, String title, String value){
    return Row(
      children: [
        objCommonWidgets.customText(context, title, 10, Colors.black, objConstantFonts.montserratSemiBold),
        SizedBox(width: 2.dp),
        objCommonWidgets.customText(context, value, 10, Colors.black, objConstantFonts.montserratSemiBold),
      ],
    );
  }

  /// 1. Sleek Top Bar
  Widget _buildPremiumHeader(BuildContext context, OrderDetailsPopupViewStateNotifier notifier) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 18.dp),
              onPressed: () => Navigator.pop(context),
            ),
            objCommonWidgets.customText(context, 'Order Info', 14, Colors.black, objConstantFonts.montserratSemiBold),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Icon(Icons.download_rounded, color: Colors.black, size: 22.dp),
              onPressed: () {
                notifier.showDownloadingToast(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 2. Hero Section (Order ID & Big Amount)
  Widget _buildOrderHeroSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dp),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, 'Total Revenue', 12, Colors.black, objConstantFonts.montserratMedium),
                    objCommonWidgets.customText(context, '₹1,259.0', 28, Colors.black, objConstantFonts.montserratSemiBold),

                  ],
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.dp, vertical: 6.dp),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20.dp),
                  ),
                  child: Row(
                    children: [
                      objCommonWidgets.customText(context, 'Customer Paid', 8, Colors.white, objConstantFonts.montserratSemiBold),
                      SizedBox(width: 2.dp),
                      Icon(Icons.check_circle_rounded, size: 10.dp, color: Colors.white),
                    ],
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }


  /// 3. Unified Contact Card (Glassmorphism look)
  Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _personRow(context, "Customer", "Dianne Russell", "742 Evergreen TerraceSpringfield, IL 62704 United States"),
          Divider(color: Colors.black, thickness: 0.2.dp, height: 0,),
          _personRow(context, "Delivery Agent", "Floyd Miles", "ID: AG-990", agentType: 'SpeedShip Logistics, 2450 Market Street, Suite 312San Francisco, CA 94114 United States'),
        ],
      ),
    );
  }

  Widget _personRow(BuildContext context, String role, String name, String sub, {String agentType = ''}) {
    return
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            objCommonWidgets.customText(context, role, 12, Colors.deepOrange, objConstantFonts.montserratSemiBold),
            objCommonWidgets.customText(context, name, 11, Colors.black, objConstantFonts.montserratSemiBold),
            objCommonWidgets.customText(context, sub, 10, Colors.black, objConstantFonts.montserratMedium),
            if (agentType.isNotEmpty)
            objCommonWidgets.customText(context, agentType, 10, Colors.black, objConstantFonts.montserratMedium),
          ],
        ),
      );
  }

  /// 4. Minimalist Product List
  Widget _buildProductList(BuildContext context, OrderDetailsPopupViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: state.productList.length,
        itemBuilder: (context, index) {
          final product = state.productList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.dp), // Spacing between list items
            child: buildProductCard(context, product),
          );
        },
      ),
    );
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row( // Changed from Column to Row
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Left Side: Image ---
          Padding(
            padding: EdgeInsets.all(8.dp),
            child: SizedBox(
              width: 70.dp,
              height: 70.dp,
              child: NetworkImageLoader(
                imageUrl: product['image'],
                placeHolder: objConstantAssest.placeholderImage,
                size: 50.dp,
                imageSize: 70.dp,
                bottomCurve: 10,
                topCurve: 10,
              ),
            ),
          ),

          // --- Right Side: Details ---
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.dp, top: 10.dp, bottom: 10.dp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  objCommonWidgets.customText(
                      context,
                      product['name'],
                      12, // Slightly larger for list view
                      Colors.black,
                      objConstantFonts.montserratMedium
                  ),
                  objCommonWidgets.customText(
                      context,
                      "₹${product['price']}/_",
                      13,
                      const Color(0xFF588E03),
                      objConstantFonts.montserratSemiBold
                  ),
                  objCommonWidgets.customText(
                      context,
                      product['quantity'],
                      11,
                      Colors.black54,
                      objConstantFonts.montserratMedium
                  ),
                  objCommonWidgets.customText(
                      context,
                      'Quantity: ${product['count']}',
                      10,
                      Colors.black,
                      objConstantFonts.montserratMedium
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Align(
        alignment: Alignment.centerLeft,
        child: objCommonWidgets.customText(context, title, 13, Colors.black, objConstantFonts.montserratSemiBold),
      ),
    );
  }
}