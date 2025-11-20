import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../constants/ConstantVariables.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../../../CommonViews/CommonWidget.dart';
import '../../../Utility/PreferencesManager.dart';
import 'LoginScreenState.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(loginInterceptor);
  }


  @override
  void dispose() {
    BackButtonInterceptor.remove(loginInterceptor);
    super.dispose();
  }


  //MARK: - METHODS
  /// Return true to prevent default behavior (app exit)
  /// Return false to allow default behavior
  bool loginInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (kDebugMode) {
      print("Back button intercepted!");
    }
    PreferencesManager.getInstance().then((prefs) {
      if (prefs.getBooleanValue(PreferenceKeys.isDialogOpened) == true) {
        return false;
      } else if ((prefs.getBooleanValue(PreferenceKeys.isLoadingBarStarted) ==
          true)) {
        return true;
      } else {
        return false;
      }
    });
    return true;
  }


  //MARK: - Widget
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: objConstantColor.navyBlue,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // important
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(),
                        // LOGO
                        Padding(
                          padding: EdgeInsets.only(top: 35.dp),
                          child: Center(
                            child: Image.asset(
                              objConstantAssest.logo,
                              width: 200.dp,
                              height: 90.dp,
                            ),
                          ),
                        ),

                        const Spacer(),
                        const Spacer(),
                        const Spacer(),
                        // White Bottom Section
                        loginBottomContainer(context),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget loginBottomContainer(BuildContext context) {
    final loginState = ref.watch(loginScreenProvider);
    final loginNotifier = ref.read(loginScreenProvider.notifier);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.dp),
          topRight: Radius.circular(35.dp),
        ),
      ),
      padding: EdgeInsets.fromLTRB(25.dp, 20.dp, 25.dp, MediaQuery.of(context).viewInsets.bottom + 5.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.dp),
            child: Center(
              child: objCommonWidgets.customText(
                context,
                'Admin Login',
                28,
                objConstantColor.navyBlue,
                objConstantFonts.montserratBold,
              ),
            ),
          ),

          SizedBox(height: 15.dp),

          objCommonWidgets.customText(
            context,
            'Email/Mobile Number',
            15,
            objConstantColor.navyBlue,
            objConstantFonts.montserratSemiBold,
          ),

          SizedBox(height: 2.dp),

          CommonTextField(
            controller: loginState.userNameController,
            placeholder: "Enter your Email/Mobile Number",
            textSize: 13,
            fontFamily: objConstantFonts.montserratMedium,
            textColor: objConstantColor.navyBlue,
            isNumber: false,
            onChanged: (value) {},
          ),

          SizedBox(height: 10.dp),

          objCommonWidgets.customText(
            context,
            'Password',
            15,
            objConstantColor.navyBlue,
            objConstantFonts.montserratSemiBold,
          ),

          SizedBox(height: 2.dp),

          CommonTextField(
            controller: loginState.passwordController,
            placeholder: "Enter your password",
            textSize: 13,
            fontFamily: objConstantFonts.montserratMedium,
            textColor: objConstantColor.navyBlue,
            isNumber: false,
            isPassword: true,
            onChanged: (value) {},
          ),

          Row(
            children: [
              const Spacer(),
              CupertinoButton(padding: EdgeInsets.zero,
                  child: objCommonWidgets.customText(context,
                      'Forgot Password?',
                      12,
                      objConstantColor.orange,
                      objConstantFonts.montserratSemiBold
                  ),
                  onPressed: (){
                    showForgotPasswordSheet(context, loginState, loginNotifier);
                  }),
            ],
          ),

          SizedBox(height: 20.dp),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 15.dp),
              color: objConstantColor.orange,
              borderRadius: BorderRadius.circular(12.dp),
              onPressed: () {
                loginNotifier.checkLoginFieldValidation(context);
              },
              child: objCommonWidgets.customText(
                context,
                'Login',
                18,
                objConstantColor.white,
                objConstantFonts.montserratSemiBold,
              ),
            ),
          ),

          SizedBox(height: 25.dp),
        ],
      ),
    );
  }




  void showForgotPasswordSheet(BuildContext context, LoginScreenGlobalState loginState, LoginScreenGlobalStateNotifier loginNotifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 25.dp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.dp),
                topRight: Radius.circular(30.dp),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ------------------ Top Handle ------------------
                Center(
                  child: Container(
                    width: 50.dp,
                    height: 5.dp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10.dp),
                    ),
                  ),
                ),

                SizedBox(height: 20.dp),

                // ------------------ Title ------------------
                Center(
                  child: objCommonWidgets.customText(
                    context,
                    "Get OTP",
                    20,
                    objConstantColor.navyBlue,
                    objConstantFonts.montserratBold,
                  ),
                ),

                SizedBox(height: 15.dp),

                Center(
                  child: objCommonWidgets.customText(
                    context,
                    "Enter your registered email to get OTP",
                    15,
                    objConstantColor.navyBlue,
                    objConstantFonts.montserratSemiBold,
                  ),
                ),

                SizedBox(height: 15.dp),

                objCommonWidgets.customText(
                  context,
                  'Email',
                  15,
                  objConstantColor.navyBlue,
                  objConstantFonts.montserratSemiBold,
                ),

                SizedBox(height: 2.dp),

                CommonTextField(
                  controller: loginState.emailController,
                  placeholder: "Enter your Email",
                  textSize: 13,
                  fontFamily: objConstantFonts.montserratMedium,
                  textColor: objConstantColor.navyBlue,
                  isNumber: false,
                  onChanged: (value) {},
                ),

                SizedBox(height: 25.dp),

                // ------------------ OTP Button ------------------
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 15.dp),
                    color: objConstantColor.orange,
                    borderRadius: BorderRadius.circular(12.dp),
                    onPressed: () {

                      loginNotifier.callForgotPasswordAPI(context);
                    },
                    child: objCommonWidgets.customText(
                      context,
                      "Send OTP",
                      17,
                      Colors.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                  ),
                ),

                SizedBox(height: 30.dp),
              ],
            ),
          ),
        );
      },
    );
  }



}
