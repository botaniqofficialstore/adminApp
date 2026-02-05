import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProductsScreenState.dart';

class SellerProductsScreen extends ConsumerStatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  SellerProductsScreenStateUI createState() => SellerProductsScreenStateUI();
}

class SellerProductsScreenStateUI extends ConsumerState<SellerProductsScreen> {
  bool isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProductsScreenStateProvider);

    // Separating products based on verification status
    // Note: Assuming 'is_verified' is the boolean key in your product map
    final verifiedProducts = state.filteredProducts.where((p) => p['is_verified'] == true).toList();
    final underVerificationProducts = state.filteredProducts.where((p) => p['is_verified'] == false).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _buildHeader(context),
            _buildAnimatedSearchField(),
            Expanded(
              child: state.filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (underVerificationProducts.isNotEmpty)
                      _buildUnderVerificationSection(underVerificationProducts),

                    SizedBox(height: 20.dp,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.dp),
                      child: objCommonWidgets.customText(context, 'Products in Live', 13, Colors.black87, objConstantFonts.montserratSemiBold),
                    ),

                    AnimationLimiter(
                      key: ValueKey(verifiedProducts.length),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(15.dp, 5.dp, 15.dp, 15.dp),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15.dp,
                          crossAxisSpacing: 15.dp,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: verifiedProducts.length,
                        itemBuilder: (context, index) {
                          final product = verifiedProducts[index];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            columnCount: 2,
                            child: ScaleAnimation(
                              scale: 0.9,
                              child: FadeInAnimation(
                                child: _buildProductCard(product, true),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUnderVerificationSection(List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verification Info Card
        Container(
          margin: EdgeInsets.all(15.dp),
          padding: EdgeInsets.all(12.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.dp),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Row(
            children: [
              Icon(Icons.gpp_maybe_rounded, color: Colors.deepOrange, size: 50.dp),
              SizedBox(width: 2.5.dp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, "Under Verification (${products.length})", 12, Colors.deepOrange, objConstantFonts.montserratSemiBold),
                    SizedBox(height: 2.dp),
                    objCommonWidgets.customText(context,
                        "Your products is currently under review. Once approved, they will be live for customers.",
                        9, Colors.black, objConstantFonts.montserratMedium),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal List for Pending Products
        SizedBox(
          height: 200.dp,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.dp),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildPendingProductItem(products[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildPendingProductItem(Map<String, dynamic> product) {
    return Container(
      width: 135.dp,
      margin: EdgeInsets.only(right: 12.dp, bottom: 5.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.dp)),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.dp, right: 5.dp, top: 5.dp),
                    child: NetworkImageLoader(
                      imageUrl: product['image'],
                      placeHolder: objConstantAssest.placeholderImage,
                      size: 60.dp,
                      imageSize: double.infinity,
                    ),
                  ),

                  Positioned(
                    top: 10.dp,
                    right: 10.dp,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.5.dp, horizontal: 5.dp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.dp)
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.hourglass_bottom, color: Colors.deepOrange, size: 12.dp),
                          SizedBox(width: 2.dp),
                          objCommonWidgets.customText(context, 'Pending', 8.5, Colors.deepOrange, objConstantFonts.montserratBold),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.dp, right: 10.dp, top: 10.dp, bottom: 5.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(context, product['name'], 11.5, Colors.black, objConstantFonts.montserratMedium),
                SizedBox(height: 4.dp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    objCommonWidgets.customText(context, "₹${product['price']}/_", 13, const Color(0xFF5E910E), objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, product['quantity'], 11, Colors.black54, objConstantFonts.montserratMedium)
                  ],
                ),

                SizedBox(height: 10.dp),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(5.dp),
                    onPressed: () {
                      var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                      userScreenNotifier.callNavigation(ScreenName.productDetails);
                    },
                    child: Padding(
                        padding: EdgeInsets.all(8.dp),
                        child: objCommonWidgets.customText(context, 'View Details', 10, Colors.white, objConstantFonts.montserratSemiBold)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isVerified) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(35), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.dp, right: 5.dp, top: 5.dp),
                  child: NetworkImageLoader(
                    imageUrl: product['image'],
                    placeHolder: objConstantAssest.placeholderImage,
                    size: 80.dp,
                    imageSize: double.infinity,
                  ),
                ),
                if (isVerified)
                  Positioned(
                    top: 10.dp,
                    right: 10.dp,
                    child: Container(
                      padding: EdgeInsets.all(4.dp),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.verified, color: Colors.green, size: 16.dp),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(context, product['name'], 11.5, Colors.black, objConstantFonts.montserratMedium),
                SizedBox(height: 4.dp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    objCommonWidgets.customText(context, "₹${product['price']}/_", 13, const Color(0xFF5E910E), objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, product['quantity'], 11, Colors.black54, objConstantFonts.montserratMedium)
                  ],
                ),
                SizedBox(height: 8.dp),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                  decoration: BoxDecoration(
                      color: (product['stock_count'] ?? 0) <= 25 ? Colors.red.withAlpha(25) : Colors.green.withAlpha(25),
                      borderRadius: BorderRadius.circular(15.dp)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      objCommonWidgets.customText(context, "Stock: ", 11, (product['stock_count'] ?? 0) <= 25 ? Colors.red : Colors.green, objConstantFonts.montserratSemiBold),
                      objCommonWidgets.customText(context, "${product['stock_count'] ?? '0'}", 11,
                          (product['stock_count'] ?? 0) <= 25 ? Colors.red : Colors.green, objConstantFonts.montserratSemiBold),
                      SizedBox(width: 4.dp),
                      Icon((product['stock_count'] ?? 0) <= 25 ? Icons.trending_down : Icons.trending_up, color: (product['stock_count'] ?? 0) <= 25 ? Colors.red : Colors.green, size: 12.dp),
                    ],
                  ),
                ),
                SizedBox(height: 10.dp),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    color: const Color(0xFF0B1F37),
                    borderRadius: BorderRadius.circular(5.dp),
                    onPressed: () {
                      var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                      userScreenNotifier.callNavigation(ScreenName.productDetails);
                    },
                    child: Padding(
                        padding: EdgeInsets.all(10.dp),
                        child: objCommonWidgets.customText(context, 'View Details', 10, Colors.white, objConstantFonts.montserratSemiBold)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Original Header & Search Field (Unchanged per requirement) ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
                userScreenNotifier.callNavigation(ScreenName.profile);
              }),
          SizedBox(width: 5.dp),
          objCommonWidgets.customText(context, 'My Products', 14, objConstantColor.black, objConstantFonts.montserratMedium),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () {
              var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
              userScreenNotifier.callNavigation(ScreenName.addProduct);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 10.dp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.dp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: objCommonWidgets.customText(context, 'Add New Product', 10, Colors.deepOrange, objConstantFonts.montserratSemiBold),
            ),
          ),
          SizedBox(width: 8.dp),
          _buildCircleIconButton(
              isSearchVisible ? Icons.close_rounded : CupertinoIcons.search,
                  () => setState(() {
                isSearchVisible = !isSearchVisible;
                if (!isSearchVisible) {
                  _searchController.clear();
                  ref.read(sellerProductsScreenStateProvider.notifier).updateSearch('');
                }
              })),
        ],
      ),
    );
  }

  Widget _buildAnimatedSearchField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isSearchVisible ? 60.dp : 0,
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
      child: isSearchVisible
          ? CommonTextField(
        controller: _searchController,
        placeholder: "Search Products here...",
        textSize: 12,
        fontFamily: objConstantFonts.montserratMedium,
        textColor: objConstantColor.black,
        isShowIcon: true,
        onChanged: (val) {
          ref.read(sellerProductsScreenStateProvider.notifier).updateSearch(val);
        },
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco, size: 60.dp, color: Colors.green.withAlpha(65)),
          SizedBox(height: 15.dp),
          objCommonWidgets.customText(context, 'No matching products', 14, Colors.grey, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon, VoidCallback onTap) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.all(8.dp),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Icon(icon, color: Colors.deepOrange, size: 15.dp),
      ),
    );
  }
}