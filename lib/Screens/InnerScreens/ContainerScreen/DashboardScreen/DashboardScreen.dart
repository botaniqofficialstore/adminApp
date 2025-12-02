import 'dart:ui';
import 'package:botaniq_admin/Constants/Constants.dart';
import 'package:botaniq_admin/Screens/InnerScreens/ContainerScreen/DashboardScreen/DashboardScreenState.dart';
import 'package:botaniq_admin/Screens/InnerScreens/MainScreen/MainScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Utility/MultiColorProgressBar.dart';
import '../../MainScreen/MainScreenState.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> menuList = ['New Orders', 'Confirmed Orders', 'Delivery For Tomorrow', 'Cancelled Orders'];
  final List<String> menuSubList = ['Fresh Orders not confirmed yet.',
  "Order's confirmed by you.", "Scheduled deliveries for tomorrow.", "Order's Cancelled by customers."];
  final List<String> menuSubCount = ['30', '130', '47', '5'];

  @override
  Widget build(BuildContext context) {
    var dashboardScreenState = ref.watch(DashboardScreenStateProvider);
    var dashboardScreenNotifier = ref.watch(DashboardScreenStateProvider.notifier);
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
                      30,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),

                    Spacer(),

                    CupertinoButton(padding: EdgeInsets.zero, child: Image.asset(
                      objConstantAssest.menuIcon,
                      height: 25.dp,
                      color: Colors.white,
                      colorBlendMode: BlendMode.srcIn,
                    ), onPressed: (){
                      mainScaffoldKey.currentState?.openDrawer();
                    })


                  ],
                ),

                SizedBox(height: 25.dp,),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10.dp),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.40),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.dp,),
                        objCommonWidgets.customText(context,
                            'Delivery', 23,
                            objConstantColor.white,
                            objConstantFonts.montserratSemiBold),
                        objCommonWidgets.customText(context,
                            'Monday, 10/12/2025', 15,
                            objConstantColor.white,
                            objConstantFonts.montserratSemiBold),
                        SizedBox(height: 25.dp,),
                        Row(
                          children: [
                            objCommonWidgets.customText(context,
                                'Count :', 18,
                                objConstantColor.white,
                                objConstantFonts.montserratSemiBold),
                            SizedBox(width: 5.dp,),
                            objCommonWidgets.customText(context,
                                '25', 25,
                                objConstantColor.yellow,
                                objConstantFonts.montserratSemiBold),
                            Spacer(),
                            CupertinoButton(padding: EdgeInsets.zero, child: Container(decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15), // frosted glass effect
                              borderRadius: BorderRadius.circular(5.dp),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 5.dp),
                              child: objCommonWidgets.customText(context,
                                  'View List', 12,
                                  objConstantColor.white,
                                  objConstantFonts.montserratSemiBold),
                            ),), onPressed: (){})
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30.dp,),

                objCommonWidgets.customText(
                  context,
                  'Orders',
                  23,
                  objConstantColor.white,
                  objConstantFonts.montserratSemiBold,
                ),

                SizedBox(height: 5.dp,),
                GridView.builder(
                  shrinkWrap: true,                              // FIX
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: menuList.length,
                  itemBuilder: (context, index) {
                    return buildMenuCard(context, index);
                  },
                ),

                SizedBox(height: 40.dp,),

                objCommonWidgets.customText(
                  context,
                  'Partners',
                  23,
                  objConstantColor.white,
                  objConstantFonts.montserratSemiBold,
                ),

                SizedBox(height: 5.dp,),

                Row(
                  children: [
                    partnerCard(context, 'Business Partners', '15', ScreenName.contracts),
                    SizedBox(width: 15.dp),
                    partnerCard(context, 'Delivery Partners', '8', ScreenName.deliveryPartner),

                  ],
                ),


                SizedBox(height: 30.dp,),

                objCommonWidgets.customText(
                  context,
                  'Customers',
                  23,
                  objConstantColor.white,
                  objConstantFonts.montserratSemiBold,
                ),

                SizedBox(height: 5.dp,),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10.dp),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15), // frosted glass effect
                      borderRadius: BorderRadius.circular(20.dp),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.dp,),
                          objCommonWidgets.customText(context,
                              'Total Customers', 20,
                              objConstantColor.white,
                              objConstantFonts.montserratSemiBold),
                          SizedBox(height: 25.dp,),
                          Row(
                            children: [
                              objCommonWidgets.customText(context,
                                  'Count :', 18,
                                  objConstantColor.white,
                                  objConstantFonts.montserratSemiBold),
                              SizedBox(width: 5.dp,),
                              objCommonWidgets.customText(context,
                                  '178', 25,
                                  objConstantColor.yellow,
                                  objConstantFonts.montserratSemiBold),
                              Spacer(),
                              CupertinoButton(padding: EdgeInsets.zero, child: Container(decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15), // frosted glass effect
                                borderRadius: BorderRadius.circular(5.dp),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                  width: 1,
                                ),
                              ), child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 5.dp),
                                child: objCommonWidgets.customText(context,
                                    'View List', 12,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold),
                              ),), onPressed: (){})
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
      ),
    );
  }


  ///Menu Card....
 Widget buildMenuCard(BuildContext context, int index) {
   return ClipRRect(
       borderRadius: BorderRadius.circular(10.dp),
       child: Container(
           width: double.infinity,
           decoration: BoxDecoration(
             color: Colors.white.withOpacity(0.15),
             // frosted glass effect
             borderRadius: BorderRadius.circular(20.dp),
             border: Border.all(
               color: Colors.white.withOpacity(0.30),
               width: 1,
             ),
           ),
           child: Padding(
             padding: EdgeInsets.only(left: 10.dp, top: 10.dp, right: 10.dp, bottom: 5.dp),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 objCommonWidgets.customText(
                   context,
                   menuList[index],
                   18,
                   objConstantColor.white,
                   objConstantFonts.montserratSemiBold,
                 ),

                 SizedBox(height: 5.dp,),

                 objCommonWidgets.customText(
                   context,
                   menuSubList[index],
                   11.5,
                   Colors.white70,
                   objConstantFonts.montserratMedium,
                 ),

                 Spacer(),

                 MultiColorProgressBar(
                   totalTasks: 100,
                   completedTasks: 20*(index +1 ),
                 ),

                 SizedBox(height: 5.dp,),




                 Row(
                   children: [

                     objCommonWidgets.customText(
                       context,
                       menuSubCount[index],
                       25,
                       objConstantColor.yellow,
                       objConstantFonts.montserratSemiBold,
                     ),

                     Spacer(),
                     CupertinoButton(padding: EdgeInsets.zero, child: Container(decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.15), // frosted glass effect
                       borderRadius: BorderRadius.circular(5.dp),
                       border: Border.all(
                         color: Colors.white.withOpacity(0.15),
                         width: 1,
                       ),
                     ),child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 5.dp),
                       child: objCommonWidgets.customText(context,
                           'View List', 12,
                           objConstantColor.white,
                           objConstantFonts.montserratSemiBold),
                     ),), onPressed: (){})
                   ],
                 )
               ],
             ),
           )
       )
   );
 }

 Widget partnerCard(BuildContext context, String title, String count, ScreenName screen){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15), // frosted glass effect
          borderRadius: BorderRadius.circular(20.dp),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.dp,),
              objCommonWidgets.customText(context,
                  title, 18,
                  objConstantColor.white,
                  objConstantFonts.montserratSemiBold),
              SizedBox(height: 25.dp,),
              Row(
                children: [
                  objCommonWidgets.customText(context,
                      count, 25,
                      objConstantColor.yellow,
                      objConstantFonts.montserratSemiBold),
                  Spacer(),
                  CupertinoButton(padding: EdgeInsets.zero, child: Container(decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15), // frosted glass effect
                    borderRadius: BorderRadius.circular(5.dp),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 5.dp),
                    child: objCommonWidgets.customText(context,
                        'View List', 12,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold),
                  ),), onPressed: (){
                    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                    userScreenNotifier.callNavigation(screen);
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
 }



}


