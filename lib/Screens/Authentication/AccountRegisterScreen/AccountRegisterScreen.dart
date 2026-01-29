import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../LoginScreen/LoginScreen.dart';
import 'AccountRegisterModel.dart';
import 'AccountRegisterScreenState.dart';


class AccountRegisterScreen extends ConsumerStatefulWidget {
  const AccountRegisterScreen({super.key});

  @override
  AccountRegisterScreenState createState() => AccountRegisterScreenState();
}

class AccountRegisterScreenState extends ConsumerState<AccountRegisterScreen>  {
  final PageController _pageController = PageController();

  final List<String> businessType = [
    'Individual / Proprietorship',
    'Partnership',
    'LLP / Private Limited',
  ];


  @override
  void initState() {
    Future.microtask((){
      var userScreenNotifier = ref.read(accountRegisterScreenStateProvider.notifier);
      userScreenNotifier.callCountryListGepAPI(context);
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return PopScope(
      canPop: false, // 🔥 We fully control back navigation
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // optional
          statusBarIconBrightness: Brightness.dark, // ANDROID → black icons
          statusBarBrightness: Brightness.light, // iOS → black icons
        ),
        child: GestureDetector(
          onTap: () => CodeReusability.hideKeyboard(context),
          child: Scaffold(
            backgroundColor: Color(0xFFF9FAFB),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  SizedBox(height: 5.dp,),
                  objCommonWidgets.customText(context, 'Complete all the requirements.', 12, Colors.black, objConstantFonts.montserratMedium),
                  SizedBox(height: 5.dp,),
                  _buildStepper(state),


                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      pageSnapping: false,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _stepWrapper(0, "Account Setup", "Create your seller account using a verified mobile number and email address. This will be used for login, order updates, important notifications, and secure communication related to your seller account.",
                            _buildStepOne(notifier)),
                        _stepWrapper(1, "Personal Details", "Provide your basic personal information to verify your identity as a seller. These details help us comply with Indian KYC regulations and ensure secure payouts and legal communication when required.",
                            _buildStepTwo(state, notifier)),
                        _stepWrapper(2, "Business Profile", "Tell us about your business or brand. Add your store name, business type, and the kind of organic or homemade products you sell so customers can easily recognize and trust your store.",
                            _buildStepThree()),


                        _stepWrapper(3, "Health Benefits", "Highlight the nutritional value of your product. Add details about vitamins and their benefits to help customers understand how your product supports a healthy lifestyle.",
                            _buildStepFour()),
                        _stepWrapper(4, "Inventory", "Manage availability efficiently. Enter the current stock quantity to ensure accurate inventory tracking and avoid overselling.",
                            _buildStepFive(notifier)),
                        _stepWrapper(5, "Delivery Timeline", "Specify how many days it will take for the order to reach the customer. Clear delivery timelines improve trust and reduce order-related queries.",
                            _buildStepSix(notifier)),
                      ],
                    ),
                  ),


                  ///Hide this view when keyboard appear
                  if (MediaQuery.of(context).viewInsets.bottom == 0)
                  _buildBottomBar(state, notifier),

                  SizedBox(height: 20.dp,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 10.dp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            child: Icon(Icons.arrow_back_rounded, size: 25.dp, color: Colors.black,),
          ),
          objCommonWidgets.customText(context, 'Register', 18, Colors.black, objConstantFonts.montserratSemiBold),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildStepper(state) {
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);
    const int totalSteps = 6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final bool isCompleted = index < state.maxCompletedStep;
        final bool isCurrent = index == state.currentStep;
        final bool isLastStep = index == totalSteps - 1;

        // 🔹 Only affects final step when fully valid
        final bool isFinalStepCompleted = isLastStep && notifier.canMoveToNext(index);

        Color stepColor;

        // 🔹 RULE #1: Completed steps → GREEN (ALWAYS)
        if (isCompleted) {
          stepColor = Colors.green.shade600;
          // 🔹 RULE #2: Final step completed → GREEN
        } else if (isFinalStepCompleted) {
          stepColor = Colors.green.shade600;
          // 🔹 RULE #3: Current step → ORANGE
        } else if (isCurrent) {
          stepColor = Colors.deepOrange.shade600;
          // 🔹 RULE #4: Upcoming
        } else {
          stepColor = Colors.grey.shade300;
        }


        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: isCurrent ? 65.dp : 25.dp,
              height: 6.dp,
              decoration: BoxDecoration(
                color: stepColor,
                borderRadius: BorderRadius.circular(12.dp),
              ),
            ),
            if (index != totalSteps - 1) SizedBox(width: 6.dp),
          ],
        );
      }),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2);
  }








  Widget _stepWrapper(int index, String title, String desc, Widget child) {

    return RawScrollbar(
      thumbColor: objConstantColor.black.withAlpha(45),
      radius: const Radius.circular(20),
      thickness: 4,
      thumbVisibility: false,
      interactive: true,
      child: SingleChildScrollView(
        // This forces the bounce even if the content is smaller than the screen
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.symmetric(vertical: 20.dp, horizontal: 15.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            objCommonWidgets.customText(context, title, 20, Colors.black, objConstantFonts.montserratBold),
            SizedBox(height: 5.dp),
            objCommonWidgets.customText(context, desc, 11, Colors.black, objConstantFonts.montserratRegular),
            SizedBox(height: 25.dp),
            child,
            //SizedBox(height: 25.dp),

          ],
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
      ),
    );
  }

  // --- STEP CONTENT ---

  Widget _buildStepOne(notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return RawScrollbar(
      thumbColor: objConstantColor.black.withAlpha(45),
      radius: const Radius.circular(20),
      thickness: 4,
      thumbVisibility: false,
      interactive: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [

            CodeReusability().customTextField(
              context,
              "Mobile Number",
              "enter valid mobile number",
              Icons.phone,
              state.mobileNumberController,
              keyboardType: TextInputType.number,
              prefixText: '+91',
              onChanged: (_){
                notifier.onChanged();
                notifier.updateVerification(OtpVerifyType.mobile, false);
              },
              suffixWidget: state.verifiedMobile == true ? CodeReusability().verified(context) :  notifier.showVerifyButtonForMobileNumber() ? CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () {
                  notifier.callOTPVerifyPopup(context, state.mobileNumberController.text.trim(), false, OtpVerifyType.mobile);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 8.dp),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(6.dp),
                  ),
                  child: objCommonWidgets.customText(
                    context,
                    'Verify',
                    10,
                    Colors.white,
                    objConstantFonts.montserratMedium,
                  ),
                ),
              ) : null,
            ),



            SizedBox(height: 20.dp),
            CodeReusability().customTextField(
              context,
              "Email Address", "enter valid email address",
                Icons.mail_outline_rounded,
                state.emailController,onChanged: (_){
                notifier.onChanged();
                notifier.updateVerification(OtpVerifyType.email, false);
              },
              suffixWidget: state.verifiedEmail == true ? CodeReusability().verified(context) :  notifier.showVerifyButtonForEmail() ? CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () {
                  notifier.callOTPVerifyPopup(context, state.emailController.text.trim(), true, OtpVerifyType.email);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 8.dp),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(6.dp),
                  ),
                  child: objCommonWidgets.customText(
                    context,
                    'Verify',
                    10,
                    Colors.white,
                    objConstantFonts.montserratMedium,
                  ),
                ),
              ) : null,),

          ],
        ),
      ),
    );
  }

  Widget _buildStepTwo(state, notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return Column(
      children: [
        CodeReusability().customTextField(
          context,
          "Full Name",
          "enter your name as per PAN",
          Icons.person_2_outlined,
          state.fullNameController,
          onChanged: (_) => notifier.onChanged()
        ),

        SizedBox(height: 20.dp),

        CodeReusability().datePickerTextField(
          context,
          "Date of birth",
          "select your date of birth",
          Icons.calendar_today,
          state.dobController,
        ),

        SizedBox(height: 20.dp),

        /// COUNTRY
        CodeReusability().commonDropdownTextField<CountryModel>(
          context: context,
          hint: "Country",
          label: "select country",
          icon: Icons.public,
          value: state.country,
          items: state.countryList,
          isLoading: state.isLoading,
          displayText: (c) => c.name,
          onTapValidation: () {},
          onSelected: (country) {
            notifier.callStatesListGepAPI(context, country.iso2);
            notifier.updateCountry(country.name, country.iso2);
          },
        ),

        SizedBox(height: 20.dp),

        /// STATE
        CodeReusability().commonDropdownTextField<StateModel>(
          context: context,
          hint: "State",
          label: "select state",
          icon: Icons.map,
          value: state.state,
          items: state.stateList,
          onTapValidation: () {
            if (state.country.isEmpty) {
              CodeReusability().showAlert(
                context,
                'Please select country first',
              );
            }
          },
          displayText: (s) => s.name,
          onSelected: (stateModel) {
            notifier.callCityListGepAPI(
              context,
              state.selectedCountryCode,
              stateModel.iso2,
            );
            notifier.updateState(stateModel.name, stateModel.iso2);
          },
        ),


        SizedBox(height: 20.dp),

        /// CITY
        CodeReusability().commonDropdownTextField<CityModel>(
          context: context,
          hint: "District / City",
          label: "select district",
          icon: Icons.location_city,
          value: state.city,
          items: state.cityList,
          onTapValidation: () {
            if (state.country.isEmpty) {
              CodeReusability().showAlert(context,
                'Please select country first',
              );
            } else  if (state.state.isEmpty){
              CodeReusability().showAlert(context,
                'Please select state',
              );
            }
          },
          displayText: (c) => c.name,
          onSelected: (city) {
            notifier.updateCity(city.name, city.id);
          },
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customTextField(
            context,
            "Pin code",
            "enter your pin code",
            Icons.markunread_mailbox,
            state.pinCodeController,
            keyboardType: TextInputType.number,
            onChanged: (_) => notifier.onChanged()
        ),



        SizedBox(height: 20.dp),
        
        Row(
          children: [

            CircleAvatar(
              radius: 30.dp,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 29.dp,
                backgroundImage: state.profileImage.isEmpty
                    ? AssetImage(objConstantAssest.defaultProfileImage)
                    : FileImage(File(state.profileImage)),
              ),
            ),

            SizedBox(width: 15.dp),

            CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 13.dp),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20.dp)
              ),
              child: Center(
                child: objCommonWidgets.customText(context, 'Upload Photo', 10, Colors.white, objConstantFonts.montserratSemiBold),
              ),
            ), onPressed: (){
                  notifier.uploadImage(context);
            })
          ],
        )
      ],
    );
  }


  Widget _buildStepThree() {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return Column(
      children: [
        CodeReusability().customTextField(
            context,
            "Store / Brand Name",
            "enter your store or brand name",
            Icons.person,
            state.brandNameController,
            onChanged: (_) => notifier.onChanged()
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customSingleDropdownField(
          context: context,
          placeholder: "Select Business Type",
          items: businessType,
          selectedValue: state.businessType,
          prefixIcon: Icons.business_center,
          onChanged: (value) {
            setState(() {
              notifier.updateBusinessType(value!);
            });
          },
        ),

        SizedBox(height: 20.dp),

        CodeReusability().datePickerTextField(
          context,
          "Date of business started",
          "select date",
          Icons.calendar_today,
          state.businessStartedDateController,
          minimumAge: 0
        ),


        SizedBox(height: 20.dp),

        CodeReusability().customTextView(
          context,
          "Tell us about your business",
          "Enter your description",
          Icons.description_outlined,
          state.businessDescriptionController,
            onChanged: (_) => notifier.onChanged()
        )

      ],
    );
  }

  Widget _buildStepFour() {
    final state = ref.watch(accountRegisterScreenStateProvider);

    return Column(
      children: [

      ],
    );
  }


  Widget _buildStepFive(notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);

    return Column(
      children: [

      ],
    );
  }

  Widget _buildStepSix(notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return Column(
      children: [

      ],
    );
  }


  Widget _buildBottomBar(state, notifier) {
    final bool isLastStep = state.currentStep == 5;
    final bool canProceed = notifier.canMoveToNext(state.currentStep);
    final bool showBack = state.currentStep > 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.dp, vertical: 10.dp),
      child: Row(
        children: [
          /// BACK BUTTON
          if (showBack)
            Expanded(
              flex: showBack ? 1 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: showBack ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !showBack,
                  child: CupertinoButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      );
                      notifier.setStep(state.currentStep - 1);
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.dp),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(25.dp),
                      ),
                      child: Center(
                        child: objCommonWidgets.customText(
                          context,
                          "Back",
                          14,
                          Colors.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          /// GAP
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: showBack ? 12.dp : 0,
          ),

          /// NEXT / FINISH BUTTON
          Expanded(
            flex: showBack ? 1 : 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: CupertinoButton(
                onPressed: !canProceed
                    ? null
                    : () {
                  CodeReusability.hideKeyboard(context);
                  if (isLastStep) {
                    notifier.showVerificationPopup(context);
                    ///Completed
                  } else {
                    _pageController.nextPage(
                      duration: 300.ms,
                      curve: Curves.easeInOut,
                    );
                    notifier.setStep(state.currentStep + 1);
                  }
                },
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.dp),
                  decoration: BoxDecoration(
                    color: canProceed
                        ? (isLastStep ? Colors.green : Colors.black )
                        : Colors.grey.withAlpha(85),
                    borderRadius: BorderRadius.circular(25.dp),
                  ),
                  child: Center(
                    child: objCommonWidgets.customText(
                      context,
                      isLastStep ? "Submit" : "Next Step",
                      14,
                      Colors.white,
                      objConstantFonts.montserratBold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }












}