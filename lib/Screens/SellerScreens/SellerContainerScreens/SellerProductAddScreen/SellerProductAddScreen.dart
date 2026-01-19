import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:im_stepper/stepper.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProductAddScreenState.dart';

class SellerProductAddScreen extends ConsumerStatefulWidget {
  const SellerProductAddScreen({super.key});

  @override
  SellerProductAddScreenState createState() => SellerProductAddScreenState();
}

class SellerProductAddScreenState extends ConsumerState<SellerProductAddScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  final List<String> productType = [
    'Fresh',
    'Spices & Herbs',
    'Oils & Staples',
    'Health & Wellness',
    'Personal Care',
    'Healthy Snacks'
  ];

  @override
  void initState() {
    Future.microtask((){
    ref.read(sellerProductAddScreenStateProvider.notifier).addNewBenefitSet(context);
    });
    super.initState();
  }

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

              _buildStepper(state),
              SizedBox(height: 15.dp,),
              objCommonWidgets.customText(context, 'Complete all the requirements.', 12, Colors.black, objConstantFonts.montserratMedium),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  pageSnapping: false,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _stepWrapper(0, "Product Basic Details", "Provide the essential information that identifies your product. Add a clear and accurate product name and select the appropriate product type to help customers easily find and understand your organic offering.",
                        _buildStepOne(notifier)),
                    _stepWrapper(1, "Pricing Strategy", "Set transparent and competitive pricing for your product. Enter the actual price and the selling price to clearly highlight savings and build customer trust.",
                        _buildStepTwo(state, notifier)),
                    _stepWrapper(2, "Visual Showcase", "Showcase your product with high-quality images. Upload a main product image along with additional photos from different angles to give customers a complete and confident view of your organic product.",
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

  Widget _buildStepper(state) {
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);
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
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);

    return RawScrollbar(
      thumbColor: objConstantColor.black.withAlpha(45),
      radius: const Radius.circular(20),
      thickness: 4,
      thumbVisibility: false,
      interactive: true,
      child: SingleChildScrollView(
        // This forces the bounce even if the content is smaller than the screen
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.all(20.dp),
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
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);

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
            _customTextField("Product Name",
                "e.g. Organic Himalayan Honey",
                Icons.shopping_bag_outlined,
                state.productNameController, onChanged: (_) => notifier.onChanged()),

            SizedBox(height: 20.dp),
            _customTextField("Product Type", "e.g. Dairy, Fruits, Oil",
                Icons.category_outlined,
                state.productTypeController,onChanged: (_) => notifier.onChanged()),


            SizedBox(height: 20.dp),
            customDropdownField(
              context: context,
              placeholder: "Select Category",
              items: productType,
              selectedValue: state.productCategory,
              prefixIcon: CupertinoIcons.tag,
              onChanged: (value) {
                setState(() {
                  notifier.updateProductCategory(value!);
                });
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildStepTwo(state, notifier) {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);

    return Column(
      children: [
        _customTextField("Actual Price (₹)", "0.00", Icons.money,
            state.productActualPriceController, keyboardType: TextInputType.number,
            onChanged: (_) => notifier.onChanged()),
        SizedBox(height: 20.dp),
        _customTextField("Selling Price (₹)", "0.00", Icons.local_offer_outlined,
            state.productSellingPriceController, keyboardType: TextInputType.number,
            onChanged: (_) => notifier.onChanged()),

        if (state.discountPercentage > 0) ...{
          SizedBox(height: 20.dp),
          Container(
            padding: EdgeInsets.all(15.dp),
            decoration: BoxDecoration(color: Colors.green.withAlpha(30),
                borderRadius: BorderRadius.circular(20.dp)),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.green),
                SizedBox(width: 10.dp),
                Flexible(
                  child: objCommonWidgets.customText(context,
                      "Great! You are offering ${state.discountPercentage
                          .toStringAsFixed(0)}% OFF", 14, Colors.green,
                      objConstantFonts.montserratSemiBold),
                ),
                SizedBox(width: 5.dp),
              ],
            ),
          ).animate().shimmer(),
        }
      ],
    );
  }

  Widget _buildStepThree() {

    return Column(
      children: [
        _buildAnimatedProgressBar(),

        ListView(
          padding: EdgeInsets.symmetric(vertical: 25.dp),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            // SECTION 1: MAIN IMAGE
            _buildSectionHeader("Main Product Image", "This is the first image customers will see"),
            _buildMainImageCard(),

            SizedBox(height: 25.dp),

            // SECTION 2: SUB IMAGES GRID
            _buildSectionHeader("Product Gallery", "Add different angles or details (Min. 3)"),
            _buildImageGrid(),

          ],
        ),
      ],
    );
  }

  Widget _buildStepFour() {
    final state = ref.watch(sellerProductAddScreenStateProvider);

    return Column(
      children: [
        _buildBenefitAnimatedProgressBar(),
        SizedBox(height: 10.dp),

        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding:
          const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          itemCount: state.benefitSets.length,
          itemBuilder: (context, index) {
            return _buildModernCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildBenefitAnimatedProgressBar() {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    double progress = (state.benefitFilledSetCount / 4).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.dp)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              objCommonWidgets.customText(
                  context,
                  state.benefitFilledSetCount >= 4 ? "Ready to save" : "Add at least 4 benefits about your product",
                  11,
                  Colors.black,
                  objConstantFonts.montserratMedium),

              objCommonWidgets.customText(
                  context,
                  "${state.benefitFilledSetCount}/4",
                  10,
                  state.benefitFilledSetCount >= 4 ? Colors.green : Colors.black,
                  objConstantFonts.montserratSemiBold),
            ],
          ),
          SizedBox(height: 5.dp),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: Duration(milliseconds: 500),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(state.benefitProgressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(int index) {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);
    final benefitController = state.benefitSets[index]['benefit']!;
    final bool showDelete = state.isBenefitSetFilled(index);
    final bool isLast = index == state.benefitSets.length - 1;

    return Column(
      children: [

        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  objCommonWidgets.customText(
                      context,
                      'Benefit ${index + 1}',
                      13,
                      Colors.black,
                      objConstantFonts.montserratMedium),
                  const Spacer(),
                  if (showDelete || (index != 0))
                    CupertinoButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        CodeReusability.hideKeyboard(context);
                        notifier.removeBenefitSet(index);
                      },
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: objCommonWidgets.customText(
                          context,
                          (showDelete) ? 'Clear' : 'Delete',
                          12,
                          Colors.red,
                          objConstantFonts.montserratMedium),
                    ),

                  SizedBox(width: 5.dp,)

                ],
              ),

              SizedBox(height: 15.dp),

              objCommonWidgets.customText(
                  context,
                  'Vitamin / Mineral',
                  10,
                  Colors.black,
                  objConstantFonts.montserratMedium),
              SizedBox(height: 5.dp),
              _buildVitaminField(state.benefitSets[index]['vitamin']!),

              SizedBox(height: 15.dp),

              objCommonWidgets.customText(
                  context,
                  'Benefits',
                  10,
                  Colors.black,
                  objConstantFonts.montserratMedium),
              SizedBox(height: 5.dp),

              Stack(
                children: [
                  TextField(
                    controller: benefitController,
                    maxLength: state.maxBenefitLength,
                    cursorColor: Colors.black,
                    minLines: 2,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                        fontSize: 12.dp,
                        color: Colors.black,
                        fontFamily: objConstantFonts.montserratMedium),
                    decoration: InputDecoration(
                      hintText: "e.g. Supports energy metabolism",
                      hintStyle: TextStyle(
                          color: Colors.black.withAlpha(125),
                          fontSize: 11.dp,
                          fontFamily: objConstantFonts.montserratMedium),
                      counterText: "",
                      contentPadding: EdgeInsets.all(12.dp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide:
                        BorderSide(color: Colors.black, width: 1.5.dp),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide:
                        BorderSide(color: Colors.deepOrange, width: 1.5.dp),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 12,
                    child: objCommonWidgets.customText(
                        context,
                        "${benefitController.text.length}/${state.maxBenefitLength}",
                        10,
                        benefitController.text.length >= state.maxBenefitLength
                            ? Colors.red
                            : Colors.black.withAlpha(180),
                        objConstantFonts.montserratMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ✅ ADD BUTTON ONLY IN LAST CELL
        if (isLast)
          Padding(
            padding: EdgeInsets.only(top: 5.dp),
            child: CupertinoButton(
              onPressed: () {
                CodeReusability.hideKeyboard(context);
                notifier.addNewBenefitSet(context);
              },
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.dp),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20.dp)
                ),
                child: Center(
                  child: objCommonWidgets.customText(context,
                      'Add more benefit',
                      13, Colors.white, objConstantFonts.montserratSemiBold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVitaminField(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      onChanged: (_) => setState(() {}),
      style: TextStyle(
          fontSize: 12.dp,
          color: Colors.black,
          fontFamily: objConstantFonts.montserratMedium),
      decoration: InputDecoration(
        hintText: "e.g. Vitamin B12",
        hintStyle: TextStyle(
            color: Colors.black.withAlpha(125),
            fontSize: 11.dp,
            fontFamily: objConstantFonts.montserratMedium),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.dp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.dp),
          borderSide: BorderSide(color: Colors.black, width: 1.5.dp),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.dp),
          borderSide: BorderSide(color: Colors.deepOrange, width: 1.5.dp),
        ),
      ),
    );
  }

  Widget _buildStepFive(notifier) {
    final state = ref.watch(sellerProductAddScreenStateProvider);

    return _customTextField(
      "Stock Quantity",
      "e.g. 50",
      Icons.inventory,
      state.productStockCountController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // 👈 ONLY DIGITS
      ],
        onChanged: (_) => notifier.onChanged());
  }

  Widget _buildStepSix(notifier) {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);
    final isSelected = state.deliveryDays > 0 ;

    return CupertinoButton(padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 20.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.dp),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.dp),
                child: Icon(Icons.backpack_sharp, color: Colors.deepOrange),
              ),

              objCommonWidgets.customText(context,
                  isSelected ? '${state.deliveryDays} Days' : 'eg.10 Days',
                  isSelected ? 15 : 13,
                  isSelected ? Colors.black : Colors.grey.shade500, objConstantFonts.montserratRegular),
              const Spacer(),

              Icon(
                CupertinoIcons.chevron_down,
                color: Colors.grey,
                size: 18.dp,
              ),
            ],
          ),
        ), onPressed: () async {
          final days = await CodeReusability().showSpinnerUpdateBottomView(
            context,
            'Update Delivery Days',
            10,
            500,
          );

          if (days != null) {
            notifier.upDateDelivery(days);
          }
        });
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
                    ref.read(SellerMainScreenGlobalStateProvider.notifier).callNavigation(ScreenName.products);
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
                        ? (isLastStep ? Colors.green : Colors.deepOrange )
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

  // --- REUSABLE WIDGETS ---
  Widget _customTextField(String hint,
      String label,
      IconData icon,
      TextEditingController? controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text, void Function(String)? onChanged, List<TextInputFormatter>? inputFormatters, }
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(context, hint, 14, Colors.black, objConstantFonts.montserratSemiBold),

        SizedBox(height: 10.dp),

        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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
                            color: (selectedValue == value) ? Colors.black : Colors.grey.shade500,
                            fontFamily: (selectedValue == value) ? objConstantFonts.montserratMedium : objConstantFonts.montserratRegular,
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
                color: Colors.grey,
                size: 18.dp,
              ),

            ],
          ),
        ),
      ],
    );
  }







  Widget _buildAnimatedProgressBar() {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    const int maxImagesRequired = 4;

    final int totalImages = state.filledSetCount;
    final double progress = (totalImages / maxImagesRequired).clamp(0.0, 1.0);

    final String progressText = totalImages <= maxImagesRequired
        ? '$totalImages/$maxImagesRequired'
        : '$totalImages';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              objCommonWidgets.customText(
                context,
                state.filledSetCount > 3
                    ? "All required images added"
                    : "Add at least $maxImagesRequired images of your product",
                11,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
              objCommonWidgets.customText(
                context,
                progressText,
                10,
                state.filledSetCount > 3 ? Colors.green : Colors.black,
                objConstantFonts.montserratSemiBold,
              ),
            ],
          ),
          SizedBox(height: 5.dp),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor:
                AlwaysStoppedAnimation<Color>(state.progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(context, title, 13, Colors.black, objConstantFonts.montserratSemiBold),
          SizedBox(height: 2.dp),
          objCommonWidgets.customText(context, subTitle, 10, Colors.grey, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }


  Widget _buildMainImageCard() {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);

    return Container(
      height: 220.dp,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: state.mainPhoto.isEmpty
          ? CupertinoButton(
          onPressed: () => notifier.uploadImage(context, 0, isMainImage: true), // Call uploadImage for index 0
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          child: _buildAddPlaceholder())
          : Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: NetworkImageLoader(
              imageUrl: state.mainPhoto,
              placeHolder: objConstantAssest.placeholderImage,
              size: 80.dp,
              imageSize: double.infinity,
              isLocal: CodeReusability().isNotValidUrl(state.mainPhoto),
            ),
          ),
          _buildDeleteButton(() {
            notifier.updateMainPhoto('');
          }),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    final state = ref.watch(sellerProductAddScreenStateProvider);
    final notifier = ref.read(sellerProductAddScreenStateProvider.notifier);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.productImages.length + 1, // Always +1 for the Add button
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.dp,
        crossAxisSpacing: 12.dp,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index == state.productImages.length) {
          // The "Add New" card at the end
          return CupertinoButton(
            onPressed: () => notifier.uploadImage(context, index), // Call uploadImage for current cell index
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            child: _buildAddPlaceholder(),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.dp),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.dp),
                child: NetworkImageLoader(
                  imageUrl: state.productImages[index],
                  placeHolder: objConstantAssest.placeholderImage,
                  size: 80.dp,
                  imageSize: double.infinity,
                  isLocal: CodeReusability().isNotValidUrl(state.productImages[index]),
                ),
              ),
            ),
            _buildDeleteButton(() {
              notifier.removeProductPhoto(index);
            }),
          ],
        );
      },
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





}