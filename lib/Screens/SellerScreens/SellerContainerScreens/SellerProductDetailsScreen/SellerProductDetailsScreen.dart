import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/CommonPopupViews/ProductImageUploadPopup/ProductImageUploadPopup.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import '../../../../CommonPopupViews/ModernBenefitPopup/ModernBenefitPopup.dart';
import '../../../../constants/ConstantVariables.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProductDetailsScreenState.dart';

class SellerProductDetailsScreen extends ConsumerStatefulWidget {
  const SellerProductDetailsScreen({super.key});

  @override
  SellerProductDetailsScreenState createState() => SellerProductDetailsScreenState();
}

class SellerProductDetailsScreenState extends ConsumerState<SellerProductDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 0;
  late CarouselController innerCarouselController;

  final List<String> sample = [
    'https://app-1q5g.onrender.com/uploads/1761632706172.png',
    'https://app-1q5g.onrender.com/uploads/1761994235917.png',
    'https://app-1q5g.onrender.com/uploads/1761994615276.png',
    'https://app-1q5g.onrender.com/uploads/1761994304973.png',
    'https://app-1q5g.onrender.com/uploads/1761994675928.png'
  ];

  final List<Map<String, String>> vitamins = const [
    {"name": "Vitamin A", "benefit": "Vision, Immune System, Skin Health"},
    {"name": "Vitamin B12", "benefit": "Nerve Function, Red Blood Cells"},
    {"name": "Vitamin C", "benefit": "Antioxidant, Tissue Repair, Scurvy Prevention"},
    {"name": "Vitamin D", "benefit": "Bone Health, Calcium Absorption"},
    {"name": "Vitamin E", "benefit": "Skin Health, Protects cells from damage"},
    {"name": "Vitamin K", "benefit": "Blood Clotting, Bone Metabolism"},
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var detailsScreenState = ref.watch(sellerProductDetailsScreenStateProvider);


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [

              /// 🔰 1. CAROUSEL + TOP PART
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    carousalSlider(context),

                    Positioned(
                      bottom: -18.dp,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40.dp,
                        decoration: BoxDecoration(
                          color: objConstantColor.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.dp),
                            topRight: Radius.circular(25.dp),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 50.dp,
                            height: 5.dp,
                            decoration: BoxDecoration(
                                color: Colors.black.withAlpha(50),
                                borderRadius: BorderRadius.circular(20.dp)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔰 2. BODY CONTENT SECTION
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25.dp),

                        Row(
                          children: [
                            objCommonWidgets.customText(
                              context, 'Microgreens', 12,
                              objConstantColor.black.withAlpha(125), objConstantFonts.montserratMedium,
                            ),
                            SizedBox(width: 5.dp),
                            CupertinoButton(
                              onPressed: () async {
                                final result = await CodeReusability().showTextFieldBottomView(
                                  context,
                                  'Update Product Type',
                                  'Enter here...',
                                );

                                if (result != null && result.isNotEmpty) {
                                  print('Entered text: $result');
                                }

                              },
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                  child: Icon(Icons.edit, size: 16.dp, color: Colors.black,)),
                            )
                          ],
                        ),

                        SizedBox(height: 5.dp),

                        Row(
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Red Amaranthus',
                              18,
                              objConstantColor.navyBlue,
                              objConstantFonts.montserratSemiBold,
                            ),
                            SizedBox(width: 5.dp),
                            CupertinoButton(
                              onPressed: () async {
                                final result = await CodeReusability().showTextFieldBottomView(
                                  context,
                                  'Update Product Name',
                                  'Enter here...',
                                );

                                if (result != null && result.isNotEmpty) {
                                  print('Entered text: $result');
                                }
                              },
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: Icon(Icons.edit, size: 16.dp, color: Colors.black,)),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(width: 1.5.dp, color: Colors
                                    .green),
                              ),
                              padding: EdgeInsets.all(2.8.dp),
                              child: Container(
                                width: 8.dp,
                                height: 8.dp,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 20.dp),

                        customSectionTitle(context, "About", () async {
                          final result = await CodeReusability().showTextViewBottomView(
                            context,
                            'Update About Product',
                            'Enter here...',
                          );

                          if (result != null && result.isNotEmpty) {
                            print('Entered text: $result');
                          }
                        }),
                        objCommonWidgets.customText(context,
                            'Red Amaranthus Microgreens are the young, vibrant shoots of the red amaranth plant, harvested at their early growth stage when nutrient concentration is highest. With their striking red-purple leaves and mild, earthy flavor, they add a splash of color and a burst of nutrition to salads, wraps, smoothies, and gourmet dishes. Known for their exceptional vitamin, mineral, and antioxidant content, these microgreens are both a culinary delight and a health-boosting superfood.',
                            11.5, Colors.black,
                            objConstantFonts.montserratRegular,
                            textAlign: TextAlign.justify),

                        SizedBox(height: 20.dp),

                        customSectionTitle(context, "Price Details", () async {
                          final result = await CodeReusability().showPriceTextFieldBottomView(
                            context,
                            'Update Price Details',
                            'Enter amount',
                            'Enter amount',
                          );

                          if (result != null) {
                            print('Entered text: ${result.$1}');
                            print('Entered text: ${result.$2}');
                          }

                        }),
                        priceDetails(context),
                        SizedBox(height: 30.dp),



                        deliveryDay(context),
                        SizedBox(height: 30.dp),

                        stockDetails(context),


                        SizedBox(height: 30.dp),
                        nutritionWidget(context),

                        SizedBox(height: 15.dp),


                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }


  Widget deliveryDay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Logistics Timeline',
          14,
          objConstantColor.navyBlue,
          objConstantFonts.montserratSemiBold,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.dp), // Softer, more modern corners

            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(15.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Information Row: Processing Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(
                            context, "Handover Duration", 10.dp, Colors.black.withAlpha(150), objConstantFonts.montserratMedium
                        ),
                        SizedBox(height: 4.dp),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 16.dp, color: Color(
                                0xFF032968)),
                            SizedBox(width: 4.dp),
                            objCommonWidgets.customText(
                                context, "2-3 Business Days", 12.dp, Colors.black, objConstantFonts.montserratSemiBold
                            ),
                          ],
                        ),
                      ],
                    ),

                    // The Modern Update Button
                    CupertinoButton(
                      onPressed: () async {
                        final result = await CodeReusability().showSpinnerUpdateBottomView(
                          context,
                          'Update Handover Duration',
                          1,
                          15,
                          placeHolder: 'Days'
                        );

                        if (result != null) {
                          print('Selected value: $result');
                        }
                      },
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.dp, horizontal: 10.dp),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(20.dp),
                        ),
                        child: objCommonWidgets.customText(
                            context, "Update", 10.dp, Colors.white, objConstantFonts.montserratSemiBold
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15.dp),

                // Tooltip/Definition Note
                Container(
                  padding: EdgeInsets.all(12.dp),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withAlpha(15),
                    borderRadius: BorderRadius.circular(12.dp),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 16.dp, color: Colors.deepOrange),
                      SizedBox(width: 8.dp),
                      Expanded(
                        child: objCommonWidgets.customText(
                            context,
                            "This is the estimated time required to hand over the product "
                                "to the delivery partner after order confirmation. It helps "
                                "ensure smooth logistics and avoids delivery delays.",
                            9.dp,
                            Colors.deepOrange,
                            objConstantFonts.montserratRegular
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }




  Widget carousalSlider(BuildContext context){
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: sample.length,
          itemBuilder: (context, index, realIndex) {
            String imagePath = sample[index];

            return NetworkImageLoader(
              imageUrl: imagePath,
              placeHolder: objConstantAssest.placeholderImage,
              size: 80.dp,
              imageSize: double.infinity,
            );
          },
          options: CarouselOptions(
            height: 320.dp,
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => currentIndex = index);
            },
          ),
        ),

        // 🔥 Indicator placed inside the image
        Positioned(
          bottom: 45.dp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(sample.length, (index) {
              bool isActive = currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 45.dp : 8.dp,
                height: 8.dp,
                decoration: BoxDecoration(
                  color: isActive
                      ? objConstantColor.green
                      : objConstantColor.gray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.dp),
                ),
              );
            }),
          ),
        ),

        Positioned(
          top: 0.dp,
          right: 15.dp,
          child: SafeArea(
            child: Row(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(8.dp),
                    minimumSize: Size.zero,
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(Icons.edit, color: Colors.white,),
                    onPressed: () {
                      openImageUpload(context);
                    },
                  ),
                ),

                SizedBox(width: 10.dp),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(8.dp),
                    minimumSize: Size.zero,
                    borderRadius: BorderRadius.circular(30),
                    child: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {

                    },
                  ),
                ),


              ],
            ),
          ),
        ),

        Positioned(
          top: 0.dp,
          left: 15.dp,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: CupertinoButton(
                padding: EdgeInsets.all(4.dp),
                minSize: 35.dp,
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  objConstantAssest.backIcon,
                  color: Colors.white,
                  width: 25.dp,
                ),
                onPressed: () {
                  var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                  userScreenNotifier.callNavigation(ScreenName.products);
                },
              ),
            ),
          ),
        )

      ],
    );
  }


  Widget priceDetails(BuildContext context){
    return Column(
      children: [

        Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(35),
            borderRadius: BorderRadius.circular(5.dp),
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.dp),
          child: Center(
            child: Column(
              children: [
                objCommonWidgets.customText(
                  context, '30% OFF',
                  15,
                  Colors.black,
                  objConstantFonts.montserratSemiBold,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.5.dp),

        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.dp),
                    topLeft: Radius.circular(5.dp),
                  ),
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5.dp),
                child: Center(
                  child: Column(
                    children: [
                      objCommonWidgets.customText(
                        context, '₹189/_',
                        17,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                      objCommonWidgets.customText(
                        context, 'Selling Price',
                        10,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.5.dp),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5.dp),
                    topRight: Radius.circular(5.dp),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 5.dp),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "₹229/_",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.dp,
                          fontFamily: objConstantFonts.montserratSemiBold,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black,
                          decorationThickness: 1,
                        ),
                      ),
                      objCommonWidgets.customText(
                        context, 'Actual Price',
                        10,
                        Colors.black,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),


      ],
    );
  }


  Widget stockDetails(BuildContext context) {
    // Mock data
    double stockLevel = 0.75;
    int totalStock = 150;
    int soldUnits = 97;

    Color statusColor = getStockColor(stockLevel);
    String statusText = getStockStatusText(stockLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Stock Details',
          14,
          objConstantColor.navyBlue,
          objConstantFonts.montserratSemiBold,
        ),

        SizedBox(height: 5.dp),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF000000),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Current Inventory',
                              12,
                              Colors.white,
                              objConstantFonts.montserratMedium,
                            ),

                            const Spacer(),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.dp,
                                vertical: 4.5.dp,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: objCommonWidgets.customText(
                                context,
                                statusText,
                                10,
                                statusColor,
                                objConstantFonts.montserratSemiBold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.dp),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            objCommonWidgets.customText(
                              context,
                              '$totalStock',
                              22,
                              Colors.white,
                              objConstantFonts.montserratSemiBold,
                            ),
                            objCommonWidgets.customText(
                              context,
                              ' units',
                              12,
                              Colors.white.withAlpha(240),
                              objConstantFonts.montserratMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ================= PROGRESS =================
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: stockLevel),
                builder: (context, value, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      objCommonWidgets.customText(
                        context,
                        "${(value * 100).toInt()}%",
                        13,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                      SizedBox(height: 5.dp),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 6.dp,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                          AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 25.dp),

              // ================= FOOTER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStat("Sold", "$soldUnits", Icons.trending_up),

                  Column(
                    children: [
                      objCommonWidgets.customText(context, 'Last Update :', 10, Colors.white.withAlpha(200), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, '10 DEC 2025', 10, Colors.white, objConstantFonts.montserratSemiBold),
                    ],
                  ),

                  CupertinoButton(
                    onPressed: () async {
                      final result = await CodeReusability().showSpinnerUpdateBottomView(
                        context,
                        'Update Stock Count',
                        10,
                        500,
                      );

                      if (result != null) {
                        print('Selected value: $result');
                      }
                    },
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.dp, horizontal: 15.dp),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(85),
                        borderRadius: BorderRadius.circular(15.dp),
                      ),
                      child: objCommonWidgets.customText(
                        context,
                        'Update Stock',
                        11,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

// ================= MINI STAT =================
  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.dp, color: Colors.white),
        SizedBox(width: 4.dp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            objCommonWidgets.customText(
                context, value, 13, Colors.white.withAlpha(200), objConstantFonts.montserratSemiBold),
            objCommonWidgets.customText(
                context, label, 10, Colors.white, objConstantFonts.montserratMedium),
          ],
        ),
      ],
    );
  }

// ================= HELPERS =================
  Color getStockColor(double stockLevel) {
    if (stockLevel <= 0.15) {
      return const Color(0xFFE53935);
    } else if (stockLevel <= 0.40) {
      return Colors.deepOrange;
    } else {
      return const Color(0xFF43A047);
    }
  }

  String getStockStatusText(double stockLevel) {
    if (stockLevel <= 0.15) return "CRITICAL";
    if (stockLevel <= 0.40) return "LOW STOCK";
    return "IN STOCK";
  }

  Widget nutritionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Nutritional Benefits',
          14,
          objConstantColor.navyBlue,
          objConstantFonts.montserratSemiBold,
        ),
        SizedBox(height: 5.dp),

        Stack(
          children: [

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 15,
                      offset: const Offset(0, 8)
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    // --- ADJUST THESE PROPERTIES ---
                    headingRowHeight: 60.0,      // Decreases header height
                    dataRowMinHeight: 30.0,      // Optional: Decreases row height
                    dataRowMaxHeight: 45.0,      // Optional: Limits row height
                    columnSpacing: 25.0,         // Adjusts horizontal space between columns
                    horizontalMargin: 20.0,      // Adjusts space at the start/end of the table
                    dividerThickness: 0.5,
                    // ------------------------------
                    headingRowColor: WidgetStateProperty.all(Colors.black),
                    columns: [
                      DataColumn(
                          label: objCommonWidgets.customText(
                              context, 'Vitamin', 13, Colors.white, objConstantFonts.montserratSemiBold
                          )
                      ),
                      DataColumn(
                          label: objCommonWidgets.customText(
                              context, 'Benefits', 13, Colors.white, objConstantFonts.montserratSemiBold
                          )
                      ),
                    ],
                    rows: vitamins.map((v) => DataRow(cells: [
                      DataCell(objCommonWidgets.customText(
                          context, v['name']!, 10, Colors.black.withAlpha(200), objConstantFonts.montserratMedium
                      )),
                      DataCell(objCommonWidgets.customText(
                          context, v['benefit']!, 10, Colors.black.withAlpha(200), objConstantFonts.montserratMedium
                      )),
                    ])).toList(),
                  ),
                ),
              ),
            ),

            Positioned(right: 20.dp,
                top: 20.dp,
                child: CupertinoButton(
                  onPressed: (){
                    _openBenefitPicker(context);
                  },
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  child: Icon(Icons.edit, size: 16.dp, color: Colors.white,),
                ),
            )
          ],
        ),
      ],
    );
  }



  Widget customSectionTitle(BuildContext context, String title, VoidCallback onEditPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.dp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The Title with a subtle vertical accent line
          Row(
            children: [
              objCommonWidgets.customText(
                context,
                title,
                14,
                objConstantColor.navyBlue,
                objConstantFonts.montserratSemiBold,
              ),
            ],
          ),

          // The Modern Edit Button
          CupertinoButton(
            onPressed: onEditPressed,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.dp, horizontal: 8.dp),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5.dp)
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, size: 13.dp, color: Colors.white,),
                  objCommonWidgets.customText(context, 'Edit', 13, Colors.white, objConstantFonts.montserratMedium)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _openBenefitPicker(BuildContext context) async {
    // This receives the array of benefits from the popup
    final List<Map<String, String>>? results = await showGeneralDialog<List<Map<String, String>>>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Benefits',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => ModernBenefitPopup(),
      transitionBuilder: (context, anim1, anim2, child) {
        // Slides from bottom to top
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );

    if (results != null) {
      print("Collected Benefits: $results");
      // Handle your data here
    }
  }

  void openImageUpload(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Upload',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => ProductImageUploadPopup(initialImages: sample.skip(1).toList(), mainPhoto: sample[0]),
      transitionBuilder: (context, anim1, anim2, child) {
        // Slides from bottom to top
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }
  
  



}


