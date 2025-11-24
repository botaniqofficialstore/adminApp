
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';

class AddDeliveryPartnerScreenState {
  final ScreenName currentModule;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController licenceController;
  final TextEditingController emailController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController mobileController;
  final TextEditingController pincodeController;
  final TextEditingController aadharController;
  final String? profileImagePath;
  final String? licenceFrontImagePath;
  final String? licenceRearImagePath;
  final String? dob;
  final String? gender;

  AddDeliveryPartnerScreenState({
    this.currentModule = ScreenName.home,
    required this.firstNameController,
    required this.lastNameController,
    required this.licenceController,
    required this.emailController,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.mobileController,
    required this.pincodeController,
    required this.aadharController,
    this.profileImagePath,
    this.licenceFrontImagePath,
    this.licenceRearImagePath,
    this.dob,
    this.gender,
  });

  AddDeliveryPartnerScreenState copyWith({
    ScreenName? currentModule,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? licenceController,
    TextEditingController? emailController,
    TextEditingController? streetController,
    TextEditingController? cityController,
    TextEditingController? stateController,
    TextEditingController? countryController,
    TextEditingController? mobileController,
    TextEditingController? pincodeController,
    TextEditingController? aadharController,
    String? profileImagePath,
    String? licenceFrontImagePath,
    String? licenceRearImagePath,
    String? dob,
    String? gender,
  }) {
    return AddDeliveryPartnerScreenState(
      currentModule: currentModule ?? this.currentModule,
      firstNameController: firstNameController ?? this.firstNameController,
      lastNameController: lastNameController ?? this.lastNameController,
      licenceController: licenceController ?? this.licenceController,
      emailController: emailController ?? this.emailController,
      streetController: streetController ?? this.streetController,
      cityController: cityController ?? this.cityController,
      stateController: stateController ?? this.stateController,
      countryController: countryController ?? this.countryController,
      mobileController: mobileController ?? this.mobileController,
      pincodeController: pincodeController ?? this.pincodeController,
      aadharController: aadharController ?? this.aadharController,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      licenceFrontImagePath: licenceFrontImagePath ?? this.licenceFrontImagePath,
      licenceRearImagePath: licenceRearImagePath ?? this.licenceRearImagePath,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}

class AddDeliveryPartnerScreenStateNotifier
    extends StateNotifier<AddDeliveryPartnerScreenState> {
  AddDeliveryPartnerScreenStateNotifier() : super(AddDeliveryPartnerScreenState(
    firstNameController: TextEditingController(),
    lastNameController: TextEditingController(),
    licenceController: TextEditingController(),
    emailController: TextEditingController(),
    streetController: TextEditingController(),
    stateController: TextEditingController(),
    cityController: TextEditingController(),
    countryController: TextEditingController(),
    mobileController: TextEditingController(),
    pincodeController: TextEditingController(),
    aadharController: TextEditingController(),
  ));

  @override
  void dispose() {
    // Dispose controllers to avoid leaks
    state.firstNameController.dispose();
    state.lastNameController.dispose();
    state.licenceController.dispose();
    state.emailController.dispose();
    state.streetController.dispose();
    state.cityController.dispose();
    state.stateController.dispose();
    state.countryController.dispose();
    state.mobileController.dispose();
    state.pincodeController.dispose();
    state.aadharController.dispose();
    super.dispose();
  }

  void setProfileImagePath(String path) {
    state = state.copyWith(profileImagePath: path);
  }

  void setLicenceFrontImagePath(String path) {
    state = state.copyWith(licenceFrontImagePath: path);
  }

  void setLicenceRearImagePath(String path) {
    state = state.copyWith(licenceRearImagePath: path);
  }

  void updateDOB(String dob){
    state = state.copyWith(dob: dob);
  }

  void updateGender(String gender){
    state = state.copyWith(gender: gender);
  }




}

final AddDeliveryPartnerScreenStateProvider = StateNotifierProvider.autoDispose<
    AddDeliveryPartnerScreenStateNotifier, AddDeliveryPartnerScreenState>((ref) {
  var notifier = AddDeliveryPartnerScreenStateNotifier();
  return notifier;
});
