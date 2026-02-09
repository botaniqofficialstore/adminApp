import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../CommonViews/CommonWidget.dart';
import '../../../../CommonPopupViews/CommonSuccessPopup/CommonSuccessPopup.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'ConfirmPackedOrderScreenState.dart';

class ConfirmPackedOrderScreen extends ConsumerStatefulWidget {
  const ConfirmPackedOrderScreen({super.key});

  @override
  ConsumerState<ConfirmPackedOrderScreen> createState() => _ConfirmPackedOrderScreenState();
}

class _ConfirmPackedOrderScreenState extends ConsumerState<ConfirmPackedOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ConfirmPackedOrderScreenStateProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                /// ================= ANIMATED HEADER =================
                _buildAnimatedWidget(
                  index: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
                    child: Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          onPressed: () {
                            ref.read(SellerMainScreenGlobalStateProvider.notifier)
                                .callNavigation(ScreenName.confirmOrder);
                          },
                          child: Image.asset(
                            objConstantAssest.backIcon,
                            width: 20.dp,
                            color: objConstantColor.black,
                          ),
                        ),
                        SizedBox(width: 8.dp),
                        objCommonWidgets.customText(
                          context,
                          "Update Order Packed",
                          16,
                          objConstantColor.black,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ],
                    ),
                  ),
                ),

                /// ================= SCROLLABLE CONTENT =================
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dp),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          /// ORDER CARD (Animated Entrance)
                          _buildAnimatedWidget(
                            index: 1,
                            child: _orderCard(context, ref),
                          ),

                          /// PHOTO SECTION (Smooth Switcher)
                          _buildAnimatedWidget(
                            index: 2,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              switchInCurve: Curves.easeOutBack,
                              child: state.packagePhoto.isEmpty
                                  ? _uploadPackedPhoto(context, ref)
                                  : packagePhoto(context),
                            ),
                          ),

                          SizedBox(height: 100.dp),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// ================= FLOATING ORDER PACKED BUTTON =================
            _buildFloatingButton(state),
          ],
        ),
      ),
    );
  }

  /// Helper to stagger entrance animations
  Widget _buildAnimatedWidget({required int index, required Widget child}) {
    final start = (index * 0.1).clamp(0.0, 1.0);
    final end = (start + 0.5).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        )),
        child: child,
      ),
    );
  }

  Widget _buildFloatingButton(state) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      bottom: state.isAllPacked ? 20.dp : -100.dp,
      left: 15.dp,
      right: 15.dp,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: state.isAllPacked ? 1 : 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.dp),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF06AC0B).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              ref.read(SellerMainScreenGlobalStateProvider.notifier)
                  .callNavigation(ScreenName.confirmOrder);
              showConfirmPopup(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.dp),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF06AC0B), Color(0xFF048508)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22.dp),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 8.dp),
                    objCommonWidgets.customText(
                      context,
                      'Order Packed',
                      14,
                      Colors.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================== EXISTING LOGIC (PERSISTED) =====================

  void showConfirmPopup(BuildContext context) {
    PreferencesManager.getInstance().then((pref) {
      pref.setBooleanValue(PreferenceKeys.isDialogOpened, true);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CommonSuccessPopup(
          title: 'Order Ready for Pickup',
          subTitle: 'Your order has been packed successfully. Our delivery partner will reach you shortly to pick it up.',
          onClose: () {
            pref.setBooleanValue(PreferenceKeys.isDialogOpened, false);
          },
        ),
      );
    });
  }

  Widget packagePhoto(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(ConfirmPackedOrderScreenStateProvider);
        final imgPath = state.packagePhoto;
        if (imgPath.isEmpty) return const SizedBox.shrink();

        return Container(
          key: const ValueKey('photo_preview'),
          margin: EdgeInsets.only(top: 20.dp),
          padding: EdgeInsets.all(14.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.dp),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(2, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.dp),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]), shape: BoxShape.circle),
                    child: Icon(Icons.verified, color: Colors.white, size: 15.dp),
                  ),
                  SizedBox(width: 10.dp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(context, 'Packing Proof Uploaded', 13, Colors.black, objConstantFonts.montserratSemiBold),
                        objCommonWidgets.customText(context, 'Tap image to preview', 9, Colors.black54, objConstantFonts.montserratMedium),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    minimumSize: const Size(0, 0),
                    padding: EdgeInsets.zero,
                    onPressed: () => ref.read(ConfirmPackedOrderScreenStateProvider.notifier).uploadImage(context),
                    child: Container(
                      padding: EdgeInsets.all(6.dp),
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), borderRadius: BorderRadius.circular(8.dp)),
                      child: Icon(Icons.edit_outlined, size: 16.dp, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.dp),
              GestureDetector(
                onTap: () => CommonWidget().showFullScreenImageViewer(context, imageUrl: imgPath, isLocal: true),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.dp),
                  child: Image.file(File(imgPath), fit: BoxFit.contain, height: 250.dp, width: double.infinity),
                ),
              ),
              SizedBox(height: 12.dp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 5.dp),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(20.dp)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, size: 12, color: Colors.green),
                    SizedBox(width: 3.dp),
                    objCommonWidgets.customText(context, 'Order proof secured', 9, Colors.green, objConstantFonts.montserratSemiBold),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _uploadPackedPhoto(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('photo_upload'),
      margin: EdgeInsets.only(top: 18.dp),
      padding: EdgeInsets.all(14.dp),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.dp),
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            width: 46.dp,
            height: 46.dp,
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(Icons.camera_alt_outlined, color: objConstantColor.orange, size: 22),
          ),
          SizedBox(height: 10.dp),
          objCommonWidgets.customText(context, 'Upload Packed Product Photo', 13, Colors.black, objConstantFonts.montserratSemiBold),
          SizedBox(height: 4.dp),
          objCommonWidgets.customText(context, 'Add photo proof before marking order packed', 10, Colors.black54, objConstantFonts.montserratMedium, textAlign: TextAlign.center),
          SizedBox(height: 14.dp),
          CupertinoButton(
            onPressed: () => ref.read(ConfirmPackedOrderScreenStateProvider.notifier).uploadImage(context),
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: 90.dp,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.dp), border: Border.all(color: Colors.grey.withOpacity(0.35))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined, size: 22, color: Colors.grey),
                    SizedBox(height: 6.dp),
                    objCommonWidgets.customText(context, 'Tap to upload', 10, Colors.grey, objConstantFonts.montserratMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ConfirmPackedOrderScreenStateProvider);
    return Container(
      padding: EdgeInsets.all(16.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.dp),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(2, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              objCommonWidgets.customText(context, 'Order ID:', 14, objConstantColor.orange, objConstantFonts.montserratSemiBold),
              SizedBox(width: 5.dp),
              objCommonWidgets.customText(context, '578421015455', 12, Colors.black, objConstantFonts.montserratSemiBold),
              const Spacer(),
              objCommonWidgets.customText(context, '₹249/_', 18, Colors.black, objConstantFonts.montserratSemiBold),
            ],
          ),
          SizedBox(height: 10.dp),
          objCommonWidgets.customText(context, 'Order Status', 13, Colors.black, objConstantFonts.montserratSemiBold),
          orderTimeline(context),
          objCommonWidgets.customText(context, 'Purchase List', 13, Colors.black, objConstantFonts.montserratSemiBold),
          SizedBox(height: 5.dp),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.packedList.length,
            separatorBuilder: (_, __) => SizedBox(height: 14.dp),
            itemBuilder: (context, index) => _productItem(context, ref, index),
          ),
        ],
      ),
    );
  }

  Widget orderTimeline(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.dp, bottom: 14.dp),
      child: Row(
        children: [
          _statusChip(context, icon: Icons.shopping_cart, title: 'Ordered', date: '10 Jun, 10:30 AM', isActive: true),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10.dp), child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)),
          _statusChip(context, icon: Icons.check_circle_rounded, title: 'Confirmed', date: '10 Jun, 12:05 PM', isActive: true),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, {required IconData icon, required String title, required String date, required bool isActive}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 10.dp),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10.dp),
          border: Border.all(color: isActive ? objConstantColor.orange : Colors.grey.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 16.dp, color: isActive ? objConstantColor.orange : Colors.grey), SizedBox(width: 6.dp), objCommonWidgets.customText(context, title, 11, isActive ? objConstantColor.orange : Colors.grey, objConstantFonts.montserratSemiBold)]),
            SizedBox(height: 4.dp),
            objCommonWidgets.customText(context, date, 10, Colors.black54, objConstantFonts.montserratMedium),
          ],
        ),
      ),
    );
  }

  Widget _productItem(BuildContext context, WidgetRef ref, int index) {
    final state = ref.watch(ConfirmPackedOrderScreenStateProvider);
    final isPacked = state.packedList[index];

    return GestureDetector(
      onTap: () => ref.read(ConfirmPackedOrderScreenStateProvider.notifier).togglePacked(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(12.dp),
        decoration: BoxDecoration(
          color: isPacked ? Colors.green.withOpacity(0.08) : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.dp),
          border: Border.all(color: isPacked ? Colors.green.withAlpha(200) : Colors.transparent, width: 1.2),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.dp),
              child: Image.network('https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png', width: 60.dp, height: 60.dp, fit: BoxFit.cover),
            ),
            SizedBox(width: 12.dp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(context, 'Red Amaranthus', 13, Colors.black, objConstantFonts.montserratSemiBold),
                  objCommonWidgets.customText(context, '₹189 / 100g', 11, objConstantColor.orange, objConstantFonts.montserratMedium),
                  objCommonWidgets.customText(context, 'Qty: 2', 10, Colors.black54, objConstantFonts.montserratMedium),
                ],
              ),
            ),
            Column(
              children: [
                AnimatedScale(
                  scale: isPacked ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 26.dp,
                    height: 26.dp,
                    decoration: BoxDecoration(
                      color: isPacked ? Colors.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(7.dp),
                      border: Border.all(color: isPacked ? Colors.green : Colors.grey, width: 1.5),
                    ),
                    child: isPacked ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                ),
                SizedBox(height: 5.dp),
                objCommonWidgets.customText(context, 'Packed', 8, isPacked ? Colors.green : Colors.black54, isPacked ? objConstantFonts.montserratSemiBold : objConstantFonts.montserratMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}