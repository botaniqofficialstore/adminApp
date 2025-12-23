import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CommonViews/CommonWidget.dart';
import '../../../../Authentication/ChangePasswordScreen/CreatePasswordScreen.dart';
import '../../MainScreen/MainScreen.dart';
import 'ChangePasswordScreenState.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode _passwordFocusNode;
  String _currentPassword = "";

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {}); // refresh UI when focus changes
    });

  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
  }

  bool _isPasswordValid(String password) {
    // define password rules
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    return hasUpper && hasLower && hasDigit && hasSpecial && hasMinLength;
  }

  @override
  Widget build(BuildContext context) {
    var changePasswordScreenState = ref.watch(ChangePasswordScreenStateProvider);
    var changePasswordScreenNotifier = ref.watch(ChangePasswordScreenStateProvider.notifier);

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
                        'Change Password',
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

                  SizedBox(height: 30.dp,),

                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(
                          context,
                          'New Password',
                          15,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                        SizedBox(height: 2.dp),
                        CommonTextField(
                          focusNode: _passwordFocusNode,
                          controller: changePasswordScreenState.passwordController,
                          placeholder: "Enter your new password",
                          textSize: 15,
                          fontFamily: objConstantFonts.montserratMedium,
                          textColor: objConstantColor.white,
                          isNumber: false,
                          isDarkView: true,
                          isPassword: true,
                          onChanged: (value) {
                            setState(() => _currentPassword = value);
                          },
                        ),


                        if (_passwordFocusNode.hasFocus &&
                            !_isPasswordValid(_currentPassword))...{
                          SizedBox(height: 5.dp),
                          PasswordHintBubble(
                            password: changePasswordScreenState.passwordController.text,
                            borderRadius: 14.0,
                            borderColor: Colors.grey.shade400,
                            backgroundColor: Colors.grey.shade200,
                            hints: const [
                              'At least 8 characters long',
                              'Include at least one lowercase letter',
                              'Include at least one uppercase letter',
                              'Include numbers (0-9)',
                              'Include a special character (e.g. !@#\$%)',
                            ],
                          ),},


                        SizedBox(height: 10.dp),

                        objCommonWidgets.customText(
                          context,
                          'Confirm Password',
                          15,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                        SizedBox(height: 2.dp),
                        CommonTextField(
                          controller: changePasswordScreenState.confirmPasswordController,
                          placeholder: "Enter your confirm password",
                          textSize: 15,
                          fontFamily: objConstantFonts.montserratMedium,
                          textColor: objConstantColor.white,
                          isNumber: false,
                          isDarkView: true,
                          isPassword: true,
                          onChanged: (value) {},
                        ),


                        SizedBox(height: 25.dp),
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: EdgeInsets.symmetric(vertical: 15.dp),
                            color: objConstantColor.yellow,
                            borderRadius: BorderRadius.circular(12.dp),
                            onPressed: () {
                              changePasswordScreenNotifier.checkTextFieldValidation(context);
                            },
                            child: objCommonWidgets.customText(
                              context,
                              'Confirm',
                              18,
                              objConstantColor.navyBlue,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )

        ),
      ),
    );
  }


}