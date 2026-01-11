import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProductFeedbackScreenState.dart';

class SellerProductFeedbackScreen extends ConsumerStatefulWidget {
  const SellerProductFeedbackScreen({super.key});

  @override
  SellerProductFeedbackScreenStateUI createState() => SellerProductFeedbackScreenStateUI();
}

class SellerProductFeedbackScreenStateUI extends ConsumerState<SellerProductFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProductFeedBackScreenStateProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    padding: EdgeInsets.symmetric(horizontal: 18.dp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductSummaryCard(state),
                        SizedBox(height: 25.dp),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            objCommonWidgets.customText(context, 'Customer Reviews', 14, objConstantColor.black, objConstantFonts.montserratSemiBold),
                            objCommonWidgets.customText(context, '${state.reviews.length} total', 11, Colors.grey, objConstantFonts.montserratMedium),
                          ],
                        ),
                        SizedBox(height: 15.dp),
                        _buildReviewList(state.reviews),
                        SizedBox(height: 30.dp),
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

  // Requirement 1: Product Details & Overall Rating Header
  Widget _buildProductSummaryCard(SellerProductFeedBackScreenState state) {
    return Container(
      padding: EdgeInsets.all(15.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
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
          // Animated Product Image
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) => Transform.scale(scale: value, child: child),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.dp),
              child: Container(
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
                    state.productImage,
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
            ),
          ),
          SizedBox(width: 15.dp),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(context, state.productName, 16, objConstantColor.black, objConstantFonts.montserratSemiBold),
                SizedBox(height: 0.dp),

                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 15.dp),
                    SizedBox(width: 4.dp),
                    objCommonWidgets.customText(context,
                        '4.2', 13,
                        Colors.black,
                        objConstantFonts.montserratSemiBold),
                    SizedBox(width: 8.dp),
                    objCommonWidgets.customText(context,
                        '(329 reviews)', 12,
                        Colors.black.withAlpha(100),
                        objConstantFonts.montserratMedium),
                  ],
                ),
                SizedBox(height: 2.dp),
                objCommonWidgets.customText(context, "High Satisfaction", 10, Colors.grey.shade600, objConstantFonts.montserratMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Requirement 2: List of Customer Reviews with Animations
  Widget _buildReviewList(List<ProductReview> reviews) {
    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.dp),
          child: objCommonWidgets.customText(context, 'No reviews yet', 12, Colors.grey, objConstantFonts.montserratMedium),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.dp),
      itemBuilder: (context, index) {
        final review = reviews[index];

        // STAGGERED FADE-IN ANIMATION
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 150)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildReviewCard(review),
        );
      },
    );
  }

  Widget _buildReviewCard(ProductReview review) {
    return Container(
      padding: EdgeInsets.all(15.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.dp),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 18.dp,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: Image.network(
                    review.userImage,
                    width: 36.dp, // Diameter (radius * 2)
                    height: 36.dp, // Diameter (radius * 2)
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Local Placeholder Image
                          Image.asset(
                            objConstantAssest.placeholderImage,
                            width: 36.dp,
                            height: 36.dp,
                            fit: BoxFit.cover,
                          ),
                          // 2. Small White Circular Progress Bar
                          SizedBox(
                            width: 12.dp, // Scaled down for the small avatar
                            height: 12.dp,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.white24,
                            ),
                          ),
                        ],
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        objConstantAssest.profileIcon,
                        width: 36.dp,
                        height: 36.dp,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 12.dp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, review.userName, 13, objConstantColor.black, objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, review.date, 10, Colors.grey, objConstantFonts.montserratMedium),
                  ],
                ),
              ),
              // Stars for individual rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 14.dp,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12.dp),
          // Review Text
          objCommonWidgets.customText(
              context,
              review.comment,
              12,
              Colors.black.withOpacity(0.75),
              objConstantFonts.montserratMedium
          ),
        ],
      ),
    );
  }

  // Modern Header
  Widget _buildHeader(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
      child: Row(
        children: [
          CupertinoButton(padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Icon(Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 23.dp),
              onPressed: (){
                var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callNavigation(ScreenName.rating);
              }),
          SizedBox(width: 10.dp),
          objCommonWidgets.customText(context, 'Customer Ratings & Review', 14, objConstantColor.black, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }
}