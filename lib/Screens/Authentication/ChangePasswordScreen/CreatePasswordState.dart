
import 'package:botaniq_admin/Screens/Authentication/ChangePasswordScreen/ChangePasswordModel.dart';
import 'package:botaniq_admin/Screens/Authentication/ChangePasswordScreen/ChangePasswordRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../../../CodeReusable/CommonWidgets.dart';
import '../LoginScreen/LoginScreen.dart';


class CreatePasswordState{
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String adminEmail;

  CreatePasswordState({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.adminEmail
  });

  CreatePasswordState copyWith ({
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    String? adminEmail
  }){
    return CreatePasswordState(
        passwordController: passwordController ?? this.passwordController,
        confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
        adminEmail: adminEmail ?? this.adminEmail
    );
  }
}

class CreatePasswordScreenStateNotifier
    extends StateNotifier<CreatePasswordState> {
  CreatePasswordScreenStateNotifier() : super(CreatePasswordState(
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      adminEmail: ''
  ));



  void updateUserEmail(String email){
    state = state.copyWith(adminEmail: email);
  }


  ///This Method used to check login field validation and call API
  void checkTextFieldValidation(BuildContext context) {
    if (!context.mounted) return;
    CodeReusability.hideKeyboard(context);

    if (CodeReusability.isEmptyOrWhitespace(state.passwordController.text)) {
      CodeReusability().showAlert(context, 'Please enter new password');
    } else if (!CodeReusability.isPasswordValid(state.passwordController .text)){
      CodeReusability().showAlert(context, 'Password must include at least 8 characters, one uppercase letter, one lowercase letter, one number, and one special character.');
    } else if (CodeReusability.isEmptyOrWhitespace(state.confirmPasswordController .text)){
      CodeReusability().showAlert(context, 'Please enter confirm password');
    }  else if (state.confirmPasswordController.text != state.passwordController.text){
      CodeReusability().showAlert(context, 'New password and Confirm password not match');
    } else {
      callCreatePasswordAPI(context);
    }
  }


  ///This method is used to call Create Password POST API
  void callCreatePasswordAPI(BuildContext context) {
    if (!context.mounted) return;

    CodeReusability().isConnectedToNetwork().then((isConnected) async {
      if (isConnected) {

        Map<String, dynamic> requestBody = {
          'email': state.adminEmail,
          'newPassword' : state.passwordController.text.trim(),
          'confirmPassword' : state.confirmPasswordController.text.trim()
        };

        CommonWidgets().showLoadingBar(true, context);

        ChangePasswordRepository().callChangePasswordApi(requestBody, (statusCode, responseBody) {
          ChangePasswordResponse response = ChangePasswordResponse.fromJson(responseBody);

          if (statusCode == 200) {

            CommonWidgets().showLoadingBar(false, context);
            //Call Navigation
            callNavigation(context);

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


  ///This method is used to navigate to Login Screen
  void callNavigation(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const LoginScreen()),
    );
  }


}



final CreatePasswordScreenStateProvider = StateNotifierProvider.autoDispose<
    CreatePasswordScreenStateNotifier, CreatePasswordState>((ref) {
  var notifier = CreatePasswordScreenStateNotifier();
  return notifier;
});




