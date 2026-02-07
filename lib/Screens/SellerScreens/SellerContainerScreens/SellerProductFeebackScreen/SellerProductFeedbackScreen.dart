import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProductFeedbackScreenState.dart';

class SellerProductFeedbackScreen extends ConsumerStatefulWidget {
  const SellerProductFeedbackScreen({super.key});

  @override
  SellerProductFeedbackScreenStateUI createState() => SellerProductFeedbackScreenStateUI();
}

class SellerProductFeedbackScreenStateUI extends ConsumerState<SellerProductFeedbackScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProductFeedBackScreenStateProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // optional
        statusBarIconBrightness: Brightness.light, // ANDROID → black icons
        statusBarBrightness: Brightness.dark, // iOS → black icons
      ),
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [

              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    productImageView(),

                    /// BLACK GRADIENT OVERLAY (FULL COVER)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withAlpha(220),
                              Colors.black.withAlpha(100),// top dark
                              Colors.transparent, // bottom dark
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 5.dp,
                      left: 15.dp,
                      child: SafeArea(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(30.dp),
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.all(8.dp),
                            minimumSize: Size.zero,
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              objConstantAssest.backIcon,
                              color: Colors.white,
                              width: 18.dp,
                            ),
                            onPressed: () {
                              var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                              userScreenNotifier.callNavigation(ScreenName.rating);
                            },
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 40.dp,
                      left: 15.dp,
                      right: 15.dp, // 👈 important for smooth slide
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 0.0), // 1 → 0
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(60 * value, 0), // 👉 slide from right
                            child: Opacity(
                              opacity: 1 - value, // optional fade-in
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Red Amaranthus',
                              23,
                              Colors.white,
                              objConstantFonts.montserratSemiBold,
                            ),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber, size: 18.dp),
                                SizedBox(width: 4.dp),
                                objCommonWidgets.customText(
                                  context,
                                  '4.2',
                                  15,
                                  Colors.white,
                                  objConstantFonts.montserratSemiBold,
                                ),
                                SizedBox(width: 8.dp),
                                objCommonWidgets.customText(
                                  context,
                                  '(329 reviews)',
                                  13,
                                  Colors.white.withAlpha(180),
                                  objConstantFonts.montserratMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 2.dp),
                            objCommonWidgets.customText(
                              context,
                              "High Satisfaction",
                              12,
                              Colors.white,
                              objConstantFonts.montserratMedium,
                            ),
                          ],
                        ),
                      ),
                    ),


                    Positioned(
                      bottom: -18.dp,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40.dp,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
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

              SliverToBoxAdapter(
                  child: Container(
                      color: const Color(0xFFF4F4F4),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.dp),
                        child: Column(
                          children: [
                            SizedBox(height: 15.dp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                objCommonWidgets.customText(context, 'Customer Reviews', 14, objConstantColor.black, objConstantFonts.montserratSemiBold),
                                objCommonWidgets.customText(context, '${state.reviews.length} total', 11, Colors.black, objConstantFonts.montserratMedium),
                              ],
                            ),
                            SizedBox(height: 10.dp),
                            _buildReviewList(state.reviews),
                            SizedBox(height: 15.dp),
                          ],
                        ),
                      )
                  )
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget productImageView(){
    final state = ref.watch(sellerProductFeedBackScreenStateProvider);

    return SizedBox(
      height: 320.dp,
      child: NetworkImageLoader(
        imageUrl: state.productImage,
        placeHolder: objConstantAssest.placeholderImage,
        size: 180.dp,
        imageSize: double.infinity,
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
              10,
              Colors.black.withOpacity(0.75),
              objConstantFonts.montserratMedium
          ),
        ],
      ),
    );
  }
}