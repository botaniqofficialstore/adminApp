import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/Screens/Authentication/AccountRegisterScreen/AccountRegisterRepository.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';
import '../../../Utility/CommonOtpVerificationScreen.dart';
import 'AccountRegisterModel.dart';

enum OtpVerifyType {
  mobile,
  email,
  personalMobile,
  personalEmail
}

class AccountRegisterScreenState {
  final bool isLoading;
  final int currentStep;
  final int maxCompletedStep;

  //Step 1
  final TextEditingController mobileNumberController;
  final TextEditingController emailController;
  final bool verifiedMobile;
  final bool verifiedEmail;

  //Step 2
  final TextEditingController fullNameController;
  final TextEditingController dobController;
  final String profileImage;
  final String country;
  final String state;
  final String city;
  final List<CountryModel> countryList;
  final List<StateModel> stateList;
  final List<CityModel> cityList;
  final String selectedCountryCode;
  final String selectedStateCode;
  final String selectedCityCode;
  final TextEditingController pinCodeController;

  //Step 3
  final TextEditingController brandNameController;
  final String? businessType;
  final TextEditingController businessDescriptionController;
  final TextEditingController businessStartedDateController;

  AccountRegisterScreenState({
    this.isLoading = false,
    this.currentStep = 0,
    this.maxCompletedStep = 0,

    //Step 1
    required this.mobileNumberController,
    required this.emailController,
    this.verifiedMobile = false,
    this.verifiedEmail = false,

    //Step 2
    required this.fullNameController,
    required this.dobController,
    this.profileImage = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.countryList = const [],
    this.stateList = const [],
    this.cityList = const [],
    this.selectedCountryCode = '',
    this.selectedStateCode = '',
    this.selectedCityCode = '',
    required this.pinCodeController,

    //Step 3
    required this.brandNameController,
    this.businessType,
    required this.businessDescriptionController,
    required this.businessStartedDateController,

  });


  AccountRegisterScreenState copyWith({
    bool? isLoading,
    int? currentStep,
    int? maxCompletedStep,
    TextEditingController? mobileNumberController,
    TextEditingController? emailController,
    bool? verifiedMobile,
    bool? verifiedEmail,
    TextEditingController? fullNameController,
    TextEditingController? dobController,
    String? profileImage,
    String? country,
    String? state,
    String? city,
    List<CountryModel>? countryList,
    List<StateModel>? stateList,
    List<CityModel>? cityList,
    String? selectedCountryCode,
    String? selectedStateCode,
    String? selectedCityCode,
    TextEditingController? pinCodeController,
    TextEditingController? brandNameController,
    String? businessType,
    TextEditingController? businessDescriptionController,
    TextEditingController? businessStartedDateController,

  }) {
    return AccountRegisterScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentStep: currentStep ?? this.currentStep,
      maxCompletedStep: maxCompletedStep ?? this.maxCompletedStep,
      mobileNumberController: mobileNumberController ?? this.mobileNumberController,
      emailController: emailController ?? this.emailController,
      verifiedMobile: verifiedMobile ?? this.verifiedMobile,
      verifiedEmail: verifiedEmail ?? this.verifiedEmail,
      fullNameController: fullNameController ?? this.fullNameController,
      dobController: dobController ?? this.dobController,
      profileImage: profileImage ?? this.profileImage,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      countryList: countryList ?? this.countryList,
      stateList: stateList ?? this.stateList,
      cityList: cityList ?? this.cityList,
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      selectedStateCode: selectedStateCode ?? this.selectedStateCode,
      selectedCityCode: selectedCityCode ?? this.selectedCityCode,
      pinCodeController: pinCodeController ?? this.pinCodeController,
      brandNameController: brandNameController ?? this.brandNameController,
      businessType: businessType ?? this.businessType,
      businessDescriptionController: businessDescriptionController ?? this.businessDescriptionController,
      businessStartedDateController: businessStartedDateController ?? this.businessStartedDateController,
    );
  }
}

class AccountRegisterScreenStateNotifier extends StateNotifier<AccountRegisterScreenState> {
  AccountRegisterScreenStateNotifier() : super(AccountRegisterScreenState(
    //------
    mobileNumberController: TextEditingController(),
    emailController: TextEditingController(),
    fullNameController: TextEditingController(),
    dobController: TextEditingController(),
    pinCodeController: TextEditingController(),
    brandNameController: TextEditingController(),
    businessDescriptionController: TextEditingController(),
    businessStartedDateController: TextEditingController(),
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

  void updateBusinessType(String type) => state = state.copyWith(businessType: type);



  ///Mark:-  Profile Image Upload Methods
  Future<void> uploadImage(BuildContext context) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(context, ImageSource.gallery);
    if (imagePath != null) {
      state = state.copyWith(profileImage: imagePath);
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
      /*final mobileNumber = state.mobileNumberController.text.trim();
      final email = state.emailController.text.trim();

      return mobileNumber.isNotEmpty && CodeReusability.isValidMobileNumber(mobileNumber) &&
          email.isNotEmpty && CodeReusability.isValidEmail(email) && state.verifiedMobile && state.verifiedEmail;*/
      return true;
    }

    if (step == 1) {
      /*final fulName = state.fullNameController.text.trim();
      final dob = state.dobController.text.trim();

      return fulName.isNotEmpty &&
          dob.isNotEmpty &&
          state.selectedCountryCode.isNotEmpty &&
          state.selectedStateCode.isNotEmpty &&
    state.selectedCityCode.isNotEmpty && state.profileImage.isNotEmpty;*/
      return true;
    }

    if (step == 2) {
      /*final brandName = state.brandNameController.text.trim();
      final businessDescription = state.businessDescriptionController.text.trim();
      final businessStartedDate = state.businessStartedDateController.text.trim();

      return brandName.isNotEmpty &&
          businessDescription.isNotEmpty &&
          businessStartedDate.isNotEmpty &&
          state.businessType!.isNotEmpty;*/
      return true;
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


  void updateCountry(String countryName, String countryCode) {
    state = state.copyWith(
      country: countryName,
      selectedCountryCode: countryCode,
      state: '',
      city: '',
      stateList: [],
      cityList: [],
    );
  }


  void updateState(String stateName, String stateCode) {
    state = state.copyWith(
      state: stateName,
      selectedStateCode: stateCode,
      city: '',
      cityList: [],
    );
  }


  void updateCity(String cityName, String cityCode) {
    state = state.copyWith(city: cityName, selectedCityCode: cityCode);
  }




  ///MARK: API's

  /// This method is used to get Country List API
  Future<void> callCountryListGepAPI(BuildContext context) async {

    bool isConnected = await CodeReusability().isConnectedToNetwork();
    if (!isConnected) {
      state = state.copyWith(isLoading: false);
      CodeReusability().showAlert(context, 'Please Check Your Internet Connection');
      return;
    }

    AccountRegisterRepository().callCountryListGETApi((statusCode, response) async{

      if (statusCode == 200) {
        Logger().log('statusCode ------->, $statusCode');
        try {
          final List<CountryModel> countries = (response as List)
              .map((e) =>
              CountryModel.fromJson(e as Map<String, dynamic>))
              .toList();

          state = state.copyWith(countryList: countries);

        } catch (e) {
          CodeReusability().showAlert(context, 'Something went wrong');
        }
      }
      else {
        final apiResponse = GoogleApiErrorResponseModel.fromJson(response);
        CodeReusability().showAlert(context, apiResponse.message);
      }
      state = state.copyWith(isLoading: false);

    });
  }


  /// This method is used to get Country List API
  Future<void> callStatesListGepAPI(BuildContext context, String selectedCountryID) async {

    bool isConnected = await CodeReusability().isConnectedToNetwork();
    if (!isConnected) {
      state = state.copyWith(isLoading: false);
      CodeReusability().showAlert(context, 'Please Check Your Internet Connection');
      return;
    }

    AccountRegisterRepository().callStateListGETApi(selectedCountryID, (statusCode, response) async{

      if (statusCode == 200) {
        ///Update the array here!...
        final List<StateModel> states = (response as List)
            .map((e) =>
            StateModel.fromJson(e as Map<String, dynamic>))
            .toList();


        state = state.copyWith(
          stateList: states,
          cityList: [],
          state: '',
          city: '',
        );


      } else {
        final apiResponse = GoogleApiErrorResponseModel.fromJson(response);
        CodeReusability().showAlert(context, apiResponse.message);
      }
      state = state.copyWith(isLoading: false);

    });
  }

  /// This method is used to get Country List API
  Future<void> callCityListGepAPI(BuildContext context, String selectedCountryID, String selectedStateID) async {

    bool isConnected = await CodeReusability().isConnectedToNetwork();
    if (!isConnected) {
      state = state.copyWith(isLoading: false);
      CodeReusability().showAlert(context, 'Please Check Your Internet Connection');
      return;
    }

    AccountRegisterRepository().callCityListGETApi(selectedCountryID, selectedStateID, (statusCode, response) async{

      if (statusCode == 200) {
        ///Update the array here!...
        final List<CityModel> cities = (response as List)
            .map((e) =>
            CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
        state = state.copyWith(cityList: cities);

      } else {
        final apiResponse = GoogleApiErrorResponseModel.fromJson(response);
        CodeReusability().showAlert(context, apiResponse.message);
      }
      state = state.copyWith(isLoading: false);

    });
  }


}

final accountRegisterScreenStateProvider =
StateNotifierProvider.autoDispose<AccountRegisterScreenStateNotifier, AccountRegisterScreenState>((ref) {
  return AccountRegisterScreenStateNotifier();
});