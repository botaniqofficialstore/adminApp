import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../Constants/Constants.dart';
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

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0, // scroll offset (0 = top)
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var detailsScreenState = ref.watch(sellerProductDetailsScreenStateProvider);


    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: objConstantColor.white,
        body: /* detailsScreenState.isLoading
            ? buildProductDetailShimmer(context)
            : */CustomScrollView(
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.dp),

                    objCommonWidgets.customText(
                      context, 'Microgreens', 14,
                      objConstantColor.gray, objConstantFonts.montserratSemiBold,
                    ),

                    SizedBox(height: 5.dp),

                    Row(
                      children: [
                        objCommonWidgets.customText(
                          context,
                          'Red Amaranthus',
                          22,
                          objConstantColor.navyBlue,
                          objConstantFonts.montserratBold,
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

                    customSectionTitle(context, "About"),
                    objCommonWidgets.customText(context,
                        'Red Amaranthus Microgreens are the young, vibrant shoots of the red amaranth plant, harvested at their early growth stage when nutrient concentration is highest. With their striking red-purple leaves and mild, earthy flavor, they add a splash of color and a burst of nutrition to salads, wraps, smoothies, and gourmet dishes. Known for their exceptional vitamin, mineral, and antioxidant content, these microgreens are both a culinary delight and a health-boosting superfood.',
                        12, objConstantColor.navyBlue,
                        objConstantFonts.montserratMedium,
                        textAlign: TextAlign.justify),

                    SizedBox(height: 20.dp),

                    customSectionTitle(context, "Delivery Details"),


                    SizedBox(height: 20.dp),

                    customSectionTitle(context, "Price Details"),
                    SizedBox(height: 5.dp),
                    priceDetails(context),



                  ],
                ),
              ),
            ),


            SliverToBoxAdapter(
              child: SizedBox(height: 15.dp),
            )
          ],
        ),
      ),
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

            return Image.network(
              imagePath,
              width: double.infinity,
              height: 250.dp,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  objConstantAssest.placeholderImage,
                  // fallback image from assets
                  width: double.infinity,
                  height: 180.dp,
                  fit: BoxFit.cover,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CupertinoActivityIndicator(
                    color: objConstantColor.gray,
                  ),
                );
              },
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
                      ? objConstantColor.white
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
                    padding: EdgeInsets.all(4.dp),
                    minSize: 35.dp,
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(Icons.edit, color: Colors.white,),
                    onPressed: () {
                      var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                      userScreenNotifier.callNavigation(ScreenName.addProduct);
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
                    padding: EdgeInsets.all(4.dp),
                    minSize: 35.dp,
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
    return Row(
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
            padding: EdgeInsets.symmetric(vertical: 10.dp),
            child: Center(
              child: objCommonWidgets.customText(
                context, '₹189/_',
                17,
                Colors.white,
                objConstantFonts.montserratSemiBold,
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
            padding: EdgeInsets.symmetric(vertical: 10.dp),
            child: Center(
              child: Text(
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
            ),
          ),
        ),
      ],
    );
  }




  Widget customSectionTitle(BuildContext context, String title) {
    return objCommonWidgets.customText(
      context, title, 16,
      objConstantColor.navyBlue, objConstantFonts.montserratSemiBold,
    );
  }







  Widget buildProductDetailShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Top Image Carousel
            Container(
              height: 300.dp,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Stack(
                children: [
                  // Back button
                  Positioned(
                    top: 40.dp,
                    left: 20.dp,
                    child: Container(
                      width: 38.dp,
                      height: 38.dp,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 40.dp,
                    right: 20.dp,
                    child: Container(
                      width: 38.dp,
                      height: 38.dp,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Dot indicator
                  Positioned(
                    bottom: 10.dp,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                            (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.dp),
                          width: 10.dp,
                          height: 4.dp,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10.dp),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 16.dp),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📌 Category shimmer
                  Container(
                    width: 120.dp,
                    height: 16.dp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.dp),
                    ),
                  ),
                  SizedBox(height: 8.dp),

                  // 📌 Title + Verified
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 22.dp,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4.dp),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.dp),
                      Container(
                        width: 18.dp,
                        height: 18.dp,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.dp),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.dp),

                  // 📌 About heading
                  Container(
                    width: 80.dp,
                    height: 18.dp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.dp),
                    ),
                  ),
                  SizedBox(height: 12.dp),

                  // 📌 Paragraph shimmer
                  ...List.generate(
                    6,
                        (index) => Padding(
                      padding: EdgeInsets.only(bottom: 8.dp),
                      child: Container(
                        height: 12.dp,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.dp),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.dp),

                  // 📌 Price Details heading
                  Container(
                    width: 120.dp,
                    height: 18.dp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.dp),
                    ),
                  ),
                  SizedBox(height: 16.dp),

                  // 📌 Price buttons (Green + Yellow)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45.dp,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.dp),
                              bottomLeft: Radius.circular(6.dp),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45.dp,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.dp),
                              bottomRight: Radius.circular(6.dp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.dp),
          ],
        ),
      ),
    );
  }



  /*Widget productDetails(BuildContext context) {
    var detailsScreenState = ref.watch(productDetailScreenGlobalStateProvider);
    var nutrients = detailsScreenState.productData?.nutrients ?? [];

    return nutrients.isEmpty
        ? Padding(
      padding: EdgeInsets.only(top: 25.dp),
      child: objCommonWidgets.customText(
        context,
        'No nutrients information available.',
        14,
        objConstantColor.gray,
        objConstantFonts.montserratMedium,
      ),
    )
        : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.dp), // 👈 Rounded corners
        border: Border.all(color: Colors.black.withAlpha(50), width: 0.6),
      ),
      clipBehavior: Clip.hardEdge, // 👈 Needed to clip internal child corners
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(3),
        },
        children: [
          /// Header Row
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                child: objCommonWidgets.customText(
                    context,
                    'Vitamin',
                    15,
                    objConstantColor.navyBlue,
                    objConstantFonts.montserratSemiBold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                child: objCommonWidgets.customText(
                    context,
                    'Benefit',
                    15,
                    objConstantColor.navyBlue,
                    objConstantFonts.montserratSemiBold),
              ),
            ],
          ),

          /// Dynamic rows
          for (var n in nutrients)
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                  child: objCommonWidgets.customText(context, n.vitamin, 12,
                      objConstantColor.navyBlue, objConstantFonts.montserratSemiBold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
                  child: objCommonWidgets.customText(context, n.benefit, 11,
                      objConstantColor.navyBlue, objConstantFonts.montserratMedium),
                ),
              ],
            ),
        ],
      ),
    );
  }*/






}
