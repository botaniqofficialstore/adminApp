import 'dart:ui';
import 'package:botaniq_admin/Constants/Constants.dart';
import 'package:botaniq_admin/Screens/InnerScreens/ContainerScreen/DashboardScreen/DashboardScreenState.dart';
import 'package:botaniq_admin/Screens/InnerScreens/MainScreen/MainScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../MainScreen/MainScreenState.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> menuList = [
    'New Orders',
    'Confirmed Orders',
    'Packed Products',
    'Scheduled Delivery',
    'Completed Delivery',
    'Returned Orders',
    'Cancelled Orders'
  ];
  final List<String> menuSubList = [
    'Fresh orders not confirmed yet.',
    "Order's confirmed by seller's.",
    "Products ready for delivery",
    "Assigned order's for delivery partner",
    "Delivery completed order's",
    "Order's returned by customers",
    "Order's Cancelled by customers."
  ];
  final List<String> menuSubCount = [
    '30',
    '130',
    '47',
    '15',
    '5',
    '2',
    '10'
  ];

  final List<String> menuSubIcons = [
    objConstantAssest.newOrder,
    objConstantAssest.confirmedOrder,
    objConstantAssest.packedOrder,
    objConstantAssest.deliveryCar,
    objConstantAssest.completedOrder,
    objConstantAssest.returnedOrder,
    objConstantAssest.cancelledOrder,
  ];


  @override
  Widget build(BuildContext context) {
    var dashboardScreenState = ref.watch(DashboardScreenStateProvider);
    var dashboardScreenNotifier = ref.watch(
        DashboardScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent, // removed solid background
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 45.dp),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.dp,),

                  Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'Hi, Vikas',
                        20,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),

                      Spacer(),

                      CupertinoButton(
                          padding: EdgeInsets.zero, child: Image.asset(
                        objConstantAssest.menuIcon,
                        height: 25.dp,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ), onPressed: () {
                        mainScaffoldKey.currentState?.openDrawer();
                      })


                    ],
                  ),

                  SizedBox(height: 10.dp,),

                  CupertinoButton(
                    onPressed: () {
                      userScreenNotifier.callNavigation(ScreenName.delivery);
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10.dp),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.40),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.dp,
                                horizontal: 10.dp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.dp,),
                                objCommonWidgets.customText(context,
                                    'Delivery', 20,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold),
                                objCommonWidgets.customText(context,
                                    'Monday, 10/12/2025', 13,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold),
                                SizedBox(height: 25.dp,),
                                Row(
                                  children: [
                                    objCommonWidgets.customText(context,
                                        'Count :', 15,
                                        objConstantColor.white,
                                        objConstantFonts.montserratSemiBold),
                                    SizedBox(width: 5.dp,),
                                    objCommonWidgets.customText(context,
                                        '25', 22,
                                        objConstantColor.yellow,
                                        objConstantFonts.montserratSemiBold),
                                    Spacer(),

                                  ],
                                ),
                              ],
                            ),
                          ),

                          Positioned(bottom: 10.dp,
                              right: 10.dp,
                              child: Image.asset(objConstantAssest.motorbike,
                                color: Colors.white.withAlpha(75),
                                width: 55.dp,))
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25.dp,),

                  objCommonWidgets.customText(
                    context,
                    'Orders',
                    18,
                    objConstantColor.white,
                    objConstantFonts.montserratSemiBold,
                  ),

                  SizedBox(height: 5.dp,),
                  GridView.builder(
                    shrinkWrap: true,
                    // FIX
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: menuList.length,
                    itemBuilder: (context, index) {
                      return buildMenuCard(context, index, () {
                        dashboardScreenNotifier.callSubModuleScreenNavigation(index, userScreenNotifier);
                      });
                    },
                  ),

                  SizedBox(height: 30.dp,),

                  objCommonWidgets.customText(
                    context,
                    'Partners',
                    18,
                    objConstantColor.white,
                    objConstantFonts.montserratSemiBold,
                  ),

                  SizedBox(height: 5.dp,),

                  Row(
                    children: [
                      partnerCard(context, 'Business\nContracts', '15',
                          objConstantAssest.sellerPartner,
                          'Signed contracts list', () {
                            userScreenNotifier.callNavigation(
                                ScreenName.contracts);
                          }),
                      SizedBox(width: 10.dp),
                      partnerCard(context, 'Delivery\nPartners', '8',
                          objConstantAssest.deliveryBoy,
                          'Delivery partners list', () {
                            userScreenNotifier.callNavigation(
                                ScreenName.deliveryPartner);
                          }),

                    ],
                  ),


                  SizedBox(height: 30.dp,),

                  objCommonWidgets.customText(
                    context,
                    'Customers',
                    18,
                    objConstantColor.white,
                    objConstantFonts.montserratSemiBold,
                  ),

                  SizedBox(height: 5.dp,),

                  CupertinoButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        // frosted glass effect
                        borderRadius: BorderRadius.circular(12.dp),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.dp,
                                horizontal: 10.dp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.dp,),
                                objCommonWidgets.customText(context,
                                    'Total Customers', 18,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold),
                                SizedBox(height: 35.dp,),
                                Row(
                                  children: [
                                    objCommonWidgets.customText(context,
                                        'Count :', 15,
                                        objConstantColor.white,
                                        objConstantFonts.montserratSemiBold),
                                    SizedBox(width: 5.dp,),
                                    objCommonWidgets.customText(context,
                                        '178', 20,
                                        objConstantColor.yellow,
                                        objConstantFonts.montserratSemiBold),
                                    Spacer(),

                                  ],
                                ),
                              ],
                            ),
                          ),

                          Positioned(bottom: 10.dp,
                              right: 10.dp,
                              child: Image.asset(objConstantAssest.customer,
                                color: Colors.white.withAlpha(75),
                                width: 55.dp,))
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          )
      ),
    );
  }


  ///Menu Card....
  Widget buildMenuCard(BuildContext context, int index, VoidCallback onTap) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12.dp),
          child: Stack(
            children: [
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    // frosted glass effect
                    borderRadius: BorderRadius.circular(12.dp),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.30),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.dp, top: 10.dp, right: 10.dp, bottom: 10.dp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 5.dp,),

                        objCommonWidgets.customText(
                          context,
                          menuList[index],
                          15,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),

                        SizedBox(height: 5.dp,),

                        objCommonWidgets.customText(
                          context,
                          menuSubList[index],
                          11.5,
                          Colors.white.withAlpha(180),
                          objConstantFonts.montserratMedium,
                        ),

                        Spacer(),

                        /*MultiColorProgressBar(
                         totalTasks: 100,
                         completedTasks: 20*(index +1 ),
                       ),

                       SizedBox(height: 5.dp,),*/


                        Row(
                          children: [
                            objCommonWidgets.customText(
                              context,
                              menuSubCount[index],
                              20,
                              objConstantColor.yellow,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              ),

              Positioned(bottom: 10.dp,
                  right: 10.dp,
                  child: Image.asset(menuSubIcons[index],
                    color: Colors.white.withAlpha(75),
                    width: 55.dp,))
            ],
          )
      ),
    );
  }

  Widget partnerCard(BuildContext context, String title, String count,
      String image, String subTitle, VoidCallback onTap) {
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // frosted glass effect
            borderRadius: BorderRadius.circular(10.dp),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 5.dp, horizontal: 10.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.dp,),
                    objCommonWidgets.customText(context,
                        title, 15,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold),

                    SizedBox(height: 5.dp,),

                    objCommonWidgets.customText(
                      context,
                      subTitle,
                      11.5,
                      Colors.white.withAlpha(180),
                      objConstantFonts.montserratMedium,
                    ),

                    SizedBox(height: 50.dp,),

                    objCommonWidgets.customText(context,
                        count, 20,
                        objConstantColor.yellow,
                        objConstantFonts.montserratSemiBold),

                  ],
                ),
              ),

              Positioned(bottom: 10.dp,
                  right: 10.dp,
                  child: Image.asset(image,
                    color: Colors.white.withAlpha(75),
                    width: 55.dp,))
            ],
          ),
        ),
      ),
    );
  }


}


