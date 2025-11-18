
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../LoginScreen/LoginScreen.dart';


class CreatePasswordState{
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String userID;

  CreatePasswordState({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.userID
  });

  CreatePasswordState copyWith ({
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    String? userID
  }){
    return CreatePasswordState(
        passwordController: passwordController ?? this.passwordController,
        confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
        userID: userID ?? this.userID
    );
  }
}

class CreatePasswordScreenStateNotifier
    extends StateNotifier<CreatePasswordState> {
  CreatePasswordScreenStateNotifier() : super(CreatePasswordState(
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      userID: ''
  ));



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

  void updateUserID(String userID){
    state = state.copyWith(userID: userID);
  }


  ///This method is used to call Create Password POST API
  void callCreatePasswordAPI(BuildContext context) {
    if (!context.mounted) return;
    callNavigation(context);

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




