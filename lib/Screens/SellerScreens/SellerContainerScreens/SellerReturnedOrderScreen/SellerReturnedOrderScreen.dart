import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../CommonPopupViews/CalendarFilterPopup/CalendarFilterPopup.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../../Utility/NetworkImageLoader.dart';
import 'SellerReturnedOrderScreenState.dart';

class SellerReturnedOrderScreen extends ConsumerStatefulWidget {
  const SellerReturnedOrderScreen({super.key});

  @override
  SellerReturnedOrderScreenState createState() => SellerReturnedOrderScreenState();
}

class SellerReturnedOrderScreenState extends ConsumerState<SellerReturnedOrderScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Animation Controllers
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    Future.microtask(() {
      var screenNotifier = ref.read(sellerReturnedOrderScreenStateProvider.notifier);
      screenNotifier.getFilteredDate(DateFilterType.last7Days);
      _mainController.forward(); // Start animations
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(sellerReturnedOrderScreenStateProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 15.dp),
                _buildSearchBar(userScreenState),
                SizedBox(height: 15.dp),
                Expanded(
                  child: _buildAnimatedList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// HEADER WITH SLIDE ANIMATION
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoButton(
                minimumSize: Size(0, 0),
                padding: EdgeInsets.zero,
                child: SizedBox(
                    width: 20.dp,
                    child: Image.asset(
                      objConstantAssest.backIcon,
                      color: objConstantColor.black,
                    )),
                onPressed: () {
                  var userScreenNotifier = ref.read(SellerMainScreenGlobalStateProvider.notifier);
                  userScreenNotifier.callHomeNavigation();
                }),
            SizedBox(width: 2.5.dp),
            objCommonWidgets.customText(
              context,
              "Return Order's",
              16,
              objConstantColor.black,
              objConstantFonts.montserratSemiBold,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// SEARCH BAR WITH SCALE ANIMATION
  Widget _buildSearchBar(userScreenState) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
            .animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut)),
        child: Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: userScreenState.searchController,
                placeholder: "Search by order ID...",
                textSize: 13,
                fontFamily: objConstantFonts.montserratMedium,
                textColor: objConstantColor.black,
                isNumber: false,
                isDarkView: false,
                isShowIcon: true,
                onChanged: (_) {},
              ),
            ),
            SizedBox(width: 10.dp),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                var userScreenNotifier = ref.watch(
                    SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callOrderHistoryNavigation();
              },
              child: Container(
                padding: EdgeInsets.all(8.dp),
                decoration: BoxDecoration(
                  color: const Color(0xFF795548),
                  borderRadius: BorderRadius.circular(8.dp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(Icons.history_rounded, size: 22.dp, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// LIST WITH STAGGERED ITEM ANIMATION
  Widget _buildAnimatedList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 5, // Replace with your actual list length
      itemBuilder: (context, index) {
        // Create an individual animation for each item
        final itemDelay = (index * 0.1).clamp(0.0, 1.0);
        final Animation<double> itemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(0.3 + itemDelay, 1.0, curve: Curves.decelerate),
          ),
        );

        return AnimatedBuilder(
          animation: itemAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: itemAnimation,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - itemAnimation.value)),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.dp),
            child: cellView(context),
          ),
        );
      },
    );
  }

  Widget cellView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.dp),
        border: Border.all(color: const Color(0xFF795548).withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          /// 1. TOP HEADER
          Container(
            padding: EdgeInsets.all(16.dp),
            decoration: BoxDecoration(
              color: const Color(0xFF795548).withAlpha(10),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.dp)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    objCommonWidgets.customText(context, 'RETURN ORDER', 10, const Color(0xFF795548), objConstantFonts.montserratBold),
                    SizedBox(height: 2.dp),
                    objCommonWidgets.customText(context, '578421015', 14, Colors.black, objConstantFonts.montserratSemiBold),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    objCommonWidgets.customText(context, 'Drop On', 10, const Color(0xFF795548), objConstantFonts.montserratBold),
                    SizedBox(height: 2.dp),
                    objCommonWidgets.customText(context, '10 Jan', 10, Colors.black, objConstantFonts.montserratSemiBold),
                  ],
                ),
              ],
            ),
          ),

          /// 2. MIDDLE CONTENT
          Padding(
            padding: EdgeInsets.all(16.dp),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.dp),
                      decoration: BoxDecoration(color: const Color(0xFF795548).withAlpha(20), shape: BoxShape.circle),
                      child: Icon(Icons.person_outline, size: 18.dp, color: const Color(0xFF795548)),
                    ),
                    SizedBox(width: 12.dp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          objCommonWidgets.customText(context, 'Johnathan Doe', 12, Colors.black, objConstantFonts.montserratSemiBold),
                          objCommonWidgets.customText(context, 'Pickup: Chandra Nagar, Palakkad', 10, Colors.black.withAlpha(150), objConstantFonts.montserratMedium),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.dp),
                    Column(
                      children: [
                        objCommonWidgets.customText(context, '₹249.00', 14, Colors.black, objConstantFonts.montserratSemiBold),
                        objCommonWidgets.customText(context, 'Refund Amount', 9, const Color(0xFF795548), objConstantFonts.montserratBold),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.dp),
                  child: Divider(color: const Color(0xFF795548).withAlpha(30), height: 1),
                ),
                _buildDeliveryPartnerRow(context),
              ],
            ),
          ),

          /// 3. BOTTOM FOOTER
          Padding(
            padding: EdgeInsets.fromLTRB(16.dp, 0, 16.dp, 16.dp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context, 'Reason for Return:', 9, Colors.black.withAlpha(150), objConstantFonts.montserratMedium),
                      objCommonWidgets.customText(context, 'Damaged during transit', 11, Colors.redAccent, objConstantFonts.montserratSemiBold),
                    ],
                  ),
                ),
                _buildDetailsButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPartnerRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.dp),
      decoration: BoxDecoration(
        color: const Color(0xFF795548).withAlpha(15),
        borderRadius: BorderRadius.circular(12.dp),
      ),
      child: Row(
        children: [
          Container(
            height: 35.dp, width: 35.dp,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.dp),
                border: Border.all(color: Colors.grey.withAlpha(40))
            ),
            child: Icon(Icons.delivery_dining, color: const Color(0xFF795548), size: 20.dp),
          ),
          SizedBox(width: 12.dp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                objCommonWidgets.customText(context, 'Delivery Partner', 9, Colors.black, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, 'Rajesh K.', 11, Colors.black, objConstantFonts.montserratSemiBold),
              ],
            ),
          ),
          CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              onPressed: () {
                var screenNotifier = ref.read(sellerReturnedOrderScreenStateProvider.notifier);
                screenNotifier.makePhoneCall('9061197505');
              },
              child: const CircleAvatar(
                  backgroundColor: Color(0xFF795548),
                  child: Icon(Icons.call, size: 18, color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => showPurchaseBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 8.dp),
        decoration: BoxDecoration(
          color: const Color(0xFF795548),
          borderRadius: BorderRadius.circular(8.dp),
        ),
        child: objCommonWidgets.customText(context, 'View Details', 8.5, Colors.white, objConstantFonts.montserratBold),
      ),
    );
  }












  // ===================== BOTTOM SHEET =====================

  void showPurchaseBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        barrierColor: Colors.black.withOpacity(0.35),
        builder: (_) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.dp)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.dp),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.dp),
                        child: Container(
                          width: 40.dp,
                          height: 4.dp,
                          decoration: BoxDecoration(
                            color: objConstantColor.black.withAlpha(80),
                            borderRadius: BorderRadius.circular(10.dp),
                          ),
                        ),
                      ),

                      Expanded(
                        child: CustomScrollView(
                          controller: scrollController, // 🔥 ONE controller
                          slivers: [

                            /// HEADER CONTENT
                            SliverToBoxAdapter(
                              child: Column(
                                children: [


                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.dp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        objCommonWidgets.customText(
                                          context, "Purchase Details", 16,
                                          Color(0xFF795548),
                                          objConstantFonts
                                              .montserratSemiBold,),
                                        CupertinoButton(
                                          minimumSize: Size(0, 0),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            padding: EdgeInsets.all(6.dp),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF795548).withAlpha(30),),
                                            child: Icon(Icons.close_rounded,
                                                size: 18.dp,
                                                color: Color(0xFF795548)),),),
                                      ],),),

                                  SizedBox(height: 15.dp),
                                  productListView()


                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
  }

  Widget productListView(){
    final state = ref.watch(sellerReturnedOrderScreenStateProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10.dp),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.dp,
        crossAxisSpacing: 10.dp,
        childAspectRatio: 0.68,
      ),
      itemCount: state.productList.length,
      itemBuilder: (context, index) {
        final product = state.productList[index];
        return buildProductCard(product);
      },
    );
  }


  Widget buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dp),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(35),
              blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.dp, right: 5.dp, top: 5.dp),
              child: NetworkImageLoader(
                imageUrl: product['image'],
                placeHolder: objConstantAssest.placeholderImage,
                size: 80.dp,
                imageSize: double.infinity,
              ),
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
                    objCommonWidgets.customText(context, "₹${product['price']}/_", 12, const Color(
                        0xFF588E03), objConstantFonts.montserratSemiBold),
                    objCommonWidgets.customText(context, product['quantity'], 11, Colors.black54, objConstantFonts.montserratMedium)
                  ],
                ),
                objCommonWidgets.customText(context, 'Item count: ${product['count']}', 10, Colors.black, objConstantFonts.montserratMedium)


              ],
            ),
          ),
        ],
      ),
    );
  }

}
