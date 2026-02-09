import 'dart:io';

import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../CodeReusable/CodeReusability.dart';
import '../../Screens/Authentication/AccountRegisterScreen/AccountRegisterModel.dart';
import '../../Screens/Authentication/AccountRegisterScreen/AccountRegisterScreenState.dart';
import '../../Utility/NetworkImageLoader.dart';
import 'AccountUpdateScreenState.dart';

class AccountUpdateScreen extends ConsumerStatefulWidget {
  final FormType formType;
  final dynamic initialData;

  const AccountUpdateScreen({
    super.key,
    required this.formType,
    this.initialData,
  });

  @override
  AccountUpdatePopupState createState() => AccountUpdatePopupState();
}


class AccountUpdatePopupState extends ConsumerState<AccountUpdateScreen> {

  late dynamic _value;

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
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(accountUpdateScreenStateProvider.notifier);
      notifier.updateInitialData(context, widget.formType, widget.initialData);
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountUpdateScreenStateProvider);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp),
            child: Column(
              children: [

                /// HEADER
                SizedBox(height: 10.dp),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black,
                        size: 20.dp,
                      ),
                    ),
                    SizedBox(width: 5.dp),
                    Flexible(
                      child: objCommonWidgets.customText(
                        context,
                        state.formTitle,
                        14,
                        objConstantColor.black,
                        objConstantFonts.montserratMedium,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.dp),

                /// SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: buildForm(),
                  ),
                ),

                /// STICKY SAVE BUTTON (HIDDEN ON KEYBOARD)
                if (!isKeyboardOpen)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 10.dp,
                      top: 10.dp,
                    ),
                    child: CupertinoButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.dp),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25.dp),
                        ),
                        child: Center(
                          child: objCommonWidgets.customText(
                            context,
                            "Save",
                            14,
                            Colors.white,
                            objConstantFonts.montserratBold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildForm() {
    switch (widget.formType) {
      case FormType.personalProfile:
        return personalProfileView();

      case FormType.brandName:
        return brandNameView();

      case FormType.brandLogo:
        return brandLogoView();

      case FormType.brandStartDate:
        return brandStartDate();

      case FormType.aboutStore:
        return aboutStoreView();

      case FormType.businessType:
        return businessTypeView();

      case FormType.productCategory:
        return productCategoriesView();

      case FormType.emailID:
        return emailIDView();

      case FormType.mobileNumber:
        return mobileNumberView(FormType.mobileNumber, widget.initialData);

      case FormType.whatsAppNumber:
        return mobileNumberView(FormType.whatsAppNumber, widget.initialData);

      case FormType.gstNumber:
        return textFieldView(FormType.gstNumber);

      case FormType.panNumber:
        return textFieldView(FormType.panNumber);

      case FormType.fssaiNumber:
        return textFieldView(FormType.fssaiNumber);

      case FormType.bankDetails:
        return bankDetailsView();

      }
  }

  Widget bankDetailsView(){
    final state = ref.watch(accountUpdateScreenStateProvider);

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

  Widget personalProfileView(){
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);
    final bool isEmpty = state.profileImage.isEmpty;
    final bool isNetworkImage = !CodeReusability().isNotValidUrl(state.profileImage);

    return Column(
      children: [

        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 35.dp,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 34.dp,
                backgroundImage: isEmpty
                    ? AssetImage(objConstantAssest.defaultProfileImage)
                    : isNetworkImage
                    ? NetworkImage(state.profileImage)
                    : FileImage(File(state.profileImage)) as ImageProvider,
              ),
            ),

            Positioned(
              bottom: 0.dp,
              right: 0.dp,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () => notifier.uploadImage(context),
                child: Container(
                  padding: EdgeInsets.all(5.dp),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 12.dp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),


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

        SizedBox(height: 10.dp),

      ],
    );
  }

  Widget textFieldView(FormType type){
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);

    final config = notifier.getFormFieldConfig(widget.formType);
    if (config == null) return const SizedBox();


    return CodeReusability().customTextField(
      context,
      config.title,
      config.placeHolder,
      description: config.description,
      config.icon,
      config.controller,
      inputType: config.inputType,
    );
  }

  Widget emailIDView() {
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);

    return CodeReusability().customTextField(
      context,
      "Email Address", "enter valid email address",
      Icons.mail_outline_rounded,
      state.emailController,onChanged: (_){
      notifier.onChanged();
      notifier.updateVerification(OtpVerifyType.email, false);
    },
      suffixWidget: state.verifiedEmail == true ? CodeReusability().verified(context) :  notifier.showVerifyButton(widget.formType, widget.initialData) ? CupertinoButton(
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
      ) : null,);
  }

  Widget mobileNumberView(FormType type, dynamic initialData) {
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);
    final controller = (type == FormType.whatsAppNumber)
        ? state.mobileNumberWhatsappController
        : state.mobileNumberController;

    final verified = (type == FormType.whatsAppNumber)
        ? state.verifiedWhatsApp
        : state.verifiedMobile;

    final otpType = (type == FormType.whatsAppNumber)
        ? OtpVerifyType.whatsApp
        : OtpVerifyType.mobile;

    final title = (type == FormType.whatsAppNumber)
        ? 'WhatsApp Number'
        : 'Mobile Number';

    final placeHolder = (type == FormType.whatsAppNumber)
        ? 'enter valid mobile number'
        : 'enter valid whatsApp mobile number';

    return CodeReusability().customTextField(
      context,
      title,
      placeHolder,
      Icons.phone,
      controller,
      inputType: CustomInputType.mobile,
      prefixText: '+91',
      onChanged: (_){
        notifier.onChanged();
        notifier.updateVerification(otpType, false);
      },
      suffixWidget: verified ? CodeReusability().verified(context) :  notifier.showVerifyButton(type, initialData ) ? CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: () {
          notifier.callOTPVerifyPopup(context, (type == FormType.mobileNumber) ? state.mobileNumberController.text.trim() : state.mobileNumberWhatsappController.text.trim(), false, OtpVerifyType.mobile);
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
    );
  }


  Widget productCategoriesView(){
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);

    return Column(
      children: [
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

  Widget businessTypeView(){
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);

    return CodeReusability().customSingleDropdownField(
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
    );

  }

  Widget aboutStoreView(){
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);

    return CodeReusability().customTextView(
        context,
        "Tell us about your business",
        "Enter your description",
        description: 'This information will be visible to customers and helps them make confident purchase decisions. Please ensure all details are accurate and genuine.',
        Icons.description_outlined,
        state.businessDescriptionController,
        isEdit: true,
        onChanged: (_) => notifier.onChanged(),
    );
  }

  Widget brandLogoView(){
    final state = ref.watch(accountUpdateScreenStateProvider);
    final notifier = ref.read(accountUpdateScreenStateProvider.notifier);

    return Column(
      children: [
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
      ],
    );
  }

  Widget brandNameView(){
    final state = ref.watch(accountUpdateScreenStateProvider);
    return CodeReusability().customTextField(
      context,
      "Store / Brand Name",
      "enter your store or brand name", Icons.store,
      state.brandNameController,
    );
  }

  Widget brandStartDate(){
    final state = ref.watch(accountUpdateScreenStateProvider);

    return CodeReusability().datePickerTextField(
        context,
        "Date of business started",
        "select date",
        Icons.calendar_today,
        state.businessStartedDateController,
        minimumAge: 0
    );
  }


  void _submit() {
    Navigator.pop(context, _value);
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




}


