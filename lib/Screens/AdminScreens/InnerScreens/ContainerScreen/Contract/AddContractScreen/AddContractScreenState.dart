
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../Constants/Constants.dart';

class AddContractScreenState {
  final ScreenName currentModule;
  final TextEditingController companyNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController licenceController;
  final TextEditingController gstNumberController;
  final TextEditingController emailController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController mobileController;
  final TextEditingController pincodeController;

  AddContractScreenState({
    this.currentModule = ScreenName.home,
    required this.companyNameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.licenceController,
    required this.gstNumberController,
    required this.emailController,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    required this.mobileController,
    required this.pincodeController,
  });

  AddContractScreenState copyWith({
    ScreenName? currentModule,
    TextEditingController? companyNameController,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? licenceController,
    TextEditingController? gstNumberController,
    TextEditingController? emailController,
    TextEditingController? streetController,
    TextEditingController? cityController,
    TextEditingController? stateController,
    TextEditingController? countryController,
    TextEditingController? mobileController,
    TextEditingController? pincodeController,
  }) {
    return AddContractScreenState(
      currentModule: currentModule ?? this.currentModule,
      companyNameController: companyNameController ?? this.companyNameController,
      firstNameController: firstNameController ?? this.firstNameController,
      lastNameController: lastNameController ?? this.lastNameController,
      licenceController: licenceController ?? this.licenceController,
      gstNumberController: gstNumberController ?? this.gstNumberController,
      emailController: emailController ?? this.emailController,
      streetController: streetController ?? this.streetController,
      cityController: cityController ?? this.cityController,
      stateController: stateController ?? this.stateController,
      countryController: countryController ?? this.countryController,
      mobileController: mobileController ?? this.mobileController,
      pincodeController: pincodeController ?? this.pincodeController,
    );
  }
}

class AddContractScreenStateNotifier
    extends StateNotifier<AddContractScreenState> {
  AddContractScreenStateNotifier() : super(AddContractScreenState(
  companyNameController: TextEditingController(),
  firstNameController: TextEditingController(),
  lastNameController: TextEditingController(),
  licenceController: TextEditingController(),
  gstNumberController: TextEditingController(),
  emailController: TextEditingController(),
  streetController: TextEditingController(),
  stateController: TextEditingController(),
  cityController: TextEditingController(),
  countryController: TextEditingController(),
  mobileController: TextEditingController(),
    pincodeController: TextEditingController(),
  ));

  @override
  void dispose() {
    super.dispose();
  }


}

final AddContractScreenStateProvider = StateNotifierProvider.autoDispose<
    AddContractScreenStateNotifier, AddContractScreenState>((ref) {
  var notifier = AddContractScreenStateNotifier();
  return notifier;
});
