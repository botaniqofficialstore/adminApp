import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../../Constants/Constants.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'DeliveryPartnerScreenState.dart';

class DeliveryPartnerScreen extends ConsumerStatefulWidget {
  const DeliveryPartnerScreen({super.key});

  @override
  DeliveryPartnerScreenState createState() => DeliveryPartnerScreenState();
}

class DeliveryPartnerScreenState extends ConsumerState<DeliveryPartnerScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey filterKey = GlobalKey();
  OverlayEntry? filterOverlay;
  late AnimationController popupController;
  late Animation<double> popupAnimation;

  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
      userScreenNotifier.showFooter();
    });

    popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    popupAnimation = CurvedAnimation(
      parent: popupController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deliveryPartnerScreenState = ref.watch(DeliveryPartnerScreenStateProvider);
    var deliveryPartnerScreenNotifier = ref.watch(DeliveryPartnerScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dp),
              child: Column(
                children: [
                  SizedBox(height: 5.dp,),

                  Row(
                    children: [
                      CupertinoButton(
                          minimumSize: Size(0, 0),
                          padding: EdgeInsets.zero,
                          child: SizedBox(width: 20.dp,
                              child: Image.asset(objConstantAssest.backIcon,
                                color: objConstantColor.white,)),
                          onPressed: () {
                            var userScreenNotifier = ref.watch(
                                MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callHomeNavigation();
                          }),
                      SizedBox(width: 2.5.dp),
                      objCommonWidgets.customText(
                        context,
                        'Delivery Partner',
                        18,
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

                  CommonTextField(
                    controller: deliveryPartnerScreenState.searchController,
                    placeholder: "Search by name...",
                    textSize: 15,
                    fontFamily: objConstantFonts.montserratMedium,
                    textColor: objConstantColor.white,
                    isNumber: false,
                    isDarkView: true,
                    isShowIcon: true,
                    onChanged: (value) {

                    },
                  ),

                  SizedBox(height: 15.dp,),

                  Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'List',
                        20,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                      Spacer(),

                      CupertinoButton(padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 7.dp),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(5.dp),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                )
                            ),
                            child: Row(
                              children: [
                                objCommonWidgets.customText(context, 'New Delivery Partner', 10, objConstantColor.white, objConstantFonts.montserratSemiBold),
                                SizedBox(width: 5.dp,),
                                Image.asset(objConstantAssest.plusIcon,
                                  width: 12.dp, color: objConstantColor.white,),
                              ],
                            ),
                          ),
                          onPressed: (){
                            var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.callNavigation(ScreenName.addDeliveryPartner);
                          }
                      ),

                      SizedBox(width: 10.dp),

                      CupertinoButton(key: filterKey,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 7.dp),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(5.dp),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                )
                            ),
                            child: Row(
                              children: [
                                objCommonWidgets.customText(context, 'Status', 10, objConstantColor.white, objConstantFonts.montserratSemiBold),
                                SizedBox(width: 5.dp,),
                                Image.asset(objConstantAssest.filterIcon,
                                  width: 12.dp, color: objConstantColor.white,),
                              ],
                            ),
                          ),
                          onPressed: (){
                            showFilterPopup();
                          }
                      ),
                    ],
                  ),

                  SizedBox(height: 10.dp),

                  Expanded(child:
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index){

                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.dp),
                          child: cellView(
                              context,
                              'Arun Kumar',
                              '17/08/2000',
                              'Male',
                              'PSJ7845121',
                              'arunkumar25@gmail.com',
                              '+91 9845781204',
                              'Chendrathil house, Vadakkathar, Chuttur, Kerala, 678101 (P.O)',
                              '20/12/2025',
                              0
                          ),
                        );
                        }),
                  ))






                ],
              ),
            )

        ),
      ),
    );
  }


  Widget cellView(BuildContext context,
      String fullName, String dob,
      String gender, String licence,
      String email, String mobile,
      String address, String date,
      int status){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15.dp),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [

                    CircleAvatar(
                      radius: 18.dp,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 17.dp,
                        backgroundImage: AssetImage(objConstantAssest.profileImage),
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    SizedBox(width: 5.dp),

                    objCommonWidgets.customText(context,
                        fullName, 16,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold),
                    Spacer(),

                    CupertinoButton(padding: EdgeInsets.zero, child: Image.asset(
                      objConstantAssest.cardIcon,
                      width: 28.dp,
                      color: Colors.white,
                      colorBlendMode: BlendMode.srcIn,
                    ), onPressed: () {
                      CommonWidget().showFullScreenImageViewer(
                        context,
                        title: 'Driving Licence',
                        isDownloadable: true,
                        imageUrl: 'https://drive.google.com/uc?export=download&id=1cXPBw-ZXCG7KmWFuoJdXeAWSfmyZhfmP',
                        secondImage: 'https://drive.google.com/uc?export=view&id=1DJsYrr53x8jVzPB0WgHptuBxVXB7wsTt',
                      );
                    }),

                    SizedBox(width: 5.dp),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5.dp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.5.dp, horizontal: 6.dp),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 3.5.dp,
                              backgroundColor: status == 0 ? Colors.greenAccent : Colors.red,
                            ),
                            SizedBox(width: 5.dp),
                            objCommonWidgets.customText(context,
                                status == 0 ? 'Active' : 'Inactive', 10,
                                objConstantColor.white,
                                objConstantFonts.montserratMedium),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 5.dp),
                objCommonWidgets.customText(context, gender, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, dob, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, licence, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, mobile, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, email, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, address, 12.5, Colors.white70, objConstantFonts.montserratMedium),


              ],
            ),
          ),

          Positioned(bottom: 0.dp, right: 2.dp,child: CupertinoButton(padding: EdgeInsets.zero, child: Image.asset(objConstantAssest.editIcon, width: 16.dp, color: objConstantColor.white,), onPressed: (){}))
        ],
      ),
    );
  }


  void showFilterPopup() {
    if (filterOverlay != null) {
      hideFilterPopup();
      return;
    }

    final renderBox = filterKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    filterOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // tap outside to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: hideFilterPopup,
              ),
            ),

            Positioned(
                left: position.dx - -45,
                top: position.dy + size.height - 5,
                child: FilledTriangle(color: Colors.white, size: 10)

            ),

            // popup with shutter animation
            Positioned(
              left: position.dx - 40.dp,
              top: position.dy + size.height + 5,
              child: AnimatedBuilder(
                animation: popupAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    alignment: Alignment.topCenter,
                    scaleY: popupAnimation.value,  // shutter-style vertical opening
                    child: child,
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 100.dp,
                    height: 120.dp,
                    decoration: BoxDecoration(
                        color: Color(0xFF1E0033).withAlpha(475),
                        borderRadius: BorderRadius.circular(5.dp),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        filterItem("All", () {}),
                        Divider(color: objConstantColor.white.withAlpha(150), height: 0.1,),
                        filterItem("Active", showIcon: true, color: Colors.greenAccent, () {}),
                        Divider(color: objConstantColor.white.withAlpha(150), height: 0.5,),
                        filterItem("Inactive", showIcon: true, color: Colors.red, () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(filterOverlay!);

    // start shutter opening
    popupController.forward(from: 0);
  }


  void hideFilterPopup() {
    filterOverlay?.remove();
    filterOverlay = null;
  }

  Widget filterItem(String title, VoidCallback onTap, {bool showIcon = false, Color color = Colors.greenAccent}) {
    return CupertinoButton(
      onPressed: () {
        hideFilterPopup();
        onTap();
      },
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 100.dp,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.5.dp, horizontal: 10.dp),
            child: Row(
              children: [
                if (showIcon)
                  CircleAvatar(
                    radius: 3.5.dp,
                    backgroundColor: color,
                  ),
                SizedBox(width: 5.dp),
                objCommonWidgets.customText(context,
                    title,
                    12,
                    objConstantColor.white,
                    objConstantFonts.montserratMedium
                ),
                Spacer()
              ],
            )
        ),
      ),
    );
  }


}