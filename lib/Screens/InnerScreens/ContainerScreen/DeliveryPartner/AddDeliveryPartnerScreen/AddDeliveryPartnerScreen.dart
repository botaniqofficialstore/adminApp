import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../CommonViews/CommonWidget.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'AddDeliveryPartnerScreenState.dart';

class AddDeliveryPartnerScreen extends ConsumerStatefulWidget {
  const AddDeliveryPartnerScreen({super.key});

  @override
  AddDeliveryPartnerScreenState createState() => AddDeliveryPartnerScreenState();
}

class AddDeliveryPartnerScreenState extends ConsumerState<AddDeliveryPartnerScreen>
    with SingleTickerProviderStateMixin {
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
    var deliveryPartnerScreenState = ref.watch(AddDeliveryPartnerScreenStateProvider);
    var deliveryPartnerScreenNotifier = ref.watch(AddDeliveryPartnerScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: 5.dp, top: 15.dp, right: 15.dp),
                  child: Row(
                    children: [
                      CupertinoButton(padding: EdgeInsets.zero, child: SizedBox(width: 25.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                          onPressed: (){
                            var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callNavigation(ScreenName.deliveryPartner);
                          }),
                      objCommonWidgets.customText(
                        context,
                        'Add Delivery Partner',
                        18,
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
                ),

                SizedBox(height: 10.dp,),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 20.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Personal Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'First Name', 'Enter your first name', deliveryPartnerScreenState.firstNameController),
                                  textFieldCard(context, 'Last Name', 'Enter your last name', deliveryPartnerScreenState.lastNameController),
                                  textFieldCard(context, 'Email', 'Enter your email', deliveryPartnerScreenState.emailController),
                                  textFieldCard(context, 'Aadhar', 'Enter your aadhar number', deliveryPartnerScreenState.aadharController, isNumber: true),
                                  mobileTextFieldCard(context, 'Mobile Number', deliveryPartnerScreenState.mobileController, 'Enter your mobile number'),

                                  SizedBox(height: 25.dp),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 31.dp,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 30.dp,
                                          backgroundImage: AssetImage(objConstantAssest.defaultProfileImage),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      SizedBox(width: 10.dp),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                          child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(20.dp),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                                        child: objCommonWidgets.customText(context, 'Upload Photo', 13, objConstantColor.white, objConstantFonts.montserratSemiBold),
                                      ), onPressed: (){})
                                    ],
                                  ),
                                  SizedBox(height: 10.dp),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Address Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Street', 'Enter your street', deliveryPartnerScreenState.streetController),
                                  textFieldCard(context, 'City', 'Enter your city', deliveryPartnerScreenState.cityController),
                                  textFieldCard(context, 'State', 'Enter your state', deliveryPartnerScreenState.stateController),
                                  textFieldCard(context, 'Country', 'Enter your country', deliveryPartnerScreenState.countryController),
                                  textFieldCard(context, 'Pincode', 'Enter your zipcode', deliveryPartnerScreenState.pincodeController, isNumber: true),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Driving Licence Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Licence', 'Enter your valid licence number', deliveryPartnerScreenState.pincodeController, isNumber: true),

                                  objCommonWidgets.customText(
                                    context,
                                    'Licence Front Side',
                                    14,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 2.dp),
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(10.dp),
                                        ),
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 20.dp),
                                          child: Image.asset(objConstantAssest.placeholderImage,
                                            color: objConstantColor.white,
                                            height: 100.dp,
                                            width: 80.dp,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),

                                      Positioned(bottom: 10.dp, right: 10.dp, child: CupertinoButton(padding: EdgeInsets.zero,
                                          child: Image.asset(objConstantAssest.plusIcon,
                                              width: 20.dp,
                                              height: 20.dp,
                                              color: objConstantColor.white), onPressed: (){}))
                                    ],
                                  ),

                                  SizedBox(height: 15.dp),

                                  objCommonWidgets.customText(
                                    context,
                                    'Licence Back Side',
                                    14,
                                    objConstantColor.white,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 2.dp),
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(10.dp),
                                        ),
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 20.dp),
                                          child: Image.asset(objConstantAssest.placeholderImage,
                                            color: objConstantColor.white,
                                            height: 100.dp,
                                            width: 80.dp,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),

                                      Positioned(bottom: 10.dp, right: 10.dp, child: CupertinoButton(padding: EdgeInsets.zero,
                                          child: Image.asset(objConstantAssest.plusIcon,
                                              width: 20.dp,
                                              height: 20.dp,
                                              color: objConstantColor.white), onPressed: (){}))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),



                          CupertinoButton(
                              padding: EdgeInsets.zero,child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: objConstantColor.yellow,//.withOpacity(0.15), // frosted glass effect
                              borderRadius: BorderRadius.circular(20.dp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 13.dp),
                              child: Center(
                                child: objCommonWidgets.customText(
                                  context,
                                  'Confirm',
                                  18,
                                  objConstantColor.navyBlue,
                                  objConstantFonts.montserratSemiBold,
                                ),
                              ),
                            ),
                          ), onPressed: (){}),
                          SizedBox(height: 35.dp,),

                        ],
                      ),
                    ),
                  ),
                )


              ],
            )
        ),
      ),
    );
  }

  Widget textFieldCard(BuildContext context, String title, String placeHolder, TextEditingController controller, {bool isNumber = false}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          title,
          14,
          objConstantColor.white,
          objConstantFonts.montserratSemiBold,
        ),
        CommonTextField(
          placeholder: placeHolder,
          controller: controller,
          textSize: 15,
          fontFamily: objConstantFonts.montserratMedium,
          textColor: objConstantColor.white,
          isNumber: isNumber,
          isDarkView: true,
        ),
        SizedBox(height: 10.dp,)
      ],
    );
  }

  Widget mobileTextFieldCard(BuildContext context, String title, TextEditingController textField, String placeholder){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            title,
            15,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // frosted glass effect
                  borderRadius: BorderRadius.circular(7.dp),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 7.5.dp),
                  child: objCommonWidgets.customText(
                    context,
                    '+91',
                    15,
                    objConstantColor.white,
                    objConstantFonts.montserratMedium,
                  ),
                ),
              ),

              SizedBox(width: 5.dp,),

              Expanded(
                child: CommonTextField(
                  controller: textField,
                  placeholder: placeholder,
                  textSize: 15,
                  fontFamily: objConstantFonts.montserratMedium,
                  textColor: objConstantColor.white,
                  isNumber: true, // alphabetic
                  isDarkView: true,
                  onChanged: (value) {

                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}