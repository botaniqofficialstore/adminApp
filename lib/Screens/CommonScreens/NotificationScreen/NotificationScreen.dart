import 'dart:math' as math;
import 'dart:ui';
import 'package:botaniq_admin/Constants/Constants.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import '../../AdminScreens/InnerScreens/MainScreen/MainScreen.dart';
import '../../SellerScreens/SellerMainScreen/SellerMainScreen.dart';
import 'NotificationScreenState.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dashboardScreenState = ref.watch(NotificationScreenStateProvider);
    var dashboardScreenNotifier = ref.watch(NotificationScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: (currentUser == UserRole.admin) ?
          Colors.transparent : const Color(0xFFF4F4F4),
          body: CustomMaterialIndicator(
            onRefresh: () async {}, // Your refresh logic
            backgroundColor: Colors.white,
            indicatorBuilder: (context, controller) {
              return Padding(
                padding: EdgeInsets.all(6.dp),
                child: CircularProgressIndicator(
                  color: Colors.black,
                  value: controller.state.isLoading ? null : math.min(controller.value, 1.0),
                ),
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 5.dp),
                  child: Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'Notification',
                        23, currentUser == UserRole.admin ?
                        objConstantColor.white : Colors.black,
                        objConstantFonts.montserratSemiBold,
                      ),
                      Spacer(),

                      if (currentUser == UserRole.admin)...{
                        CupertinoButton(
                            padding: EdgeInsets.zero, child: Image.asset(
                          objConstantAssest.menuIcon,
                          height: 25.dp,
                          color: Colors.white,
                          colorBlendMode: BlendMode.srcIn,
                        ), onPressed: () {
                          mainScaffoldKey.currentState?.openDrawer();
                        })
                      } else ...{
                        CupertinoButton(
                          onPressed: (){
                            mainSellerScaffoldKey.currentState?.openDrawer();
                          },
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.all(10.dp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.dp),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: const Icon(
                                Icons.notes_rounded, color: Color(0xFF1A1A1B)),
                          ),
                        ),
                      }


                    ],
                  ),
                ),

                SizedBox(height: 10.dp,),

                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: (currentUser == UserRole.admin) ?  15.dp : 10.dp),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom:
                            (currentUser == UserRole.admin) ? 15.dp : 7.5.dp),
                            child: Dismissible(
                              key: Key(index.toString()),

                              // 💡 Enable swipe left + right
                              direction: DismissDirection.horizontal,

                              // 👉 Swipe Right → Mark as Read
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: (currentUser == UserRole.admin) ? 20.dp : 10.dp),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular((currentUser == UserRole.admin) ?
                                  10.dp : 15.dp),
                                ),
                                child: objCommonWidgets.customText(
                                  context,
                                  'Mark as read',
                                  15,
                                  objConstantColor.white,
                                  objConstantFonts.montserratSemiBold,
                                ),
                              ),

                              // 👉 Swipe Left → Delete
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: (currentUser == UserRole.admin) ? 20.dp : 5.dp),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular((currentUser == UserRole.admin) ?
                                  10.dp : 15.dp),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    objCommonWidgets.customText(
                                      context,
                                      'Delete',
                                      15,
                                      objConstantColor.white,
                                      objConstantFonts.montserratSemiBold,
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.delete, color: Colors.white, size: 25.dp,),
                                  ],
                                ),
                              ),

                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  // Swipe Right -> Mark as Read
                                  print("Marked as read: $index");
                                  return false; // keep item
                                } else if (direction == DismissDirection.endToStart) {
                                  // Swipe Left -> Delete
                                  print("Deleted: $index");
                                  return true; // delete item
                                }
                                return false;
                              },

                              child: notificationCard(context),
                            )
                          );
                        },
                      ),
                    ),
                  ),
                )


              ],
            ),
          )

        ),
      ),
    );
  }

  Widget notificationCard(BuildContext context){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {  },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: currentUser == UserRole.admin ?
          Colors.white.withOpacity(0.15) : Colors.white, // frosted glass effect
          borderRadius: BorderRadius.circular((currentUser == UserRole.admin) ? 10.dp : 15),
          border: Border.all(
            color: Colors.white.withOpacity(0.30),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 5,
              offset: const Offset(1, 2),
            ),
          ],

        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.dp,
              horizontal: currentUser == UserRole.admin ? 10.dp : 15.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  objCommonWidgets.customText(context,
                      'New Order', 15,
                      currentUser == UserRole.admin ?
                      objConstantColor.white : Colors.black,
                      objConstantFonts.montserratSemiBold),
                  Spacer(),
                  objCommonWidgets.customText(context,
                      '04 Dec 2025, 7:45 PM', 10,
                      currentUser == UserRole.admin ?
                      objConstantColor.white : Colors.black.withAlpha(95),
                      objConstantFonts.montserratSemiBold),
                ],
              ),

              SizedBox(height: 10.dp,),

              objCommonWidgets.customText(context,
                  'You have a new order for Rs.179/_ with OrderID: 87845124478 ',
                  12,
                  currentUser == UserRole.admin ?
                  Colors.white70 : Colors.black.withAlpha(200) ,
                  objConstantFonts.montserratMedium),

            ],
          ),
        ),
      ),
    );
  }

}