
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
    super.dispose();
  }


}

final AddDeliveryPartnerScreenStateProvider = StateNotifierProvider.autoDispose<
    AddDeliveryPartnerScreenStateNotifier, AddDeliveryPartnerScreenState>((ref) {
  var notifier = AddDeliveryPartnerScreenStateNotifier();
  return notifier;
});
