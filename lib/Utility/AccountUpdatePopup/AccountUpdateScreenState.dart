import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/CommonViews/MapScreen.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';
import '../../../Utility/CommonOtpVerificationScreen.dart';
import '../../Screens/Authentication/AccountRegisterScreen/AccountRegisterModel.dart';
import '../../Screens/Authentication/AccountRegisterScreen/AccountRegisterRepository.dart';
import '../../Screens/Authentication/AccountRegisterScreen/AccountRegisterScreenState.dart';


class AccountUpdateScreenState {

  final String formTitle;

  //Step 1
  final TextEditingController mobileNumberController;
  final TextEditingController mobileNumberWhatsappController;
  final TextEditingController emailController;
  final bool verifiedMobile;
  final bool verifiedEmail;
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

  AccountUpdateScreenState({
    this.formTitle = '',
    //Step 1
    required this.mobileNumberController,
    required this.mobileNumberWhatsappController,
    required this.emailController,
    this.verifiedMobile = false,
    this.verifiedEmail = false,
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

  });


  AccountUpdateScreenState copyWith({
    String? formTitle,
    bool? isLoading,
    TextEditingController? mobileNumberController,
    TextEditingController? mobileNumberWhatsappController,
    bool? verifiedMobile,
    TextEditingController? emailController,
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
    List<String>? selectedProducts
  }) {
    return AccountUpdateScreenState(
      formTitle: formTitle ?? this.formTitle,
      mobileNumberController: mobileNumberController ?? this.mobileNumberController,
      mobileNumberWhatsappController: mobileNumberWhatsappController ?? this.mobileNumberWhatsappController,
      emailController: emailController ?? this.emailController,
      verifiedMobile: verifiedMobile ?? this.verifiedMobile,
      verifiedEmail: verifiedEmail ?? this.verifiedEmail,
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
      panNumberController: panNumberController ?? this.panNumberController,
      gstNumberController: gstNumberController ?? this.gstNumberController,
      bankIFSCCodeController: bankIFSCCodeController ?? this.bankIFSCCodeController,
      isFssAiNeeded: isFssAiNeeded ?? this.isFssAiNeeded,
      bankAccountNumberController: bankAccountNumberController ?? this.bankAccountNumberController,
      fssAiController: fssAiController ?? this.fssAiController,
      selectedProducts: selectedProducts ?? this.selectedProducts,
    );
  }
}

class AccountUpdateScreenStateNotifier extends StateNotifier<AccountUpdateScreenState> {
  AccountUpdateScreenStateNotifier() : super(AccountUpdateScreenState(
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
  


  void updateInitialData(BuildContext context, FormType type, dynamic data){
    if (type == FormType.brandLogo){
      state = state.copyWith(businessLogo: data ?? '', formTitle: 'Upload your brand logo');
    } else if (type == FormType.brandName){
      state = state.copyWith(brandNameController: TextEditingController(text: data ?? ''), formTitle: 'Upload your brand logo');
    } else if (type == FormType.brandStartDate){
      state = state.copyWith(businessStartedDateController: TextEditingController(text: data ?? ''), formTitle: 'Update your business started date');
    } else if (type == FormType.aboutStore){
      state = state.copyWith(businessDescriptionController: TextEditingController(text: data ?? ''), formTitle: 'Update something about your business');
    } else if (type == FormType.businessType){
      state = state.copyWith(businessType: data ?? '', formTitle: 'Update your business type');
    } else if (type == FormType.productCategory){
      state = state.copyWith(selectedProducts: data, formTitle: 'Update your product categories');
    } else if (type == FormType.emailID){
      state = state.copyWith(emailController: TextEditingController(text: data ?? ''), verifiedEmail: true, formTitle: 'Update your Email');
    } else if (type == FormType.mobileNumber){
      state = state.copyWith(mobileNumberController: TextEditingController(text: data ?? ''), verifiedMobile: true, formTitle: 'Update your mobile number');
    } else if (type == FormType.whatsAppNumber){
      state = state.copyWith(mobileNumberWhatsappController: TextEditingController(text: data ?? ''), verifiedWhatsApp: true, formTitle: 'Update your whatsApp number');
    } else if (type == FormType.panNumber){
      state = state.copyWith(panNumberController: TextEditingController(text: data ?? ''), formTitle: 'Update your PAN number');
    } else if (type == FormType.gstNumber){
      state = state.copyWith(gstNumberController: TextEditingController(text: data ?? ''), formTitle: 'Update your GST');
    } else if (type == FormType.fssaiNumber){
      state = state.copyWith(fssAiController: TextEditingController(text: data ?? ''), formTitle: 'Update your FSSAI code');
    } else if (type == FormType.bankDetails){
      final bankDetails = data as BankDetails?;

      state = state.copyWith(
        bankAccountNumberController: TextEditingController(text: bankDetails?.acNumber ?? ''),
        bankIFSCCodeController: TextEditingController(text: bankDetails?.ifscCode ?? ''),
          formTitle: 'Update your bank details'
      );

    } else if (type == FormType.personalProfile){
      callCountryListGepAPI(context);
      callStatesListGepAPI(context, 'IN');
      callCityListGepAPI(context, 'IN', 'KL');
      final profile = data as PersonalProfile?;

      state = state.copyWith(
        profileImage: profile?.image,
        fullNameController: TextEditingController(text: profile?.name ?? ''),
        dobController: TextEditingController(text: profile?.age ?? ''),
        gender: profile?.gender,
        buildNumberController: TextEditingController(text: profile?.flatBuildNo ?? ''),
        streetController: TextEditingController(text: profile?.street ?? ''),
        city: profile?.city,
        state: profile?.state,
        country: profile?.country,
        pinCodeController: TextEditingController(text: profile?.pinCode ?? ''),
          formTitle: 'Update your personal details'
      );

    }
  }



  FormFieldConfig? getFormFieldConfig(FormType type) {

    switch (type) {
      case FormType.panNumber:
        return FormFieldConfig(
          title: "PAN Number",
          placeHolder: "eg. ABCDE1234F",
          description: '',
          icon: Icons.badge_outlined,
          inputType: CustomInputType.pan,
          controller: state.panNumberController,
        );

      case FormType.gstNumber:
        return FormFieldConfig(
          title: "GST (Optional)",
          placeHolder: "eg. 22ABCDE1234F1Z5",
          description: 'GST registration is required for certain businesses under Indian tax laws. If you have a GST number, please add it here to ensure compliance and enable invoicing support.',
          icon: Icons.receipt_long,
          inputType: CustomInputType.gst,
          controller: state.gstNumberController,
        );

      case FormType.fssaiNumber:
        return FormFieldConfig(
          title: "FSSAI License (Optional)",
          placeHolder: "Enter fssai number",
          description: 'FSSAI registration is issued by the Food Safety and Standards Authority of India. Providing this helps verify food safety compliance and increases customer confidence.',
          icon: Icons.food_bank,
          inputType: CustomInputType.fssai,
          controller: state.fssAiController,
        );

      default:
        return null; // Other FormTypes don’t need a field
    }
  }


  void onChanged() {
    state = state.copyWith();
  }

  void updateBusinessType(String type) => state = state.copyWith(businessType: type);

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



  /// Mark:- Verify Button method
  bool showVerifyButton(FormType type, dynamic data){
    if (type == FormType.emailID){
      if (data == state.emailController.text.trim()){
        updateEmailVerified(true);
        return false;
      }
      return CodeReusability.isValidEmail(state.emailController.text.trim());
    } else if (type == FormType.mobileNumber){
      if (data == state.mobileNumberController.text.trim()){
        updateMobileNumberVerified(true);
        return false;
      }
      return CodeReusability.isValidMobileNumber(state.mobileNumberController.text.trim());
    } else {
      if (data == state.mobileNumberWhatsappController.text.trim()){
        updateWhatsAppVerified(true);
        return false;
      }
      return CodeReusability.isValidMobileNumber(state.mobileNumberWhatsappController.text.trim());
    }
  }


  /// Mark:- Update Verified boolean
  void updateMobileNumberVerified(bool isVerified){
    state = state.copyWith(verifiedMobile: isVerified);
  }

  void updateEmailVerified(bool isVerified){
    state = state.copyWith(verifiedEmail: isVerified);
  }

  void updateWhatsAppVerified(bool isVerified){
    state = state.copyWith(verifiedWhatsApp: isVerified);
  }

  /// Call this when location is selected from map/autocomplete
  void setSelectedLocation(LatLng location, String address) {
    state = state.copyWith(selectedLocation: location, selectPickupAddress: address);
  }

  /// Optional: clear location
  void clearSelectedLocation() {
    state = state.copyWith(selectedLocation: null, selectPickupAddress: '');
  }
  
  ///Mark:- Empty Validation for Pages
  bool canMoveToNext(int step) {
    //return true;
    if (step == 0) {
      final mobileNumber = state.mobileNumberController.text.trim();
      final email = state.emailController.text.trim();
      //final isWhatsApp = state.isWhatsApp ? true : (state.mobileNumberWhatsappController.text.trim().isNotEmpty && state.verifiedWhatsApp);

      return mobileNumber.isNotEmpty && CodeReusability.isValidMobileNumber(mobileNumber) &&
          email.isNotEmpty && CodeReusability.isValidEmail(email) && state.verifiedMobile &&
          state.verifiedEmail;// && isWhatsApp;
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



}

final accountUpdateScreenStateProvider =
StateNotifierProvider.autoDispose<AccountUpdateScreenStateNotifier, AccountUpdateScreenState>((ref) {
  return AccountUpdateScreenStateNotifier();
});

enum FormType {
  brandLogo,
  brandName,
  brandStartDate,
  aboutStore,
  businessType,
  productCategory,
  emailID,
  mobileNumber,
  whatsAppNumber,
  gstNumber,
  fssaiNumber,
  panNumber,
  personalProfile,
  bankDetails,
}

class PersonalProfile {
  final String image;
  final String name;
  final String age;
  final String gender;
  final String flatBuildNo;
  final String street;
  final String city;
  final String state;
  final String country;
  final String pinCode;


  PersonalProfile({
    required this.image,
    required this.name,
    required this.age,
    required this.gender,
    required this.flatBuildNo,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
  });
}

class FormFieldConfig {
  final String title;
  final String placeHolder;
  final String description;
  final IconData icon;
  final CustomInputType inputType;
  final TextEditingController controller;

  const FormFieldConfig({
    required this.title,
    required this.placeHolder,
    required this.description,
    required this.icon,
    required this.inputType,
    required this.controller,
  });
}

class BankDetails {
  final String acNumber;
  final String ifscCode;

  const BankDetails({
    required this.acNumber,
    required this.ifscCode,
});
}
