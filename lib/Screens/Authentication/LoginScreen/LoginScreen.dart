import 'dart:ui';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/MainScreen/MainScreen.dart';
import 'package:botaniq_admin/Screens/Authentication/AccountRegisterScreen/AccountRegisterScreen.dart';
import 'package:botaniq_admin/Screens/Authentication/OtpScreen/OtpScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../../../Constants/Constants.dart';
import 'LoginScreenState.dart';
import 'package:botaniq_admin/Constants/ConstantVariables.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {

  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginScreenProvider);
    final notifier = ref.read(loginScreenProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: GestureDetector(
          onTap: () => CodeReusability.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),

            /// ✅ SAFE FOOTER (gesture + button navigation safe)
            bottomNavigationBar: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.dp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    objCommonWidgets.customText(
                      context,
                      'New to Botaniq? ',
                      10,
                      Colors.black,
                      objConstantFonts.montserratRegular,
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AccountRegisterScreen(),
                          ),
                        );

                      },
                      child: objCommonWidgets.customText(
                        context,
                        'Register Now',
                        12,
                        Colors.deepOrange,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            body: LayoutBuilder(

              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: SafeArea(
                        top: false,
                        child: Column(
                          children: [

                            /// 🔹 TOP IMAGE SECTION
                            Stack(
                              children: [
                                Image.asset(
                                  objConstantAssest.loginPic,
                                  width: double.infinity,
                                  height: 58.h,
                                  fit: BoxFit.fitHeight,
                                ),
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 3,
                                      sigmaY: 3,
                                    ),
                                    child: Container(
                                      color: Colors.black.withAlpha(80),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 45.dp,
                                  left: 15.dp,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      objCommonWidgets.customText(
                                        context,
                                        'Welcome Back',
                                        30,
                                        Colors.white,
                                        objConstantFonts
                                            .montserratSemiBold,
                                      ),
                                      SizedBox(height: 2.h),
                                      objCommonWidgets.customText(
                                        context,
                                        'Sell organic. We’ll handle the rest.',
                                        14,
                                        Colors.white,
                                        objConstantFonts
                                            .montserratSemiBold,
                                      ),
                                      objCommonWidgets.customText(
                                        context,
                                        'Orders, collection, and delivery made simple.',
                                        10,
                                        Colors.white,
                                        objConstantFonts
                                            .montserratMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            /// 🔹 FORM SECTION
                            Transform.translate(
                              offset: const Offset(0, -30),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                    Radius.circular(35.dp),
                                    topRight:
                                    Radius.circular(35.dp),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        objCommonWidgets.customText(
                                          context,
                                          'Login',
                                          25,
                                          Colors.black,
                                          objConstantFonts
                                              .montserratSemiBold,
                                        ),
                                        Row(
                                          children: [
                                            objCommonWidgets
                                                .customText(
                                              context,
                                              'Login as Admin?',
                                              10,
                                              Colors.black,
                                              objConstantFonts
                                                  .montserratSemiBold,
                                            ),
                                            SizedBox(
                                              width: 40,
                                              child: Transform.scale(
                                                scale: 0.6,
                                                child:
                                                CupertinoSwitch(
                                                  activeTrackColor:
                                                  Colors.green,
                                                  value: isAdmin,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      isAdmin = val;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 2.h),

                                    _customTextField(
                                      "Enter Mobile Number",
                                      "Enter your reg. mobile number",
                                      state.emailController,
                                      keyboardType:
                                      TextInputType.number,
                                      prefixText: "+91",
                                      maxLength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,
                                      ],
                                    ),

                                    SizedBox(height: 3.h),

                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        currentUser = isAdmin ? UserRole.admin : UserRole.seller ;
                                        notifier.checkLoginFieldValidation(context);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding:
                                        EdgeInsets.symmetric(
                                          vertical: 15.dp,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(
                                            25.dp,
                                          ),
                                        ),
                                        child: Center(
                                          child: objCommonWidgets
                                              .customText(
                                            context,
                                            'Get OTP',
                                            16,
                                            Colors.white,
                                            objConstantFonts
                                                .montserratSemiBold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  /// 🔹 CUSTOM TEXT FIELD
  Widget _customTextField(
      String hint,
      String label,
      TextEditingController? controller, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        void Function(String)? onChanged,
        List<TextInputFormatter>? inputFormatters,
        String? prefixText,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          hint,
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),
        SizedBox(height: 5.dp),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          cursorColor: Colors.black,
          style: TextStyle(
            fontSize: 13.dp,
            fontFamily: objConstantFonts.montserratMedium,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            counterText: "", // hides maxLength counter
            prefixIcon: prefixText != null
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.dp),
              child: Center(
                widthFactor: 0.0,
                child: Text(
                  prefixText,
                  style: TextStyle(
                    fontSize: 15.dp,
                    fontFamily: objConstantFonts.montserratMedium,
                    color: Colors.black,
                  ),
                ),
              ),
            )
                : null,
            hintText: label,
            hintStyle: TextStyle(
              fontSize: 12.dp,
              fontFamily: objConstantFonts.montserratRegular,
              color: Colors.black.withAlpha(150),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.dp),
              borderSide: BorderSide(color: Colors.black.withAlpha(65)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.dp),
              borderSide: BorderSide(
                color: controller!.text.trim().isNotEmpty
                    ? Colors.black
                    : Colors.black.withAlpha(65),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.dp),
              borderSide: const BorderSide(color: Colors.black),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.dp,
              vertical: 15.dp,
            ),
          ),
          maxLength: maxLength,
        ),
      ],
    );
  }

}







//MARK: - Widget
  /*@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: objConstantColor.navyBlue,
        body: SafeArea(
          top: false,
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
            padding: EdgeInsets.symmetric(vertical: 15.dp),
            child: Center(
              child: objCommonWidgets.customText(
                context,
                'Login',
                20,
                objConstantColor.navyBlue,
                objConstantFonts.montserratBold,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              objCommonWidgets.customText(
                context,
                'Login type Admin',
                12,
                objConstantColor.navyBlue,
                objConstantFonts.montserratSemiBold,
              ),
              CupertinoSwitch(
                value: _lights,
                activeTrackColor: CupertinoColors.activeGreen,
                inactiveTrackColor: CupertinoColors.systemGrey5,
                thumbColor: CupertinoColors.white,
                onChanged: (bool value) {
                  setState(() {
                    _lights = value;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 15.dp),

          objCommonWidgets.customText(
            context,
            'Email/Mobile Number',
            12,
            objConstantColor.navyBlue,
            objConstantFonts.montserratSemiBold,
          ),

          SizedBox(height: 2.dp),

          CommonTextField(
            controller: loginState.userNameController,
            placeholder: "Enter your Email/Mobile Number",
            textSize: 12,
            fontFamily: objConstantFonts.montserratMedium,
            textColor: objConstantColor.navyBlue,
            isNumber: false,
            onChanged: (value) {},
          ),

          SizedBox(height: 10.dp),

          objCommonWidgets.customText(
            context,
            'Password',
            12,
            objConstantColor.navyBlue,
            objConstantFonts.montserratSemiBold,
          ),

          SizedBox(height: 2.dp),

          CommonTextField(
            controller: loginState.passwordController,
            placeholder: "Enter your password",
            textSize: 12,
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
                      10,
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
              padding: EdgeInsets.symmetric(vertical: 10.dp),
              color: objConstantColor.orange,
              borderRadius: BorderRadius.circular(12.dp),
              onPressed: () {
                currentUser = _lights ? UserRole.admin : UserRole.seller ;
                loginNotifier.checkLoginFieldValidation(context);
              },
              child: objCommonWidgets.customText(
                context,
                'Login',
                15,
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

  }*/

