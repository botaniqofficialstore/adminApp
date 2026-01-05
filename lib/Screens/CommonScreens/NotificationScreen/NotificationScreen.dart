import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../../Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import '../../MainScreen/MainScreen.dart';
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
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
            child: Column(
              children: [
                SizedBox(height: 5.dp,),

                Row(
                  children: [
                    objCommonWidgets.customText(
                      context,
                      'Notification',
                      23,
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

                SizedBox(height: 10.dp,),

                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 25,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.dp),
                          child: Dismissible(
                            key: Key(index.toString()),

                            // 💡 Enable swipe left + right
                            direction: DismissDirection.horizontal,

                            // 👉 Swipe Right → Mark as Read
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10.dp),
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
                              padding: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.dp),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.dp),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // frosted glass effect
            borderRadius: BorderRadius.circular(10.dp),
            border: Border.all(
              color: Colors.white.withOpacity(0.30),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    objCommonWidgets.customText(context,
                        'New Order', 15,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold),
                    Spacer(),
                    objCommonWidgets.customText(context,
                        '04 Dec 2025, 7:45 PM', 10,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold),
                  ],
                ),

                SizedBox(height: 10.dp,),

                objCommonWidgets.customText(context,
                    'You have a new order for Rs.179/_ with OrderID: 87845124478 ',
                    12,
                    Colors.white70,
                    objConstantFonts.montserratMedium),

              ],
            ),
          ),
        ),
      ),
    );
  }

}