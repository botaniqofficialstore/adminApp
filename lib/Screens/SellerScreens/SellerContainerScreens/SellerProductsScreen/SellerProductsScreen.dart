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
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProductsScreenStateProvider);

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
                  : AnimationLimiter(
                key: ValueKey(state.filteredProducts.length),
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(15.dp, 10.dp, 15.dp, 15.dp),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.dp,
                    crossAxisSpacing: 15.dp,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: state.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.filteredProducts[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2,
                      child: ScaleAnimation(
                        scale: 0.9,
                        child: FadeInAnimation(
                          child: _buildProductCard(product),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
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
          objCommonWidgets.customText(context, 'My Products', 14, objConstantColor.black, objConstantFonts.montserratMedium),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: (){
              var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
              userScreenNotifier.callNavigation(ScreenName.addProduct);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 10.dp),
              decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(25.dp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: objCommonWidgets.customText(context, 'Add New Product', 10, Colors.brown, objConstantFonts.montserratSemiBold),
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
              })
          ),
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
      child: isSearchVisible ? CommonTextField(
        controller: _searchController,
        placeholder: "Search Products here...",
        textSize: 12,
        fontFamily: objConstantFonts.montserratMedium,
        textColor: objConstantColor.black,
        isShowIcon: true,
        onChanged: (_) {},
      ) : const SizedBox.shrink(),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
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
                    objCommonWidgets.customText(context, "₹${product['price']}/_", 13, Color(
                        0xFF5E910E), objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, product['quantity'], 11, Colors.black54, objConstantFonts.montserratMedium)
                  ],
                ),

                SizedBox(height: 4.dp),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 10.dp),
                  decoration: BoxDecoration(
                    color: (product['stock_count'] ?? 0) <= 25 ?
                    Colors.red.withAlpha(25) : Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(15.dp)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2_sharp, size: 12.dp, color: Colors.black),
                      SizedBox(width: 4.dp),
                      objCommonWidgets.customText(
                          context,
                          "Stock: ", // Assuming 'stock_count' is the key
                          11,
                          Colors.black,
                          objConstantFonts.montserratMedium
                      ),
                      objCommonWidgets.customText(
                          context,
                          "${product['stock_count'] ?? '0'}", // Assuming 'stock_count' is the key
                          11,
                          (product['stock_count'] ?? 0) <= 25 ? Colors.red : Colors.green,
                          objConstantFonts.montserratSemiBold
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.dp),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    color: Color(0xFF301212),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco_outlined, size: 60.dp, color: Colors.green.withOpacity(0.2)),
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
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],),

        child: Icon(icon, color: Colors.brown, size: 15.dp),
      ),
    );
  }

}



