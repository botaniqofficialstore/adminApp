import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerRatingScreenState.dart';

class SellerRatingScreen extends ConsumerStatefulWidget {
  const SellerRatingScreen({super.key});

  @override
  SellerRatingScreenStateUI createState() => SellerRatingScreenStateUI();
}

class SellerRatingScreenStateUI extends ConsumerState<SellerRatingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerRatingScreenStateProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Clean organic off-white
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RawScrollbar(
                thumbColor: objConstantColor.black.withAlpha(45),
                radius: const Radius.circular(20),
                thickness: 4,
                thumbVisibility: false,
                interactive: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverallRatingCard(state.overallRating),
                        SizedBox(height: 25.dp),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.dp),
                          child: objCommonWidgets.customText(context, 'Top Rated Products', 13.5, objConstantColor.black, objConstantFonts.montserratSemiBold),
                        ),
                        SizedBox(height: 5.dp),
                        _buildProductList(state.topProducts),
                        SizedBox(height: 15.dp),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.dp, top: 10.dp, bottom: 15.dp),
      child: Row(
        children: [
          CupertinoButton(padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Icon(Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 20.dp),
              onPressed: (){
                var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callNavigation(ScreenName.profile);
              }),
          SizedBox(width: 5.dp),
          objCommonWidgets.customText(context, 'Overall Ratings', 14, objConstantColor.black, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }

  // Requirement 1: Overall Rating Widget
  Widget _buildOverallRatingCard(double rating) {
    return Container(
      padding: EdgeInsets.all(20.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          // Left Side: Big Number Rating
          Expanded(
            flex: 2,
            child: Column(
              children: [
                objCommonWidgets.customText(context, rating.toString(), 40, objConstantColor.black, objConstantFonts.montserratBold),
                _buildStars(rating, Colors.amber),
                SizedBox(height: 8.dp),
                objCommonWidgets.customText(context, "1.2k Reviews", 11, Colors.grey, objConstantFonts.montserratMedium),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            height: 85.dp,
            width: 1,
            color: Colors.black.withAlpha(35),
            margin: EdgeInsets.symmetric(horizontal: 15.dp),
          ),

          // Right Side: Animated Progress Bars Breakdown
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildAnimatedRatingRow("5", 0.85, 1000), // delay in milliseconds
                _buildAnimatedRatingRow("4", 0.65, 1100),
                _buildAnimatedRatingRow("3", 0.35, 1200),
                _buildAnimatedRatingRow("2", 0.15, 1300),
                _buildAnimatedRatingRow("1", 0.05, 1400),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper to get color based on the rating star label
  Color _getRatingColor(String label) {
    switch (label) {
      case "5":
      case "4":
        return const Color(0xFF4CAF50); // Professional Green
      case "3":
        return const Color(0xFFFFC107); // Amber/Yellow
      case "2":
        return const Color(0xFFFF9800); // Orange
      case "1":
        return const Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }

  Widget _buildAnimatedRatingRow(String label, double targetPercent, int delay) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.dp),
      child: Row(
        children: [
          SizedBox(
            width: 12.dp,
            child: objCommonWidgets.customText(context, label, 11, Colors.black, objConstantFonts.montserratMedium),
          ),
          SizedBox(width: 8.dp),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: targetPercent),
                duration: Duration(milliseconds: delay),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 6.dp,
                    backgroundColor: Colors.grey.shade100,
                    // DYNAMIC COLOR BASED ON LABEL
                    valueColor: AlwaysStoppedAnimation<Color>(_getRatingColor(label)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating, Color color) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
          color: color,
          size: 18.dp,
        );
      }),
    );
  }

  String getSentimentLabel(double rating) {
    if (rating >= 4.8) return "Top Rated";
    if (rating >= 4.5) return "Highly Recommended";
    if (rating >= 4.0) return "Customer Favorite";
    if (rating >= 3.0) return "Average Satisfaction";
    return "Needs Improvement";
  }

  // Requirement 2 & 3: Product List with "View Reviews" button
  Widget _buildProductList(List<RatedProduct> products) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.dp), // Increased spacing for cleaner look
      itemBuilder: (context, index) {
        final product = products[index];

        // STAGGERED ANIMATION LOGIC
        return TweenAnimationBuilder<double>(
          // Each item starts slightly later based on its index
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 150)),
          curve: Curves.easeOutQuint,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                // Slides from 50 pixels right to its original position (0)
                offset: Offset(50 * (1 - value), 0),
                child: child,
              ),
            );
          },
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () {
              // Action for viewing reviews
              var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
              userScreenNotifier.callNavigation(ScreenName.productReview);
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(12.dp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.dp),
                      border: Border.all(color: Colors.black.withAlpha(15)), // Subtler border
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ]
                  ),
                  child: Row(
                    children: [
                      // Product Image with subtle shadow
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.dp),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 5)
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.dp),
                          child: Image.network(
                            product.image,
                            width: 75.dp,
                            height: 75.dp,
                            fit: BoxFit.cover,
                            // Handle the loading state
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child; // Image is fully loaded

                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // 1. The Local Placeholder Image
                                  Image.asset(
                                    objConstantAssest.placeholderImage,
                                    width: 75.dp,
                                    height: 75.dp,
                                    fit: BoxFit.cover,
                                  ),
                                  // 2. The White Progress Bar
                                  SizedBox(
                                    width: 20.dp, // Small and clean
                                    height: 20.dp,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0, // Thinner lines look more modern
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      backgroundColor: Colors.white24, // Subtle track color
                                    ),
                                  ),
                                ],
                              );
                            },
                            // Optional: Handle errors (e.g., 404 or no internet)
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                objConstantAssest.placeholderImage,
                                width: 75.dp,
                                height: 75.dp,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 15.dp),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(
                                context, product.name, 15, objConstantColor.black,
                                objConstantFonts.montserratSemiBold),
                            SizedBox(height: 4.dp),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                SizedBox(width: 4.dp),
                                objCommonWidgets.customText(context,
                                    '${product.rating}', 13,
                                    Colors.black,
                                    objConstantFonts.montserratSemiBold),
                                SizedBox(width: 8.dp),
                                objCommonWidgets.customText(context,
                                    '(${product.reviewCount} reviews)', 12,
                                    Colors.black.withAlpha(100),
                                    objConstantFonts.montserratMedium),
                              ],
                            ),
                            SizedBox(height: 2.dp),
                            // "View Details" hint
                            objCommonWidgets.customText(context,
                                getSentimentLabel(product.rating), 11,
                                objConstantColor.black.withAlpha(100),
                                objConstantFonts.montserratMedium),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.black.withAlpha(60), size: 14.dp),
                    ],
                  ),
                ),

                if(product.newCount > 0)
                Positioned(
                  right: 20.dp,
                  top: 10.dp,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 2.dp, horizontal: 6.dp),
                    decoration: BoxDecoration(
                      color: objConstantColor.redd,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: objCommonWidgets.customText(
                      context,
                      '${product.newCount}',
                      10, Colors.white,
                      objConstantFonts.montserratBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}