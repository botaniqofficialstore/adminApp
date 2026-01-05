import 'dart:io';
import 'dart:ui';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerPackedOrderScreenState.dart';

class SellerPackedOrderScreen extends ConsumerWidget {
  const SellerPackedOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SellerPackedOrderScreenStateProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [

            /// ================= FIXED HEADER =================
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15.dp, vertical: 10.dp),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      ref.read(SellerMainScreenGlobalStateProvider.notifier)
                          .callNavigation(ScreenName.home);
                    },
                    child: Image.asset(
                      objConstantAssest.backIcon,
                      width: 20.dp,
                      color: objConstantColor.black,
                    ),
                  ),
                  SizedBox(width: 8.dp),
                  objCommonWidgets.customText(
                    context,
                    "Packed Order's",
                    16,
                    objConstantColor.black,
                    objConstantFonts.montserratSemiBold,
                  ),
                ],
              ),
            ),

            /// ================= SCROLLABLE CONTENT =================
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.dp),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.dp),
                        child:  _orderCard(context, ref),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            objConstantColor.orange,
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






  /// ================= ORDER CARD =================
  Widget _orderCard(BuildContext context, WidgetRef ref) {
    final state = ref.watch(SellerPackedOrderScreenStateProvider);

    return Container(
      padding: EdgeInsets.all(16.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ORDER INFO
          Row(
            children: [
              objCommonWidgets.customText(
                context,
                'Order ID:',
                14,
                objConstantColor.orange,
                objConstantFonts.montserratSemiBold,
              ),
              SizedBox(width: 5.dp),
              objCommonWidgets.customText(
                context,
                '578421015455',
                12,
                Colors.black,
                objConstantFonts.montserratSemiBold,
              ),
              const Spacer(),
              objCommonWidgets.customText(
                context,
                '₹249/_',
                18,
                Colors.black,
                objConstantFonts.montserratSemiBold,
              ),
            ],
          ),

          SizedBox(height: 10.dp),


          objCommonWidgets.customText(
            context,
            'Order Status',
            13,
            Colors.black,
            objConstantFonts.montserratSemiBold,
          ),

          orderTimeline(context),

          objCommonWidgets.customText(
            context,
            'Purchase List',
            13,
            Colors.black,
            objConstantFonts.montserratSemiBold,
          ),
          SizedBox(height: 5.dp),

          /// PRODUCT LIST (INSIDE SAME CONTAINER)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.packedList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          // ✅ 2 items per row
              crossAxisSpacing: 14.dp,
              mainAxisSpacing: 14.dp,
              childAspectRatio: 0.72,     // tweak for best card look
            ),
            itemBuilder: (context, index) =>
                _productGridItem(context, index),
          ),

          SizedBox(height: 20.dp),


          CupertinoButton(
            onPressed: () {
              CommonWidget().showFullScreenImageViewer(
                context,
                imageUrl:
                'https://drive.google.com/uc?export=view&id=1E6BJdw_VtaekKeY50Qd9vCy7_ul7f0uT',
                title: 'Package Image',
              );
            },
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.5.dp),
              decoration: BoxDecoration(
                color: objConstantColor.orange,
                borderRadius: BorderRadius.circular(22.dp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 18.5.dp, color: objConstantColor.white,),
                  SizedBox(width: 2.5.dp),
                  objCommonWidgets.customText(
                    context,
                    'View Package Photo',
                    12,
                    objConstantColor.white,
                    objConstantFonts.montserratSemiBold,
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }


  Widget orderTimeline(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.dp),
          child: EasyStepper(
            activeStep: 2, // 0-based index (Packed)
            direction: Axis.horizontal,
            stepRadius: 18,
            internalPadding: 25.dp,


            activeStepBorderColor: objConstantColor.orange,
            activeStepIconColor: Colors.white,
            activeStepBackgroundColor: objConstantColor.orange,

            finishedStepBackgroundColor:
            objConstantColor.orange.withOpacity(0.15),
            finishedStepIconColor: objConstantColor.orange,

            unreachedStepBackgroundColor:
            Colors.grey.withOpacity(0.15),
            unreachedStepIconColor: Colors.grey,

            showLoadingAnimation: false,
            showTitle: true,


            steps: [
              _easyStep(
                icon: Icons.shopping_cart,
                title: 'Ordered',
                subtitle: '08 Jun, 10:30 AM',
                context: context
              ),
              _easyStep(
                icon: Icons.check_circle_rounded,
                title: 'Confirmed',
                subtitle: '09 Jun, 12:05 PM',
                context: context
              ),
              _easyStep(
                icon: Icons.shopping_bag_rounded,
                title: 'Packed',
                subtitle: '10 Jun, 12:20 PM',
                context: context
              ),

            ],
          ),
        );
      },
    );
  }

  EasyStep _easyStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return EasyStep(
      icon: Icon(icon, size: 16.dp),
      title: title,
      customTitle: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          objCommonWidgets.customText(context,
              title, 11,
              Colors.black,
              objConstantFonts.montserratMedium),
          SizedBox(height: 2.dp),
          objCommonWidgets.customText(context,
              subtitle, 8,
              Colors.black45,
              objConstantFonts.montserratMedium),
        ],
      ),
    );
  }








}
