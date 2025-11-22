
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/Constants.dart';

class ChangePasswordScreenState {
  final ScreenName currentModule;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  ChangePasswordScreenState({
    this.currentModule = ScreenName.home,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  ChangePasswordScreenState copyWith({
    ScreenName? currentModule,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
  }) {
    return ChangePasswordScreenState(
      currentModule: currentModule ?? this.currentModule,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
    );
  }
}

class ChangePasswordScreenStateNotifier
    extends StateNotifier<ChangePasswordScreenState> {
  ChangePasswordScreenStateNotifier() : super(ChangePasswordScreenState(passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),));

  @override
  void dispose() {
    super.dispose();
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



      } else {
        CodeReusability().showAlert(
            context, 'Please Check Your Internet Connection');
      }
    });

  }


}

final ChangePasswordScreenStateProvider = StateNotifierProvider.autoDispose<
    ChangePasswordScreenStateNotifier, ChangePasswordScreenState>((ref) {
  var notifier = ChangePasswordScreenStateNotifier();
  return notifier;
});
