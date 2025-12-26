import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../../../CodeReusable/CommonWidgets.dart';
import '../../../Constants/Constants.dart';
import '../../../Utility/PreferencesManager.dart';
import '../../AdminScreens/InnerScreens/MainScreen/MainScreen.dart';
import '../../SellerScreens/SellerMainScreen/SellerMainScreen.dart';
import '../OtpScreen/OtpScreen.dart';
import 'LoginModel.dart';
import 'LoginRepository.dart';


class LoginScreenGlobalState {
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;

  LoginScreenGlobalState({
    required this.userNameController,
    required this.passwordController,
    required this.emailController,
  });

  LoginScreenGlobalState copyWith({
    TextEditingController? userNameController,
    TextEditingController? passwordController,
    TextEditingController? emailController,
  }) {
    return LoginScreenGlobalState(
      userNameController: userNameController ?? this.userNameController,
      passwordController: passwordController ?? this.passwordController,
      emailController: emailController ?? this.emailController,
    );
  }
}

class LoginScreenGlobalStateNotifier
    extends StateNotifier<LoginScreenGlobalState> {
  LoginScreenGlobalStateNotifier() : super(LoginScreenGlobalState(userNameController: TextEditingController(), passwordController: TextEditingController(), emailController: TextEditingController(),));

  @override
  void dispose() {
    super.dispose();
  }

  ///This Method used to check login field validation and call API
  void checkLoginFieldValidation(BuildContext context) {
    if (!context.mounted) return;
    CodeReusability.hideKeyboard(context);

    if (currentUser == UserRole.admin){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SellerMainScreen()));
    }

    /*if (CodeReusability.isEmptyOrWhitespace(state.userNameController.text)) {
      CodeReusability().showAlert(context, 'Please Enter Your Email/Mobile Number');
    } else if (!CodeReusability.isValidMailOrMobile(state.userNameController.text)){
      CodeReusability().showAlert(context, 'Please Enter Valid Email or Mobile Number');
    } else if (CodeReusability.isEmptyOrWhitespace(state.passwordController.text)){
      CodeReusability().showAlert(context, 'Please Enter Your Password');
    } else {
      callLoginAPI(context);
    }*/
  }

  ///This method is used to call Login API
  void callLoginAPI(BuildContext context){
    if (!context.mounted) return;



    CodeReusability().isConnectedToNetwork().then((isConnected) async {
      if (isConnected) {

        Map<String, dynamic> requestBody = {
          'loginId': state.userNameController.text.trim(),
          "password": state.passwordController.text.trim(),
        };

        CommonWidgets().showLoadingBar(true, context);

        LoginRepository().callAdminLoginApi(requestBody, (statusCode, responseBody) {
          LoginResponse response = LoginResponse.fromJson(responseBody);

          if (statusCode == 200) {
            PreferencesManager.getInstance().then((prefs) {
              prefs.setStringValue(PreferenceKeys.adminID, response.admin.adminId ?? '');
              prefs.setStringValue(PreferenceKeys.adminFirstName, response.admin.firstName ?? '');
              prefs.setStringValue(PreferenceKeys.adminLastName, response.admin.lastName ?? '');
              prefs.setStringValue(PreferenceKeys.adminEmailID, response.admin.email ?? '');
              prefs.setStringValue(PreferenceKeys.adminMobileNumber, response.admin.mobileNumber ?? '');

              prefs.setBooleanValue(PreferenceKeys.isUserLogged, true);

              CommonWidgets().showLoadingBar(false, context);
              //CommonAPI().callDeviceRegisterAPI();

              //Call Navigation
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
            });

          } else {
            CommonWidgets().showLoadingBar(false, context);
            CodeReusability().showAlert(context, response.message ?? 'something Went Wrong');
          }
        });

      } else {
        CodeReusability().showAlert(context, 'Please Check Your Internet Connection');
      }
    });

  }

  ///This method is used to call forgot password API
  void callForgotPasswordAPI(BuildContext context){
    if (!context.mounted) return;
    CodeReusability.hideKeyboard(context);

    if (CodeReusability.isEmptyOrWhitespace(state.emailController.text)) {
      CodeReusability().showAlert(context, 'Please Enter Your Registered Email');
    } else {


      CodeReusability().isConnectedToNetwork().then((isConnected) async {
        if (isConnected) {

          Map<String, dynamic> requestBody = {
            'email': state.emailController.text.trim(),
          };

          CommonWidgets().showLoadingBar(true, context);

          LoginRepository().callForgotPasswordApi(requestBody, (statusCode, responseBody) {
            ForgotPasswordResponse response = ForgotPasswordResponse.fromJson(responseBody);

            if (statusCode == 200) {
              PreferencesManager.getInstance().then((prefs) {
                Navigator.pop(context);
                CommonWidgets().showLoadingBar(false, context);
                //Call Navigation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtpScreen(loginWith: state.emailController.text, isEmail: CodeReusability().isEmail(state.emailController.text),)),
                );
              });

            } else {
              CommonWidgets().showLoadingBar(false, context);
              CodeReusability().showAlert(context, response.message ?? 'something Went Wrong');
            }
          });

        } else {
          CodeReusability().showAlert(context, 'Please Check Your Internet Connection');
        }
      });


    }

  }



}



final loginScreenProvider = StateNotifierProvider.autoDispose<
    LoginScreenGlobalStateNotifier, LoginScreenGlobalState>((ref) {
  var notifier = LoginScreenGlobalStateNotifier();
  return notifier;
});

