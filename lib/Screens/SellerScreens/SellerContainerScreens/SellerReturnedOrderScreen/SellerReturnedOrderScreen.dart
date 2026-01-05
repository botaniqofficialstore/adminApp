import 'dart:ui';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Utility/CalendarFilterPopup.dart';
import '../../../../../Utility/PreferencesManager.dart';
import 'SellerReturnedOrderScreenState.dart';

class SellerReturnedOrderScreen extends ConsumerStatefulWidget {
  const SellerReturnedOrderScreen({super.key});

  @override
  SellerReturnedOrderScreenState createState() => SellerReturnedOrderScreenState();
}

class SellerReturnedOrderScreenState extends ConsumerState<SellerReturnedOrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var screenNotifier = ref.watch(SellerReturnedOrderScreenStateProvider.notifier);
      screenNotifier.getFilteredDate(DateFilterType.last7Days);
    });

  }

  @override
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(SellerReturnedOrderScreenStateProvider);

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

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoButton(
                        minimumSize: Size(0, 0),
                        padding: EdgeInsets.zero,
                        child: SizedBox(width: 20.dp,
                            child: Image.asset(objConstantAssest.backIcon,
                              color: objConstantColor.black,)),
                        onPressed: () {
                          var userScreenNotifier = ref.watch(
                              SellerMainScreenGlobalStateProvider.notifier);
                          userScreenNotifier.callHomeNavigation();
                        }),
                    SizedBox(width: 2.5.dp),
                    objCommonWidgets.customText(
                      context,
                      "Returned Order's",
                      16,
                      objConstantColor.black,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),

                  ],
                ),

                SizedBox(height: 15.dp),

                /// SEARCH
                Row(
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
                      onPressed: (){

                      },
                      child: Container(
                        padding: EdgeInsets.all(8.dp),
                        decoration: BoxDecoration(
                          color: Color(0xFF795548),
                          borderRadius: BorderRadius.circular(8.dp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Icon(
                            Icons.history_rounded, size: 22.dp,
                            color: Colors.white
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 15.dp),

                /// LIST
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.dp),
                          child: cellView(context),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget cellView(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.dp),
        border: Border.all(color: Color(0xFF795548).withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          /// 1. TOP HEADER: Status & Order ID
          Container(
            padding: EdgeInsets.all(16.dp),
            decoration: BoxDecoration(
              color: Color(0xFF795548).withAlpha(10),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.dp)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, 'RETURN ORDER', 10, Color(0xFF795548), objConstantFonts.montserratBold),
                    SizedBox(height: 2.dp),
                    objCommonWidgets.customText(context, '578421015', 14, Colors.black, objConstantFonts.montserratSemiBold),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    objCommonWidgets.customText(context, 'Drop On', 10, Color(0xFF795548), objConstantFonts.montserratBold),
                    SizedBox(height: 2.dp),
                    objCommonWidgets.customText(context, '10 Jan', 10, Colors.black, objConstantFonts.montserratSemiBold),
                  ],
                ),
              ],
            ),
          ),

          /// 2. MIDDLE CONTENT: Customer & Delivery Partner
          Padding(
            padding: EdgeInsets.all(16.dp),
            child: Column(
              children: [
                // Customer Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.dp),
                      decoration: BoxDecoration(color: Color(0xFF795548).withAlpha(20), shape: BoxShape.circle),
                      child: Icon(Icons.person_outline, size: 18.dp, color: Color(0xFF795548)),
                    ),
                    SizedBox(width: 12.dp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          objCommonWidgets.customText(context, 'Johnathan Doe', 12, Colors.black, objConstantFonts.montserratSemiBold),
                          objCommonWidgets.customText(context, 'Pickup: Chandra Nagar, Palakkad', 10, Colors.black.withAlpha(150), objConstantFonts.montserratMedium),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        objCommonWidgets.customText(context, '₹249.00', 14, Colors.black, objConstantFonts.montserratSemiBold),
                        objCommonWidgets.customText(context, 'Refund Amonut', 10, Color(0xFF795548), objConstantFonts.montserratBold),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.dp),
                  child: Divider(color: Color(0xFF795548).withAlpha(40), height: 1),
                ),

                // Delivery Partner Row (New Addition)
                Container(
                  padding: EdgeInsets.all(12.dp),
                  decoration: BoxDecoration(
                    color: Color(0xFF795548).withAlpha(15),
                    borderRadius: BorderRadius.circular(12.dp),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 35.dp, width: 35.dp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.dp),
                            border: Border.all(color: Colors.grey.withAlpha(40))
                        ),
                        child: Icon(Icons.delivery_dining, color: Color(0xFF795548), size: 20.dp),
                      ),
                      SizedBox(width: 12.dp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(context, 'Delivery Partner', 9, Colors.black, objConstantFonts.montserratMedium),
                            objCommonWidgets.customText(context, 'Rajesh K.', 11, Colors.black, objConstantFonts.montserratSemiBold),
                          ],
                        ),
                      ),
                      CupertinoButton(padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          onPressed: (){
                            var screenNotifier = ref.watch(SellerReturnedOrderScreenStateProvider.notifier);
                            screenNotifier.makePhoneCall('9061197505');
                          },
                          child: CircleAvatar(backgroundColor: Color(0xFF795548), child: Icon(Icons.call, size: 18.dp, color: Colors.white))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 3. BOTTOM FOOTER: Reason & Action
          Padding(
            padding: EdgeInsets.fromLTRB(16.dp, 0, 16.dp, 16.dp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context, 'Reason for Return:', 9, Colors.black.withAlpha(150), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, 'Damaged during transit', 11, Colors.redAccent, objConstantFonts.montserratSemiBold),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showPurchaseBottomSheet(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 8.dp),
                    decoration: BoxDecoration(
                      color: Color(0xFF795548),
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                    child: objCommonWidgets.customText(context, 'View Details', 8.5, Colors.white, objConstantFonts.montserratBold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }











  // ===================== BOTTOM SHEET =====================

  void showPurchaseBottomSheet(BuildContext context) {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        barrierColor: Colors.black.withOpacity(0.35),
        builder: (_) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.dp)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.dp),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.dp),
                        child: Container(
                          width: 40.dp,
                          height: 4.dp,
                          decoration: BoxDecoration(
                            color: objConstantColor.black.withAlpha(80),
                            borderRadius: BorderRadius.circular(10.dp),
                          ),
                        ),
                      ),

                      Expanded(
                        child: CustomScrollView(
                          controller: scrollController, // 🔥 ONE controller
                          slivers: [

                            /// HEADER CONTENT
                            SliverToBoxAdapter(
                              child: Column(
                                children: [


                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.dp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        objCommonWidgets.customText(
                                          context, "Purchase Details", 16,
                                          Color(0xFF795548),
                                          objConstantFonts
                                              .montserratSemiBold,),
                                        CupertinoButton(
                                          minimumSize: Size(0, 0),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            padding: EdgeInsets.all(6.dp),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF795548).withAlpha(30),),
                                            child: Icon(Icons.close_rounded,
                                                size: 18.dp,
                                                color: Color(0xFF795548)),),),
                                      ],),),

                                  SizedBox(height: 20.dp),


                                ],
                              ),
                            ),




                            /// GRID LIST
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.dp),
                              sliver: SliverGrid(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.78,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return _productGridItem(context, index);
                                  },
                                  childCount: 3,
                                ),
                              ),
                            ),

                            SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.dp),
                                  child: Column(
                                      children: [
                                        SizedBox(height: 20.dp),



                                        SizedBox(height: 10.dp,)
                                      ]
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ).then((_) {
        prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      });
    });
  }


  /// ================= PRODUCT ITEM =================
  Widget _productGridItem(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.dp),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10.dp),
            child: Image.network(
              'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
              width: double.infinity,
              height: 115.dp,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 8.dp),

          /// PRODUCT NAME
          objCommonWidgets.customText(
            context,
            CodeReusability()
                .cleanProductName('Red Amaranthus'),
            12,
            Colors.black,
            objConstantFonts.montserratSemiBold,

          ),

          SizedBox(height: 4.dp),

          /// PRICE
          objCommonWidgets.customText(
            context,
            '₹189 / 100g',
            11,
            Color(0xFF795548),
            objConstantFonts.montserratMedium,
          ),


          /// QTY
          objCommonWidgets.customText(
            context,
            'Qty: 2',
            10,
            Colors.black54,
            objConstantFonts.montserratMedium,
          ),
        ],
      ),
    );
  }




}
