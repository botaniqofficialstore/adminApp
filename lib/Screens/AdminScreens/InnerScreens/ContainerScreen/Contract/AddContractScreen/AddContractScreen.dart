import 'dart:ui';
import 'package:botaniq_admin/CommonViews/CommonWidget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../../Constants/Constants.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'AddContractScreenState.dart';

class AddContractScreen extends ConsumerStatefulWidget {
  const AddContractScreen({super.key});

  @override
  AddContractScreenState createState() => AddContractScreenState();
}

class AddContractScreenState extends ConsumerState<AddContractScreen>
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
    var contractScreenState = ref.watch(AddContractScreenStateProvider);
    var contractScreenNotifier = ref.watch(AddContractScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: 5.dp, right: 15.dp),
                  child: Row(
                    children: [
                      CupertinoButton(padding: EdgeInsets.zero, child: SizedBox(width: 25.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                          onPressed: (){
                            var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callNavigation(ScreenName.contracts);
                          }),
                      objCommonWidgets.customText(
                        context,
                        'New Contracts',
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
                      padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.dp),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Company Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Company', 'Enter company name', contractScreenState.companyNameController),
                                  textFieldCard(context, 'First Name', 'Enter your first name', contractScreenState.firstNameController),
                                  textFieldCard(context, 'Last Name', 'Enter your last name', contractScreenState.lastNameController),
                                  textFieldCard(context, 'Licence No.', 'Enter your company licence', contractScreenState.licenceController),
                                  textFieldCard(context, 'GST No.', 'Enter your GST number', contractScreenState.gstNumberController),
                                ],
                              ),
                            ),
                          ),


                          SizedBox(height: 35.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Location Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Street', 'Enter your street', contractScreenState.streetController),
                                  textFieldCard(context, 'City', 'Enter your city', contractScreenState.cityController),
                                  textFieldCard(context, 'State', 'Enter your state', contractScreenState.stateController),
                                  textFieldCard(context, 'Pincode', 'Enter your pincode', contractScreenState.pincodeController, isNumber: true),
                                  textFieldCard(context, 'Country', 'Enter your country', contractScreenState.cityController),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objCommonWidgets.customText(
                                    context,
                                    'Contact Details',
                                    18,
                                    objConstantColor.yellow,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                  SizedBox(height: 15.dp),
                                  textFieldCard(context, 'Email', 'Enter your email', contractScreenState.emailController),
                                  mobileTextFieldCard(context, 'Mobile Number', contractScreenState.mobileController, 'Enter your mobile number')
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 35.dp,),

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