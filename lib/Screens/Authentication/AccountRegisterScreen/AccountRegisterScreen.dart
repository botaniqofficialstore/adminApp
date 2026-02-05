import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../Utility/ConfirmClosePopup.dart';
import '../../../Utility/NetworkImageLoader.dart';
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

  final List<String> genderType = [
    'Male',
    'Female',
    'Other',
  ];

  final List<String> productsType = [
    //Edibles
    'Fresh Produce',
    'Grains & Millets',
    'Oils, Ghee & Cooking Fats',
    'Meat, Eggs & Dairy',
    'Natural Sweeteners & Condiments',
    'Spices & Masalas',
    'Dry Fruits, Nuts & Seeds',
    'Ayurvedic Edibles (Internal Use)',
    'Beverages & Health Drinks',
    'Traditional Foods & Snacks',
    //Non edibles
    'Personal Care & Beauty',
    'Ayurvedic External Use',
    'Home Care & Cleaning',
    'Gardening & Farming',
    'Eco-Friendly & Sustainable Products',
    'Spiritual & Lifestyle'
  ];


  @override
  void initState() {
    Future.microtask((){
      var userScreenNotifier = ref.read(accountRegisterScreenStateProvider.notifier);
      userScreenNotifier.callCountryListGepAPI(context);
    });
    
    super.initState();
  }


  Future<void> backAction() async {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);
    final bool filledFields = notifier.canMoveToNext(state.currentStep);

    if (state.currentStep > 0) {
      //Previous page
      _pageController.previousPage(
        duration: 300.ms,
        curve: Curves.easeInOut,
      );
      notifier.setStep(state.currentStep - 1);
    } else if (state.currentStep == 0 && filledFields) {

      final bool shouldPop = await ConfirmClosePopup.show(context, title: "You're currently registering your business. If you exit now, all the information you've entered will be lost.",
          description: 'Would you like to continue registration or exit for now?') ?? false;

      if (shouldPop && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }

    } else {
      //Back to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
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
        backAction();
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
                        _stepWrapper(3, "Legal Information", "Upload your required Indian legal documents such as PAN, GST (if applicable), and FSSAI registration. These documents are mandatory to sell food and organic products legally in India.",
                            _buildStepFour()),
                        _stepWrapper(4, "Bank Details", "Enter your bank account information to receive payments for the orders you fulfill. These details are used to securely transfer your earnings directly to your account. Please ensure the account holder name, account number, and IFSC code are accurate to avoid payment delays.",
                          _buildStepFive(notifier),),
                        _stepWrapper(5, "Pickup location", "Please provide the correct pickup location where your products will be handed over for delivery. This address helps us ensure smooth order pickup, faster deliveries, and accurate service availability.",
                            _buildStepSix(notifier)),
                        _stepWrapper(6, "Working Days & Pickup Timings", "Select the days and time slots during which your store is operational and orders can be picked up. This helps our delivery partners schedule pickups efficiently and ensures timely order fulfillment without disruptions.",
                          _buildStepSeven(),),
                        _stepWrapper(7, "User Agreements", "Before you start selling organic products on our platform, please carefully read and accept the Seller User Agreement. "
                            "This agreement explains your legal responsibilities, payment terms, food safety obligations, delivery process, and compliance "
                            "with Indian laws such as FSSAI, GST, and Consumer Protection rules.",
                          _buildStepEight(),),
                      ],
                    ),
                  ),


                  ///Hide this view when keyboard appear
                  if (MediaQuery.of(context).viewInsets.bottom == 0)
                  _buildBottomBar(),

                  SizedBox(height: 5.dp,)
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
              backAction();


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
    const int totalSteps = 8;

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
              width: isCurrent ? 65.dp : 20.dp,
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

            SizedBox(height: 20.dp),


            CodeReusability().customTextField(
              context,
              "Mobile Number",
              "enter valid mobile number",
              Icons.phone,
              state.mobileNumberController,
              inputType: CustomInputType.mobile,
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


            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.dp),
              child: Divider(thickness: 0.5, color: Colors.black, height: 2.dp,),
            ),



            objCommonWidgets.customText(
              context,
              'Please Provide your WhatsApp number to get direct messages on orders and etc. ',
              10,
              Colors.black,
              objConstantFonts.montserratMedium,
            ),

            SizedBox(height: 5.dp),

            CodeReusability().commonRadioTextItem(
              context: context,
              text: 'My WhatsApp number is same as above.',
              value: state.isWhatsApp,
              onChanged: (bool newValue) {
                notifier.updateIsWhatApp(newValue);
              },
            ),

            CodeReusability().commonRadioTextItem(
              context: context,
              text: 'I have a different WhatsApp number.',
              value: !state.isWhatsApp,
              onChanged: (bool newValue) {
                notifier.updateIsWhatApp(!newValue);
              },
            ),


            if (!state.isWhatsApp)
              Padding(
                padding: EdgeInsets.only(top: 15.dp),
                child: CodeReusability().customTextField(
                  context,
                  "WhatsApp Number",
                  "enter your WhatsApp number",
                  Icons.phone,
                  state.mobileNumberWhatsappController,
                  inputType: CustomInputType.mobile,
                  prefixText: '+91',
                  onChanged: (_){
                    notifier.onChanged();
                    notifier.updateVerification(OtpVerifyType.whatsApp, false);
                  },
                  suffixWidget: state.verifiedWhatsApp == true ? CodeReusability().verified(context) :  notifier.showVerifyButtonForMobileNumberWhatsApp() ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      notifier.callOTPVerifyPopup(context, state.mobileNumberWhatsappController.text.trim(), false, OtpVerifyType.whatsApp);
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
              ),





          ],
        ),
      ),
    );
  }

  Widget _buildStepTwo(state, notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CodeReusability().customTextField(
          context,
          "Full Name",
          "enter your name",
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

        CodeReusability().customSingleDropdownField(
          context: context,
          placeholder: "Select Your Gender",
          items: genderType,
          selectedValue: state.gender,
          prefixIcon: Icons.wc,
          onChanged: (value) {
            setState(() {
              notifier.updateGender(value!);
            });
          },
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
            inputType: CustomInputType.pincode,
            onChanged: (_) => notifier.onChanged()
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customTextField(
            context,
            "Street",
            "enter your Street",
            Icons.signpost,
            state.streetController,
            inputType: CustomInputType.normal,
            onChanged: (_) => notifier.onChanged()
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customTextField(
            context,
            "Build/Flat no.",
            "enter your building or flat no.",
            Icons.home_work,
            state.buildNumberController,
            inputType: CustomInputType.normal,
            onChanged: (_) => notifier.onChanged()
        ),

        SizedBox(height: 20.dp),


        objCommonWidgets.customText(
          context,
          'Add your profile picture',
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),
        
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
      crossAxisAlignment: CrossAxisAlignment.start,
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

        SizedBox(height: 20.dp,),


        objCommonWidgets.customText(
          context,
          'Brand Logo',
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),

        objCommonWidgets.customText(
          context,
          'Upload your business/brand logo with good quality in format of jpg, jpeg or png',
          10,
          Colors.black,
          objConstantFonts.montserratRegular,
        ),
        SizedBox(height: 10.dp),

        Container(
          height: 220.dp,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: state.businessLogo.isEmpty
              ? CupertinoButton(
              onPressed: () => notifier.uploadLogo(context), // Call uploadImage for index 0
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: _buildAddPlaceholder())
              : Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetworkImageLoader(
                  imageUrl: state.businessLogo,
                  placeHolder: objConstantAssest.placeholderImage,
                  size: 80.dp,
                  imageSize: double.infinity,
                  isLocal: CodeReusability().isNotValidUrl(state.businessLogo),
                ),
              ),
              _buildDeleteButton(() {
                notifier.updateBusinessLogo('');
              }),
            ],
          ),
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customTextView(
            context,
            "Tell us about your business",
            "Enter your description",
            description: 'This information will be visible to customers and helps them make confident purchase decisions. Please ensure all details are accurate and genuine.',
            Icons.description_outlined,
            state.businessDescriptionController,
            onChanged: (_) => notifier.onChanged()
        ),

        SizedBox(height: 20.dp),



        objCommonWidgets.customText(
          context,
          'Select Product Categories',
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),

        objCommonWidgets.customText(
          context,
          'Select the types of organic products you want to sell on our app. Choose one or more categories that match your offerings to help us set up your seller account correctly.',
          10,
          Colors.black,
          objConstantFonts.montserratRegular,
        ),
        SizedBox(height: 10.dp),

        // Modern Selection Grid using Wrap
        Wrap(
          spacing: 10.0,
          runSpacing: 5,
          children: productsType.map((product) {
            final isSelected = state.selectedProducts.contains(product);
            return FilterChip(
              selected: isSelected,
              onSelected: (_) => notifier.toggleProductSelection(product),

              showCheckmark: false, // 🚫 remove default big tick

              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      size: 12.dp,
                      color: Colors.white,
                    ),
                  if (isSelected) SizedBox(width: 4.dp),

                  objCommonWidgets.customText(
                    context,
                    product,
                    10,
                    isSelected ? Colors.white : Colors.black87,
                    isSelected ? objConstantFonts.montserratMedium : objConstantFonts.montserratRegular,
                  ),

                ],
              ),

              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
              padding: EdgeInsets.symmetric(horizontal: isSelected ? 0 : 5.dp, vertical: 6.dp),

              backgroundColor: Colors.grey[100],
              selectedColor: Colors.black,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.dp),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey[300]!,
                ),
              ),
            );

          }).toList(),
        ),




      ],
    );
  }

  Widget _buildStepFour() {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return Column(
      children: [
        CodeReusability().customTextField(
          context,
          "PAN Number",
          "eg. ABCDE1234F",
          Icons.badge_outlined,
          state.panNumberController,
          inputType: CustomInputType.pan,
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customTextField(
          context,
          "GST (Optional)",
          "eg. 22ABCDE1234F1Z5",
          description: 'GST registration is required for certain businesses under Indian tax laws. If you have a GST number, please add it here to ensure compliance and enable invoicing support.',
          Icons.receipt_long,
          state.gstNumberController,
          inputType: CustomInputType.pan,
        ),

        SizedBox(height: 20.dp),

        CodeReusability().customTextField(
          context,
          "FSSAI License (Optional)",
          "Enter fssai number",
          description: 'FSSAI registration is issued by the Food Safety and Standards Authority of India. Providing this helps verify food safety compliance and increases customer confidence.',
          Icons.food_bank,
          state.fssAiController,
          inputType: CustomInputType.fssai,
        ),

        /// Validation Message
        if (state.isFssAiNeeded && state.fssAiController.text.trim().isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 10.dp),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(20),
                borderRadius: BorderRadius.circular(5.dp),
                border: Border.all(color: Colors.red)
              ),
              padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 10.dp),
              child: objCommonWidgets.customText(context, "You are selling edible products so you must add your FSSAI number to complete this step",
                  10, Colors.red, objConstantFonts.montserratMedium, textAlign: TextAlign.center),
            ),
          )
      ],
    );
  }


  Widget _buildStepFive(notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);

    return Column(
      children: [

        /// Bank Account Number
        CodeReusability().customTextField(
          context,
          "Account Number",
          "eg. 123456789012",
          Icons.account_balance_outlined,
          state.bankAccountNumberController,
          inputType: CustomInputType.bankAccount,
        ),

        SizedBox(height: 20.dp),

        /// IFSC Code
        CodeReusability().customTextField(
          context,
          "IFSC Code",
          "eg. HDFC0001234",
          Icons.confirmation_number_outlined,
          state.bankIFSCCodeController,
          inputType: CustomInputType.ifsc,
        ),
      ],
    );
  }


  Widget _buildStepSix(notifier) {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);
    String btnText = state.selectedLocation == null ? 'Pick Location' : 'Change Location';

    return Column(
      children: [

        if (state.selectedLocation != null)
          Padding(
            padding: EdgeInsets.only(bottom: 15.dp),
            child: Container(
              padding: EdgeInsets.all(14.dp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.dp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.dp),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.deepOrange,
                      size: 20.dp,
                    ),
                  ),
                  SizedBox(width: 10.dp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(context, 'Selected location', 10, Colors.black, objConstantFonts.montserratRegular),
                        SizedBox(height: 4.dp),
                        objCommonWidgets.customText(context, state.selectPickupAddress, 12, Colors.black, objConstantFonts.montserratMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),



        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 10.dp),
                  decoration: BoxDecoration(
                      color: Color(0xFF4D7BFA),
                      borderRadius: BorderRadius.circular(20.dp)
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.white, size: 15.dp),
                        SizedBox(width: 5.dp,),
                        objCommonWidgets.customText(context, btnText, 10, Colors.white, objConstantFonts.montserratSemiBold),
                      ],
                    ),
                  ),
                ), onPressed: ()=> notifier.callMapPopup(context)),
          ],
        )
      ],
    );
  }

  Widget _buildStepSeven() {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20.dp)
                  ),
              padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
              child: Row(
                children: [
                  Icon(Icons.copy_all, size: 15.dp, color: Colors.white),
                  SizedBox(width: 2.5.dp),
                  objCommonWidgets.customText(context, 'Apply Monday to all', 10, Colors.white, objConstantFonts.montserratMedium)
                ],
              ),
            ), onPressed: () => notifier.copyMondayToAll())
          ],
        ),

        SizedBox(height: 10.dp),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          separatorBuilder: (_, __) => Divider(height: 0, color: Colors.black, thickness: 0.3,),
          itemBuilder: (context, index) {
            final day = days[index];
            final schedule = state.weeklySchedule[day]!;
            final inValidCloseTime = (schedule.closeTime.hour * 60 + schedule.closeTime.minute) <=
                (schedule.openTime.hour * 60 + schedule.openTime.minute);

            return Container(
              padding: EdgeInsets.symmetric(vertical: 5.dp),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: objCommonWidgets.customText(context,
                            day, 13,
                            schedule.isOpen ? Colors.black : Colors.black.withAlpha(100),
                            objConstantFonts.montserratMedium),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeTrackColor: Colors.green,
                          value: schedule.isOpen,
                          onChanged: (val) => notifier.toggleDay(day),
                        ),
                      ),
                    ],
                  ),
                  if (schedule.isOpen) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 5.dp, bottom: 15.dp),
                      child: Row(
                        children: [
                          _timePickerBox(
                            context,
                            label: "Opens at",
                            time: schedule.openTime,
                            onTap: () async {
                              final picked = await showTimePicker(context: context, initialTime: schedule.openTime);
                              if (picked != null) notifier.updateTime(day, true, picked);
                            },
                          ),
                           Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.dp),
                            child: objCommonWidgets.customText(context,
                                'to', 13,
                                Colors.black,
                                objConstantFonts.montserratMedium),
                          ),
                          _timePickerBox(
                            context,
                            label: "Closes at",
                            time: schedule.closeTime,
                            error: inValidCloseTime,
                            onTap: () async {
                              final picked = await showTimePicker(context: context, initialTime: schedule.closeTime);
                              if (picked != null) notifier.updateTime(day, false, picked);
                            },
                          ),
                        ],
                      ),
                    ),

                    if (inValidCloseTime)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.dp),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red.withAlpha(35),
                                  borderRadius: BorderRadius.circular(20.dp)
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                              child: Row(
                                children: [
                                  Icon(Icons.warning_rounded, size: 12.dp, color: Colors.red),
                                  SizedBox(width: 2.5.dp),
                                  objCommonWidgets.customText(context, 'Please enter valid closing time!', 8, Colors.red, objConstantFonts.montserratMedium),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ]
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepEight() {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);
    final agreements = state.sellerAgreementSections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: agreements.map((section) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.dp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(
                    context,
                    section.title,
                    10,
                    Colors.black,
                    objConstantFonts.montserratSemiBold,
                  ),

                  SizedBox(height: 4.dp),

                  ...section.points.map((point) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10.dp, bottom: 4.dp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // ✅ KEY FIX
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4.dp), // fine-tune alignment
                            child: Icon(
                              Icons.circle,
                              size: 5.dp,
                              color: Colors.black.withAlpha(150),
                            ),
                          ),
                          SizedBox(width: 4.dp),
                          Expanded(
                            child: objCommonWidgets.customText(
                              context,
                              point,
                              10,
                              Colors.black87,
                              objConstantFonts.montserratRegular,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                ],
              ),
            );
          }).toList(),
        ),



        /// Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: state.isAgreementAccepted,
              checkColor: Colors.white, // ✔ color
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.green;
                }
                return Colors.transparent;
              }),
              onChanged: (value) {
                notifier.updateReadedAgreement(value ?? false);
              },
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  notifier.updateReadedAgreement(!state.isAgreementAccepted);
                },
                child: Padding(
                  padding:  EdgeInsets.only(top: 10.dp),
                  child: objCommonWidgets.customText(context, "I have read, understood, and agree to the Seller User Agreement, "
                      "Privacy Policy, and applicable Indian laws.", 10, Colors.black, objConstantFonts.montserratMedium),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10.dp),

        /// Validation Message
        if (!state.isAgreementAccepted)
          objCommonWidgets.customText(context, "You must accept the agreement to continue.",
              10, Colors.red, objConstantFonts.montserratMedium)

      ],
    );
  }



  Widget _buildAddPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: Colors.deepOrange, size: 24.dp),
          SizedBox(height: 8.dp),
          objCommonWidgets.customText(context, "Tap to Upload", 10, Colors.grey.shade600, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(VoidCallback onTap) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.close, color: Colors.red, size: 16),
        ),
      ),
    );
  }






  Widget _timePickerBox(BuildContext context, {
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
    bool error = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5.dp),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: error ? Colors.red : Colors.black.withAlpha(100)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(context,
                  label, 9,
                  Colors.black,
                  objConstantFonts.montserratMedium),
              SizedBox(height: 2.dp),
              objCommonWidgets.customText(context,
                  time.format(context), 13,
                  Colors.black,
                  objConstantFonts.montserratSemiBold),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBottomBar() {
    final state = ref.watch(accountRegisterScreenStateProvider);
    final notifier = ref.read(accountRegisterScreenStateProvider.notifier);
    final bool isLastStep = state.currentStep == 7;
    final bool canProceed = notifier.canMoveToNext(state.currentStep);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.dp, vertical: 5.dp),
      child: Row(
        children: [



          /// NEXT / FINISH BUTTON
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: CupertinoButton(
                onPressed: (!canProceed || state.isPageAnimating)
                    ? null
                    : () async {
                  CodeReusability.hideKeyboard(context);

                  if (isLastStep) {
                    notifier.callRegistrationAPI(context);
                    return;
                  }

                  notifier.startPageAnimation();

                  await _pageController.nextPage(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  );

                  notifier.setStep(state.currentStep + 1);
                  notifier.endPageAnimation();
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
                      isLastStep ? "Confirm & Submit" : "Next Step",
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