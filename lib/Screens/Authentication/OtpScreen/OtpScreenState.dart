import 'dart:async';
import 'package:botaniq_admin/Screens/Authentication/ChangePasswordScreen/CreatePasswordScreen.dart';
import 'package:botaniq_admin/Screens/Authentication/OtpScreen/OtpModel.dart';
import 'package:botaniq_admin/Screens/Authentication/OtpScreen/OtpRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../../../CodeReusable/CommonWidgets.dart';


class OtpScreenGlobalState {
  final List<TextEditingController> controllers;
  final List<String> otpValues;
  final List<FocusNode> focusNodes;
  final String user;

  OtpScreenGlobalState({
    required this.controllers,
    required this.otpValues,
    required this.focusNodes,
    required this.user
  });

  OtpScreenGlobalState copyWith({
    List<TextEditingController>? controllers,
    List<String>? otpValues,
    List<FocusNode>? focusNodes,
    String? user
  }) {
    return OtpScreenGlobalState(
        controllers: controllers ?? this.controllers,
        otpValues: otpValues ?? this.otpValues,
        focusNodes: focusNodes ?? this.focusNodes,
        user: user ?? this.user
    );
  }
}

class OtpScreenGlobalStateNotifier
    extends StateNotifier<OtpScreenGlobalState> {
  OtpScreenGlobalStateNotifier() : super(OtpScreenGlobalState(controllers: List.generate(6, (_) => TextEditingController()), otpValues: List.generate(6, (_) => ""), focusNodes: List.generate(6, (_) => FocusNode()), user: ''));

  @override
  void dispose() {
    super.dispose();
  }


  //MARK: - METHODS
  ///This method used to dispose values
  void clearValues() {
    for (final controller in state.controllers) {
      controller.dispose();
    }
    for (final focusNode in state.focusNodes) {
      focusNode.dispose();
    }
  }

  ///This method is used to format from the timer value
  ///
  /// [seconds] - This param used to pass the seconds value
  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  ///This method used to clear OTP Fields
  void clearOtpFields() {
    for (var controller in state.controllers) {
      controller.clear();
    }
    state.otpValues.fillRange(0, state.otpValues.length, "");
  }

  ///This Method used to Auto-fill OTP fields
  void updateFieldsWithAutoFill(String otp) {
    for (int i = 0; i < otp.length; i++) {
      if (i < 6) {
        state.controllers[i].text = "*";
        state.otpValues[i] = otp[i];
      }
    }
  }

  void updateUserData(String user){
    state = state.copyWith(user: user);
  }

  ///This method is used to for empty validation
  void checkEmptyValidation(BuildContext context) {
    if (!context.mounted) return;
    CodeReusability.hideKeyboard(context);

    // Check if any OTP field is empty
    bool anyEmpty = state.otpValues.any((value) => value.trim().isEmpty);

    if (anyEmpty) {
      CodeReusability().showAlert(context, 'Please enter the OTP');
    } else {
      // OTP is fully entered, proceed with verification
      String otp = state.otpValues.join();
      callOTPVerifyAPI(context, otp);
    }
  }


  ///This method used to call Verify OTP API
  void callOTPVerifyAPI(BuildContext context, String otp) {
    if (!context.mounted) return;

    CodeReusability().isConnectedToNetwork().then((isConnected) async {
      if (isConnected) {

        Map<String, dynamic> requestBody = {
          'email': state.user,
          'otp' : otp
        };

        CommonWidgets().showLoadingBar(true, context);

        OtpRepository().callOtpVerifyApi(requestBody, (statusCode, responseBody) {
          OtpResponse response = OtpResponse.fromJson(responseBody);

          if (statusCode == 200) {

              CommonWidgets().showLoadingBar(false, context);
              //Call Navigation
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePasswordScreen(userEmail: state.user)),);

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

  ///This Method is used to call Resend OTP API
  Future<bool> callReSendOtpAPI(BuildContext context) async {
    if (!context.mounted) return false;

    bool isConnected = await CodeReusability().isConnectedToNetwork();
    if (!isConnected) {
      CodeReusability().showAlert(context, 'Please Check Your Internet Connection');
      return false;
    }

    Map<String, dynamic> requestBody = {
      'emailOrMobile': state.user,
    };

    CommonWidgets().showLoadingBar(true, context); // Loading bar enabled

    try {
      final completer = Completer<bool>();

      OtpRepository().callResendOTPApi(requestBody, (statusCode, responseBody) {
        CommonWidgets().showLoadingBar(false, context); // Hide loading bar

        OtpResponse response = OtpResponse.fromJson(responseBody);

        if (statusCode == 200) {
          completer.complete(true);
        } else {
          CodeReusability().showAlert(context, response.message ?? "Something went wrong");
          completer.complete(false);
        }
      });

      return await completer.future;
    } catch (e) {
      CommonWidgets().showLoadingBar(false, context);
      CodeReusability().showAlert(context, 'An unexpected error occurred: $e');
      return false;
    }
  }




}



final otpScreenGlobalStateProvider = StateNotifierProvider.autoDispose<
    OtpScreenGlobalStateNotifier, OtpScreenGlobalState>((ref) {
  var notifier = OtpScreenGlobalStateNotifier();
  return notifier;
});

