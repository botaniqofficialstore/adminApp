import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:im_stepper/stepper.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProductAddScreenState.dart';

class SellerProductAddScreen extends ConsumerStatefulWidget {
  const SellerProductAddScreen({super.key});

  @override
  SellerProductAddScreenState createState() => SellerProductAddScreenState();
}

class SellerProductAddScreenState extends ConsumerState<SellerProductAddScreen> {
  final PageController _pageController = PageController();
  String? selectedCategory;

  final List<String> productType = [
    'Fresh',
    'Spices & Herbs',
    'Oils & Staples',
    'Health & Wellness',
    'Personal Care',
    'Healthy Snacks'
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),

              _buildStepper(state, notifier),
              SizedBox(height: 15.dp,),
              objCommonWidgets.customText(context, 'Complete all the requirements.', 12, Colors.black, objConstantFonts.montserratMedium),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _stepWrapper(0, "Product Basic Details", "Provide the essential information that identifies your product. Add a clear and accurate product name and select the appropriate product type to help customers easily find and understand your organic offering.", _buildStepOne(notifier)),
                    _stepWrapper(1, "Pricing Strategy", "Set transparent and competitive pricing for your product. Enter the actual price and the selling price to clearly highlight savings and build customer trust.", _buildStepTwo(state, notifier)),
                    _stepWrapper(2, "Visual Showcase", "Showcase your product with high-quality images. Upload a main product image along with additional photos from different angles to give customers a complete and confident view of your organic product.", _buildStepThree()),
                    _stepWrapper(3, "Health Benefits", "Highlight the nutritional value of your product. Add details about vitamins and their benefits to help customers understand how your product supports a healthy lifestyle.", _buildStepFour()),
                    _stepWrapper(4, "Inventory", "Manage availability efficiently. Enter the current stock quantity to ensure accurate inventory tracking and avoid overselling.", _buildStepFive(notifier)),
                  ],
                ),
              ),
              _buildBottomBar(state, notifier),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: () => ref.read(SellerMainScreenGlobalStateProvider.notifier).callNavigation(ScreenName.products),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            child: Icon(Icons.arrow_back_rounded, size: 25.dp, color: Colors.black,),
          ),
          objCommonWidgets.customText(context, 'New Product', 18, Colors.black, objConstantFonts.montserratSemiBold),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildStepper(state, notifier) {
    const int totalSteps = 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final bool isCompleted = index < state.currentStep;
        final bool isActive = index == state.currentStep;

        return Row(
          children: [
            GestureDetector(
              onTap: () => notifier.setStep(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🔹 Tick icon (only for completed)
                  AnimatedOpacity(
                    opacity: isCompleted ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(

                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),

                  /// 🔹 Progress bar (always visible)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: isActive ? 65.dp : 35.dp,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? Colors.orange.shade600
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),

            if (index != totalSteps - 1) const SizedBox(width: 12),
          ],
        );
      }),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2);
  }




  Widget _stepWrapper(int index, String title, String desc, Widget child) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(context, title, 20, Colors.black, objConstantFonts.montserratBold),
          SizedBox(height: 5.dp),
          objCommonWidgets.customText(context, desc, 11, Colors.black, objConstantFonts.montserratRegular),
          SizedBox(height: 25.dp),
          child,
        ],
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
    );
  }

  // --- STEP CONTENT ---

  Widget _buildStepOne(notifier) {

    return Column(
      children: [
        _customTextField("Product Name", "e.g. Organic Himalayan Honey", Icons.shopping_bag_outlined, (v) => notifier.updateProductDetails(name: v)),
        SizedBox(height: 20.dp),
        _customTextField("Product Type", "e.g. Dairy, Fruits, Oil", Icons.category_outlined, (v) => notifier.updateProductDetails(type: v)),

        SizedBox(height: 20.dp),
        customDropdownField(
          context: context,
          placeholder: "Select Category",
          items: productType,
          selectedValue: selectedCategory,
          prefixIcon: CupertinoIcons.tag,
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
          },
        ),

      ],
    );
  }

  Widget _buildStepTwo(state, notifier) {
    return Column(
      children: [
        _customTextField("Actual Price (₹)", "0.00", Icons.money, (v) => notifier.updatePrices(actual: double.tryParse(v)), keyboardType: TextInputType.number),
        SizedBox(height: 20.dp),
        _customTextField("Selling Price (₹)", "0.00", Icons.local_offer_outlined, (v) => notifier.updatePrices(selling: double.tryParse(v)), keyboardType: TextInputType.number),
        SizedBox(height: 20.dp),
        if (state.discountPercentage > 0)
          Container(
            padding: EdgeInsets.all(15.dp),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.green),
                SizedBox(width: 10.dp),
                objCommonWidgets.customText(context, "Great! You are offering ${state.discountPercentage.toStringAsFixed(0)}% OFF", 14, Colors.green.shade700, objConstantFonts.montserratSemiBold),
              ],
            ),
          ).animate().shimmer(),
      ],
    );
  }

  Widget _buildStepThree() {
    return Container(
      height: 200.dp,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 50.dp, color: Colors.blue),
          SizedBox(height: 10.dp),
          objCommonWidgets.customText(context, "Upload Product Gallery", 14, Colors.blue, objConstantFonts.montserratSemiBold),
        ],
      ),
    );
  }

  Widget _buildStepFour() {
    return Column(
      children: [
        _customTextField("Vitamins", "e.g. Vitamin C, B12", Icons.health_and_safety, (v) {}),
        SizedBox(height: 20.dp),
        _customTextField("Key Benefits", "Describe health advantages...", Icons.description_outlined, (v) {}, maxLines: 4),
      ],
    );
  }

  Widget _buildStepFive(notifier) {
    return _customTextField("Stock Quantity", "e.g. 50", Icons.inventory, (v) => notifier.updateStock(int.tryParse(v) ?? 0));
  }

  // --- REUSABLE WIDGETS ---

  Widget _customTextField(String hint, String label, IconData icon,
      Function(String) onChanged, {int maxLines = 1, TextInputType keyboardType = TextInputType.text,}
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(context, hint, 14, Colors.black, objConstantFonts.montserratSemiBold),

        SizedBox(height: 10.dp),

        TextField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          cursorColor: Colors.black,
          style: TextStyle(
            fontSize: 15.dp,
            fontFamily: objConstantFonts.montserratMedium,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              fontSize: 13.dp,
              fontFamily: objConstantFonts.montserratRegular,
              color: Colors.grey.shade500,
            ),
            prefixIcon: Icon(icon, color: Colors.deepOrange),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.dp),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.dp),
              borderSide: const BorderSide(color: Colors.deepOrange, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16.dp),
          ),
        ),
      ],
    );
  }


  Widget customDropdownField({
    required BuildContext context,
    required String placeholder,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ⭐ Label
        objCommonWidgets.customText(
          context,
          placeholder,
          14,
          Colors.black,
          objConstantFonts.montserratSemiBold,
        ),

        SizedBox(height: 10.dp),

        // ⭐ Dropdown container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 5.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.dp),
          ),
          child: Row(
            children: [
              // Optional prefix icon
              if (prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.dp),
                  child: Icon(prefixIcon, color: Colors.deepOrange),
                ),

              SizedBox(width: 5.dp,),

              // Dropdown
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    icon: const SizedBox.shrink(),
                    dropdownColor: Colors.white,

                    hint: objCommonWidgets.customText(
                      context,
                      placeholder,
                      13,
                      Colors.grey.shade500,
                      objConstantFonts.montserratMedium,
                    ),

                    items: items.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 15.dp,
                            color: (selectedValue == value) ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: onChanged,
                  ),
                ),
              ),

              Icon(
                CupertinoIcons.chevron_down,
                color: Colors.black87,
                size: 18.dp,
              ),

            ],
          ),
        ),
      ],
    );
  }




  Widget _buildBottomBar(state, notifier) {
    final bool isLastStep = state.currentStep == 4;
    final bool canProceed = notifier.canMoveToNext(state.currentStep);
    final bool showBack = state.currentStep > 0;

    return Padding(
      padding: EdgeInsets.all(20.dp),
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
                    padding: EdgeInsets.symmetric(vertical: 18.dp),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.dp),
                    ),
                    child: Center(
                      child: objCommonWidgets.customText(
                        context,
                        "Back",
                        16,
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
                  if (isLastStep) {
                    // Final Save Logic
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
                  padding: EdgeInsets.symmetric(vertical: 18.dp),
                  decoration: BoxDecoration(
                    color: canProceed
                        ? Colors.deepOrange
                        : Colors.grey.withAlpha(85),
                    borderRadius: BorderRadius.circular(15.dp),
                  ),
                  child: Center(
                    child: objCommonWidgets.customText(
                      context,
                      isLastStep ? "Finish & Save" : "Next Step",
                      16,
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