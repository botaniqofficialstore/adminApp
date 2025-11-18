import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../OtpScreen/OtpScreen.dart';


class LoginScreenGlobalState {
  final TextEditingController userNameController;
  final TextEditingController passwordController;

  LoginScreenGlobalState({
    required this.userNameController,
    required this.passwordController,
  });

  LoginScreenGlobalState copyWith({
    TextEditingController? userNameController,
    TextEditingController? passwordController,
  }) {
    return LoginScreenGlobalState(
      userNameController: userNameController ?? this.userNameController,
      passwordController: passwordController ?? this.passwordController,
    );
  }
}

class LoginScreenGlobalStateNotifier
    extends StateNotifier<LoginScreenGlobalState> {
  LoginScreenGlobalStateNotifier() : super(LoginScreenGlobalState(userNameController: TextEditingController(), passwordController: TextEditingController(),));

  @override
  void dispose() {
    super.dispose();
  }

  ///This Method used to check login field validation and call API
  void checkLoginFieldValidation(BuildContext context) {
    if (!context.mounted) return;
    CodeReusability.hideKeyboard(context);

    if (CodeReusability.isEmptyOrWhitespace(state.userNameController.text)) {
      CodeReusability().showAlert(context, 'Please Enter Your Email/Mobile Number');
    } else if (!CodeReusability.isValidMailOrMobile(state.userNameController.text)){
      CodeReusability().showAlert(context, 'Please Enter Valid Email or Mobile Number');
    } else if (!CodeReusability.isValidMailOrMobile(state.passwordController.text)){
      CodeReusability().showAlert(context, 'Please Enter Your Password');
    } else {

    }
  }

  ///This method is used to call forgot password API
  void callForgotPasswordAPI(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => OtpScreen(loginWith: 'botaniqofficialstore@gmail.com', isEmail: CodeReusability().isEmail('botaniqofficialstore@gmail.com'),)),
    );
  }





}



final loginScreenProvider = StateNotifierProvider.autoDispose<
    LoginScreenGlobalStateNotifier, LoginScreenGlobalState>((ref) {
  var notifier = LoginScreenGlobalStateNotifier();
  return notifier;
});

