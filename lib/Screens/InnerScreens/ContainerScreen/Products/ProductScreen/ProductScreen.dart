import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../CodeReusable/utilities.dart';
import '../../../../../CommonViews/CommonWidget.dart';
import '../../../../../Constants/ConstantAssests.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import '../ProductModel.dart';
import 'ProductScreenState.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends ConsumerState<ProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> productType = [
    'All',
    'Fresh',
    'Spices & Herbs',
    'Oils & Staples',
    'Health & Wellness',
    'Personal Care',
    'Healthy Snacks'
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var productScreenState = ref.watch(ProductScreenStateProvider);
    var productScreenNotifier = ref.watch(ProductScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
              child: Column(
                children: [
                  SizedBox(height: 5.dp,),

                  Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'Products',
                        23,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),

                      Spacer(),

                      CupertinoButton(padding: EdgeInsets.zero, child: Image.asset(
                        objConstantAssest.menuIcon,
                        height: 25.dp,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ), onPressed: (){
                        mainScaffoldKey.currentState?.openDrawer();
                      })

                    ],
                  ),

                  SizedBox(height: 10.dp,),

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: productScreenState.searchController,
                          placeholder: "Search by product name...",
                          textSize: 15,
                          fontFamily: objConstantFonts.montserratMedium,
                          textColor: objConstantColor.white,
                          isNumber: false,
                          isDarkView: true,
                          isShowIcon: true,
                          onChanged: (value) {

                          },
                        ),
                      ),

                      SizedBox(width: 10.dp),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          decoration: BoxDecoration(
                            color: objConstantColor.yellow,
                            borderRadius: BorderRadius.circular(7.dp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(7.dp),
                            child: Image.asset(
                              objConstantAssest.addProduct,
                              width: 30.dp,
                              height: 30.dp,
                              color: objConstantColor.black,
                            ),
                          ),
                        ),
                        onPressed: () {
                          userScreenNotifier.callNavigation(ScreenName.addProduct);
                        }
                      )
                    ],
                  ),

                  SizedBox(height: 15.dp),

                  SizedBox(
                    height: 30.dp,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: productType.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.dp),
                      itemBuilder: (context, index) {
                        bool isSelected = productScreenState.selectedIndex == index;

                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            productScreenNotifier.updateSelectedIndex(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 5.dp),
                            decoration: BoxDecoration(
                              color: isSelected ? objConstantColor.yellow : Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.dp),
                              border: Border.all(
                                color: isSelected ? objConstantColor.yellow : Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: objCommonWidgets.customText(context,
                                  productType[index],
                                  14,
                                  isSelected ? Colors.black : Colors.white,
                                  objConstantFonts.montserratMedium),
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  SizedBox(height: 20.dp,),


                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.60,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final product = ProductData(
                          id: "1",
                          productId: "P001",
                          productName: "Organic Microgreens",
                          productPrice: 150,
                          productSellingPrice: 120,
                          gram: 100,
                          image: "https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png",
                          coverImage: "https://dummyimage.com/600x300/00cc66/ffffff&text=Cover+Image",
                          createdAt: "2025-01-01",
                          updatedAt: "2025-01-02",
                          v: 0,
                          isWishlisted: 0,
                          inCart: 0,
                        );
                        return _buildProductCard(product, index);
                      },
                    ),
                  )




                ],
              ),
            )

        ),
      ),
    );
  }


  // ✅ Product Card Widget
  Widget _buildProductCard(ProductData product, int index ) {
    final GlobalKey sourceKey = GlobalKey(); // 👈 unique key per product heart

    return GestureDetector(
      onTap: () {


      },
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: objConstantColor.white.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Fixed height image
                SizedBox(
                  height: 130.dp,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.dp),
                    child: Stack(
                      children: [
                        // ✅ Background Image
                        Positioned.fill(
                          child: Image.network(
                            '${ConstantURLs.baseUrl}${product.image}',
                            width: 120.dp,
                            height: 120.dp,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                objConstantAssest.sampleProduct, // fallback image from assets
                                width: 130.dp,
                                height: 130.dp,
                                fit: BoxFit.cover,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CupertinoActivityIndicator(
                                  color: objConstantColor.white,
                                ),
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ✅ Name
                Text(CodeReusability().cleanProductName(product.productName),
                  style: TextStyle(
                    color: objConstantColor.white,
                    fontSize: 15.dp,
                    fontFamily: ConstantAssests.montserratSemiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.dp),
                  child: Row(
                    children: [
                      Text(
                        "₹${product.productSellingPrice}/_",
                        style: TextStyle(
                          color: objConstantColor.yellow,
                          fontSize: 14.dp,
                          fontFamily: ConstantAssests.montserratSemiBold,
                        ),
                      ),
                      SizedBox(width: 3.dp),
                      Text(
                        "₹${product.productPrice}/_",
                        style: TextStyle(
                          color: objConstantColor.white,
                          fontSize: 14.dp,
                          fontFamily: ConstantAssests.montserratMedium,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: objConstantColor.yellow,
                          decorationThickness: 2.dp,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "${product.gram}gm",
                  style: TextStyle(
                    color: objConstantColor.white,
                    fontSize: 14.dp,
                    fontFamily: ConstantAssests.montserratSemiBold,
                  ),
                ),

                const Spacer(),

                // ✅ Add to cart button
                SizedBox(
                  height: 35.dp,
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: objConstantColor.yellow,
                    borderRadius: BorderRadius.circular(5.dp),
                    child: Text(
                      'Edit Product',
                      style: TextStyle(
                        color: objConstantColor.black,
                        fontSize: 13.dp,
                        fontFamily: ConstantAssests.montserratSemiBold,
                      ),
                    ),
                    onPressed: () {
                      var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                      userScreenNotifier.callNavigation(ScreenName.addProduct);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // ✅ Offer label
        Positioned(
            top: 9.dp,
            left: 1.dp,
            child: Container(
              color: objConstantColor.yellow,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 5.dp, top: 1.dp, bottom: 1.dp, right: 10.dp),
                child: Text(
                  "${PriceHelper.getDiscountPercentage(
                    productPrice: product.productPrice ?? 0,
                    sellingPrice: product.productSellingPrice ?? 0,
                  )} OFF",
                  style: TextStyle(
                    color: objConstantColor.black,
                    fontSize: 12.dp,
                    fontFamily: ConstantAssests.montserratSemiBold,
                  ),
                ),
              ),
            ))
      ]),
    );
  }


}