import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/CommonPopupViews/MapScreen/MapScreen.dart';
import 'package:botaniq_admin/Screens/Authentication/AccountRegisterScreen/AccountRegisterRepository.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';
import '../../../CommonPopupViews/CommonOtpVerificationScreen/CommonOtpVerificationScreen.dart';
import '../RegisterSuccessScreen/RegisterSuccessScreen.dart';
import 'AccountRegisterModel.dart';

enum OtpVerifyType {
  mobile,
  email,
  whatsApp,
  personalMobile,
  personalEmail
}

class AccountRegisterScreenState {
  final bool isLoading;
  final int currentStep;
  final int maxCompletedStep;
  final bool isPageAnimating;

  //Step 1
  final TextEditingController mobileNumberController;
  final TextEditingController mobileNumberWhatsappController;
  final TextEditingController emailController;
  final bool verifiedMobile;
  final bool verifiedEmail;
  final bool isWhatsApp;
  final bool verifiedWhatsApp;

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
  final TextEditingController streetController;
  final TextEditingController buildNumberController;
  final String? gender;

  //Step 3
  final TextEditingController brandNameController;
  final String? businessType;
  final TextEditingController businessDescriptionController;
  final TextEditingController businessStartedDateController;
  final List<String> selectedProducts;
  final String businessLogo;

  //Step 4
  final TextEditingController panNumberController;
  final TextEditingController gstNumberController;
  final TextEditingController fssAiController;
  final bool isFssAiNeeded;

  //Step 5
  final TextEditingController bankIFSCCodeController;
  final TextEditingController bankAccountNumberController;

  //Step 6
  final LatLng? selectedLocation;
  final String selectPickupAddress;

  //Step 7
  final Map<String, DaySchedule> weeklySchedule;

  //Step 8
  final bool isAgreementAccepted;
  final List<AgreementSection> sellerAgreementSections;


  AccountRegisterScreenState({
    this.isLoading = false,
    this.currentStep = 0,
    this.maxCompletedStep = 0,
    this.isPageAnimating = false,

    //Step 1
    required this.mobileNumberController,
    required this.mobileNumberWhatsappController,
    required this.emailController,
    this.verifiedMobile = false,
    this.verifiedEmail = false,
    this.isWhatsApp = true,
    this.verifiedWhatsApp = false,

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
    required this.streetController,
    required this.buildNumberController,
    this.gender,

    //Step 3
    required this.brandNameController,
    this.businessType,
    required this.businessDescriptionController,
    required this.businessStartedDateController,
    this.selectedProducts = const [],
    this.businessLogo = '',

    //Step 4
    required this.panNumberController,
    required this.gstNumberController,
    required this.bankIFSCCodeController,

    //Step 5
    required this.bankAccountNumberController,
    required this.fssAiController,
    this.isFssAiNeeded = false,

    //Step 6
    required this.selectedLocation,
    this.selectPickupAddress = '',

    //Step 7
    required this.weeklySchedule,

    //Step 8
    required this.isAgreementAccepted,
    required this.sellerAgreementSections,

  });


  AccountRegisterScreenState copyWith({
    bool? isLoading,
    int? currentStep,
    int? maxCompletedStep,
    bool? isPageAnimating,
    TextEditingController? mobileNumberController,
    TextEditingController? mobileNumberWhatsappController,
    bool? verifiedMobile,
    TextEditingController? emailController,
    bool? isWhatsApp,
    bool? verifiedEmail,
    bool? verifiedWhatsApp,
    TextEditingController? fullNameController,
    TextEditingController? dobController,
    TextEditingController? streetController,
    TextEditingController? buildNumberController,
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
    String? gender,
    TextEditingController? brandNameController,
    String? businessType,
    TextEditingController? businessDescriptionController,
    TextEditingController? businessStartedDateController,
    String? businessLogo,
    LatLng? selectedLocation,
    String? selectPickupAddress,
    TextEditingController? panNumberController,
    TextEditingController? gstNumberController,
    TextEditingController? bankIFSCCodeController,
    TextEditingController? bankAccountNumberController,
    TextEditingController? fssAiController,
    bool? isFssAiNeeded,
    Map<String, DaySchedule>? weeklySchedule,
    bool? isAgreementAccepted,
    List<AgreementSection>? sellerAgreementSections,
    List<String>? selectedProducts
  }) {
    return AccountRegisterScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentStep: currentStep ?? this.currentStep,
      maxCompletedStep: maxCompletedStep ?? this.maxCompletedStep,
      isPageAnimating: isPageAnimating ?? this.isPageAnimating,
      mobileNumberController: mobileNumberController ?? this.mobileNumberController,
      mobileNumberWhatsappController: mobileNumberWhatsappController ?? this.mobileNumberWhatsappController,
      emailController: emailController ?? this.emailController,
      verifiedMobile: verifiedMobile ?? this.verifiedMobile,
      verifiedEmail: verifiedEmail ?? this.verifiedEmail,
      isWhatsApp: isWhatsApp ?? this.isWhatsApp,
      verifiedWhatsApp: verifiedWhatsApp ?? this.verifiedWhatsApp,
      fullNameController: fullNameController ?? this.fullNameController,
      streetController: streetController ?? this.streetController,
      buildNumberController: buildNumberController ?? this.buildNumberController,
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
      gender: gender ?? this.gender,
      pinCodeController: pinCodeController ?? this.pinCodeController,
      brandNameController: brandNameController ?? this.brandNameController,
      businessType: businessType ?? this.businessType,
      businessDescriptionController: businessDescriptionController ?? this.businessDescriptionController,
      businessStartedDateController: businessStartedDateController ?? this.businessStartedDateController,
      businessLogo: businessLogo ?? this.businessLogo,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectPickupAddress: selectPickupAddress ?? this.selectPickupAddress,
      panNumberController: panNumberController ?? this.panNumberController,
      gstNumberController: gstNumberController ?? this.gstNumberController,
      bankIFSCCodeController: bankIFSCCodeController ?? this.bankIFSCCodeController,
      isFssAiNeeded: isFssAiNeeded ?? this.isFssAiNeeded,
      bankAccountNumberController: bankAccountNumberController ?? this.bankAccountNumberController,
        fssAiController: fssAiController ?? this.fssAiController,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      isAgreementAccepted: isAgreementAccepted ?? this.isAgreementAccepted,
      sellerAgreementSections: sellerAgreementSections ?? this.sellerAgreementSections,
      selectedProducts: selectedProducts ?? this.selectedProducts,
    );
  }
}

class AccountRegisterScreenStateNotifier extends StateNotifier<AccountRegisterScreenState> {
  AccountRegisterScreenStateNotifier() : super(AccountRegisterScreenState(
    //------
    mobileNumberController: TextEditingController(),
    mobileNumberWhatsappController: TextEditingController(),
    emailController: TextEditingController(),
    fullNameController: TextEditingController(),
      streetController: TextEditingController(),
      buildNumberController: TextEditingController(),
    dobController: TextEditingController(),
    pinCodeController: TextEditingController(),
    brandNameController: TextEditingController(),
    businessDescriptionController: TextEditingController(),
    businessStartedDateController: TextEditingController(),
    panNumberController: TextEditingController(),
    gstNumberController: TextEditingController(),
    bankIFSCCodeController: TextEditingController(),
    bankAccountNumberController: TextEditingController(),
    fssAiController: TextEditingController(),
    selectedLocation: null,
    weeklySchedule: {
      'Monday': DaySchedule(isOpen: false),
      'Tuesday': DaySchedule(isOpen: false),
      'Wednesday': DaySchedule(isOpen: false),
      'Thursday': DaySchedule(isOpen: false),
      'Friday': DaySchedule(isOpen: false),
      'Saturday': DaySchedule(isOpen: false),
      'Sunday': DaySchedule(isOpen: false),
    },
      isAgreementAccepted: false,
      sellerAgreementSections : [
        AgreementSection(
          title: "1. Platform Role",
          points: [
            "The platform acts only as a marketplace facilitator.",
            "Sellers are solely responsible for product quality, legality, and authenticity.",
          ],
        ),
        AgreementSection(
          title: "2. Seller Responsibilities",
          points: [
            "Maintain valid FSSAI, GST, and PAN registrations.",
            "Ensure organic claims are truthful and verifiable.",
            "Follow food safety, hygiene, packaging, and labeling laws.",
          ],
        ),
        AgreementSection(
          title: "3. Product Approval",
          points: [
            "Products will be visible to customers only after admin verification.",
            "Admin may suspend or remove products at any time.",
          ],
        ),
        AgreementSection(
          title: "4. Orders & Delivery",
          points: [
            "Sellers must pack products hygienically and upload package images.",
            "Handover to delivery partner requires OTP verification.",
          ],
        ),
        AgreementSection(
          title: "5. Payments & Settlements",
          points: [
            "Payments will be settled weekly.",
            "Platform may deduct commission, logistics charges, GST/TDS/TCS as applicable.",
          ],
        ),
        AgreementSection(
          title: "6. Reviews & Ratings",
          points: [
            "Customers may provide reviews and ratings.",
            "Manipulation of reviews is strictly prohibited.",
          ],
        ),
        AgreementSection(
          title: "7. Returns & Disputes",
          points: [
            "Sellers must comply with return and refund policies.",
            "Platform decisions in disputes shall be final.",
          ],
        ),
        AgreementSection(
          title: "8. Legal Compliance",
          points: [
            "Seller agrees to comply with Indian laws including:",
            "FSSAI Act",
            "GST Act",
            "Consumer Protection (E-commerce) Rules",
            "IT Act & DPDP Act 2023",
          ],
        ),
        AgreementSection(
          title: "9. Account Suspension",
          points: [
            "Platform may suspend or terminate accounts for violations or fraud.",
          ],
        ),
      ]
  ));



  final List<String> edibleCategories = [
    'Fresh Produce', 'Grains & Millets', 'Oils, Ghee & Cooking Fats',
    'Meat, Eggs & Dairy', 'Natural Sweeteners & Condiments', 'Spices & Masalas',
    'Dry Fruits, Nuts & Seeds', 'Ayurvedic Edibles (Internal Use)',
    'Beverages & Health Drinks', 'Traditional Foods & Snacks'
  ];

  void toggleProductSelection(String product) {
    List<String> currentSelected = List.from(state.selectedProducts);

    if (currentSelected.contains(product)) {
      currentSelected.remove(product);
    } else {
      currentSelected.add(product);
    }

    // Validation: Check if any selected item is in the edible list
    bool needsFssai = currentSelected.any((item) => edibleCategories.contains(item));

    state = state.copyWith(
      selectedProducts: currentSelected,
      isFssAiNeeded: needsFssai,
    );
  }



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

  void updateIsWhatApp(bool isWhatsApp) => state = state.copyWith(isWhatsApp: isWhatsApp);

  void updateBusinessLogo(String imagePath) => state = state.copyWith(businessLogo: imagePath);

  void updateGender(String type) => state = state.copyWith(gender: type);



  ///Mark:-  Profile Image Upload
  Future<void> uploadImage(BuildContext context) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(context, ImageSource.gallery);
    if (imagePath != null) {
      state = state.copyWith(profileImage: imagePath);
    }
  }
  ///Mark:-  Business Logo Upload
  Future<void> uploadLogo(BuildContext context) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(context, ImageSource.gallery);
    if (imagePath != null) {
      state = state.copyWith(businessLogo: imagePath);
    }
  }



  /// Mark:- Verify Button methods
  bool showVerifyButtonForMobileNumber(){
    return CodeReusability.isValidMobileNumber(state.mobileNumberController.text.trim());
  }

  bool showVerifyButtonForMobileNumberWhatsApp(){
    return CodeReusability.isValidMobileNumber(state.mobileNumberWhatsappController.text.trim());
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

  /// Call this when location is selected from map/autocomplete
  void setSelectedLocation(LatLng location, String address) {
    state = state.copyWith(selectedLocation: location, selectPickupAddress: address);
  }

  /// Optional: clear location
  void clearSelectedLocation() {
    state = state.copyWith(selectedLocation: null, selectPickupAddress: '');
  }

  void toggleDay(String day) {
    final current = state.weeklySchedule[day]!;
    state = state.copyWith(
      weeklySchedule: {
        ...state.weeklySchedule,
        day: current.copyWith(isOpen: !current.isOpen),
      },
    );
  }

  void updateTime(String day, bool isOpenTime, TimeOfDay time) {
    final current = state.weeklySchedule[day]!;
    state = state.copyWith(
      weeklySchedule: {
        ...state.weeklySchedule,
        day: isOpenTime ? current.copyWith(openTime: time) : current.copyWith(closeTime: time),
      },
    );
  }

  void copyMondayToAll() {
    final monday = state.weeklySchedule['Monday']!;
    final newSchedule = state.weeklySchedule.map((key, value) {
      return MapEntry(key, monday.copyWith());
    });
    state = state.copyWith(weeklySchedule: newSchedule);
  }

  void updateReadedAgreement(bool value) {
    state = state.copyWith(isAgreementAccepted: value);
  }



  ///Mark:- Empty Validation for Pages

  void startPageAnimation() {
    state = state.copyWith(isPageAnimating: true);
  }

  void endPageAnimation() {
    state = state.copyWith(isPageAnimating: false);
  }

  bool canMoveToNext(int step) {
    //return true;
    if (step == 0) {
      final mobileNumber = state.mobileNumberController.text.trim();
      final email = state.emailController.text.trim();
      final isWhatsApp = state.isWhatsApp ? true : (state.mobileNumberWhatsappController.text.trim().isNotEmpty && state.verifiedWhatsApp);

      return mobileNumber.isNotEmpty && CodeReusability.isValidMobileNumber(mobileNumber) &&
          email.isNotEmpty && CodeReusability.isValidEmail(email) && state.verifiedMobile &&
          state.verifiedEmail && isWhatsApp;
    }

    if (step == 1) {
      final fulName = state.fullNameController.text.trim();
      final dob = state.dobController.text.trim();
      final street = state.streetController.text.trim();
      final building = state.buildNumberController.text.trim();

      return fulName.isNotEmpty &&
          dob.isNotEmpty &&
          street.isNotEmpty &&
          building.isNotEmpty &&
          state.gender!.isNotEmpty &&
          state.selectedCountryCode.isNotEmpty &&
          state.selectedStateCode.isNotEmpty &&
    state.selectedCityCode.isNotEmpty &&
          state.profileImage.isNotEmpty;
    }

    if (step == 2) {
      final brandName = state.brandNameController.text.trim();
      final businessDescription = state.businessDescriptionController.text.trim();
      final businessStartedDate = state.businessStartedDateController.text.trim();

      return brandName.isNotEmpty &&
          businessDescription.isNotEmpty &&
          businessStartedDate.isNotEmpty &&
          state.businessType!.isNotEmpty &&
          state.selectedProducts.isNotEmpty &&
    state.businessLogo.isNotEmpty;
    }

    if (step == 3) {
      final panNumber = state.panNumberController.text.trim();
      final gstIn = state.gstNumberController.text.trim();
      final fssAINumber = state.fssAiController.text.trim();

      final fssaiNeeded =  state.isFssAiNeeded ? fssAINumber.isNotEmpty : true;

      /*if (!Validator.isValidPAN(panNumber)) {
        return false;// Show error: "Invalid PAN Card format"
      } else if (gstIn.isNotEmpty && !Validator.isValidGST(gstIn)) {
        return false;// Show error: "Invalid GST number"
      } else if (fssAINumber.isNotEmpty && !Validator.isValidFSSAI(fssAINumber)) {
        return false;// Show error: "FSSAI must be 14 digits"
      } else {
        return true;
      }*/

      return (panNumber.isNotEmpty && fssaiNeeded);
    }

    if (step == 4) {
      final accountNumber = state.bankAccountNumberController.text.trim();
      final ifscCode = state.bankIFSCCodeController.text.trim();

      return accountNumber.isNotEmpty &&
          ifscCode.isNotEmpty;
    }

    if (step == 5){

      return state.selectedLocation != null;
    }

    if (step == 6) {
      bool anyOpen = state.weeklySchedule.values.any((day) => day.isOpen);
      if (!anyOpen) return false;

      for (var day in state.weeklySchedule.values) {
        if (day.isOpen) {
          final start = day.openTime.hour * 60 + day.openTime.minute;
          final end = day.closeTime.hour * 60 + day.closeTime.minute;
          if (end <= start) return false; // Closing must be after opening
        }
      }
      return true;
    }

    if (step == 7){
     return state.isAgreementAccepted;
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


  void callMapPopup(BuildContext context) async {
    final Map<String, dynamic>? result =
    await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Map',
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => MapScreen(),
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

    if (result != null) {
      final LatLng? selectedLocation = result['location'];
      final String selectedAddress = result['address'] ?? '';

      setSelectedLocation(selectedLocation!, selectedAddress);
    }

    CodeReusability.hideKeyboard(context);
  }


  /// 🔹 Updates correct boolean in state
  void updateVerification(OtpVerifyType type, bool isVerified) {
    if (type == OtpVerifyType.mobile) {
      state = state.copyWith(verifiedMobile: isVerified);
    } else if (type == OtpVerifyType.email){
      state = state.copyWith(verifiedEmail: isVerified);
    } else if (type == OtpVerifyType.whatsApp){
      state = state.copyWith(verifiedWhatsApp: isVerified);
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

  void callRegistrationAPI(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterSuccessScreen(),
      ),
    );
  }


}

final accountRegisterScreenStateProvider =
StateNotifierProvider.autoDispose<AccountRegisterScreenStateNotifier, AccountRegisterScreenState>((ref) {
  return AccountRegisterScreenStateNotifier();
});




class DaySchedule {
  final bool isOpen;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;

  DaySchedule({
    this.isOpen = false,
    this.openTime = const TimeOfDay(hour: 9, minute: 0),
    this.closeTime = const TimeOfDay(hour: 18, minute: 0),
  });

  DaySchedule copyWith({bool? isOpen, TimeOfDay? openTime, TimeOfDay? closeTime}) {
    return DaySchedule(
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }
}



class AgreementSection {
  final String title;
  final List<String> points;

  AgreementSection({
    required this.title,
    required this.points,
  });
}
