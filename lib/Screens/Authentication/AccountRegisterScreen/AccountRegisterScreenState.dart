import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';
import '../../../Utility/CommonOtpVerificationScreen.dart';

enum OtpVerifyType {
  mobile,
  email,
  personalMobile,
  personalEmail
}

class AccountRegisterScreenState {
  final int currentStep;
  final int maxCompletedStep;
  final TextEditingController mobileNumberController;
  final TextEditingController emailController;
  final bool verifiedMobile;
  final bool verifiedEmail;

  final String mainPhoto;

  AccountRegisterScreenState({
    this.currentStep = 0,
    this.maxCompletedStep = 0,
    required this.mobileNumberController,
    required this.emailController,
    this.verifiedMobile = false,
    this.verifiedEmail = false,

    this.mainPhoto = '',

  });


  AccountRegisterScreenState copyWith({
    int? currentStep,
    int? maxCompletedStep,
    TextEditingController? mobileNumberController,
    TextEditingController? emailController,
    bool? verifiedMobile,
    bool? verifiedEmail,

    String? mainPhoto,
  }) {
    return AccountRegisterScreenState(
      currentStep: currentStep ?? this.currentStep,
      maxCompletedStep: maxCompletedStep ?? this.maxCompletedStep,
      mobileNumberController: mobileNumberController ?? this.mobileNumberController,
      emailController: emailController ?? this.emailController,
      verifiedMobile: verifiedMobile ?? this.verifiedMobile,
      verifiedEmail: verifiedEmail ?? this.verifiedEmail,

      mainPhoto: mainPhoto ?? this.mainPhoto,
    );
  }
}

class AccountRegisterScreenStateNotifier extends StateNotifier<AccountRegisterScreenState> {
  AccountRegisterScreenStateNotifier() : super(AccountRegisterScreenState(
    //------
    mobileNumberController: TextEditingController(),
    emailController: TextEditingController(),
  ));




  void setStep(int step) {
    state = state.copyWith(
      currentStep: step,
      maxCompletedStep:
      step > state.maxCompletedStep ? step : state.maxCompletedStep,
    );
  }


  void onChanged() {
    state = state.copyWith();
  }



  ///Mark:-  Product Image Upload Methods
  void updateMainPhoto(String imagePath) {
    state = state.copyWith(mainPhoto: imagePath);
  }

  Future<void> uploadImage(BuildContext context, int index, {bool isMainImage = false}) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(context, ImageSource.gallery);
    if (imagePath != null) {
      if (isMainImage){
        updateMainPhoto(imagePath);
      } else {

      }
    }
  }



  /// Mark:- Verify Button methods
  bool showVerifyButtonForMobileNumber(){
    return CodeReusability.isValidMobileNumber(state.mobileNumberController.text.trim());
  }

  bool showVerifyButtonForEmail(){
    return CodeReusability.isValidEmail(state.emailController.text.trim());
  }

  /// Mark:- Update Verified boolean
  void updateMobileNumberVerified(bool isVerified){
    state = state.copyWith(verifiedMobile: isVerified);
  }

  void updateEmailVerified(bool isVerified){
    state = state.copyWith(verifiedEmail: isVerified);
  }


  ///Mark:- Empty Validation for Pages
  bool canMoveToNext(int step) {
    if (step == 0) {
      final mobileNumber = state.mobileNumberController.text.trim();
      final email = state.emailController.text.trim();

      return mobileNumber.isNotEmpty && CodeReusability.isValidMobileNumber(mobileNumber) &&
          email.isNotEmpty && CodeReusability.isValidEmail(email) && state.verifiedMobile && state.verifiedEmail;
    }

    if (step == 1) {
      return false;
    }

    if (step == 2) {
      return false;
    }

    if (step == 3) {
      return false;
    }

    if (step == 4) {
      return false;
    }

    if (step == 5){

      return false;
    }

    return true;
  }


  void callOTPVerifyPopup(BuildContext context, String value, bool isEmail, OtpVerifyType verifyField) async {
    final bool? verified = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'OTP',
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => CommonOtpVerificationScreen(
        isEmail: isEmail,
        value: value,
      ),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );

    CodeReusability.hideKeyboard(context);
    if (verified != null) {
      updateVerification(verifyField, verified);
    }

  }

  /// 🔹 Updates correct boolean in state
  void updateVerification(OtpVerifyType type, bool isVerified) {
    if (type == OtpVerifyType.mobile) {
      state = state.copyWith(verifiedMobile: isVerified);
    } else if (type == OtpVerifyType.email){
      state = state.copyWith(verifiedEmail: isVerified);
    }
  }


}

final accountRegisterScreenStateProvider =
StateNotifierProvider.autoDispose<AccountRegisterScreenStateNotifier, AccountRegisterScreenState>((ref) {
  return AccountRegisterScreenStateNotifier();
});