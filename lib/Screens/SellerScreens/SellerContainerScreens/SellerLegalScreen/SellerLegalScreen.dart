import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerLegalScreenState.dart';

class SellerLegalScreen extends ConsumerStatefulWidget {
  const SellerLegalScreen({super.key});

  @override
  SellerLegalScreenStateUI createState() => SellerLegalScreenStateUI();
}

class SellerLegalScreenStateUI extends ConsumerState<SellerLegalScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _infoCardSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _infoCardSlide = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    // Start the animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerLegalScreenStateProvider);
    // Note: notifier is available if needed for state logic
    // final notifier = ref.read(sellerLegalScreenStateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Soft organic mint-white
      body: SafeArea(
        child: Column(
          children: [
            // Header (Static for immediate interaction)
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 23.dp),
                    onPressed: () {
                      var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                      userScreenNotifier.callNavigation(ScreenName.profile);
                    },
                  ),
                  SizedBox(width: 10.dp),
                  objCommonWidgets.customText(context, 'Legal & Information', 14, objConstantColor.black, objConstantFonts.montserratMedium),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // 🔹 Animated Info Card
                    SlideTransition(
                      position: _infoCardSlide,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildInfoCard(),
                      ),
                    ),

                    SizedBox(height: 20.dp),

                    // 🔹 Legal Accordion List with Staggered Animation
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.legalItems.length,
                      separatorBuilder: (context, index) => SizedBox(height: 2.dp),
                      itemBuilder: (context, index) {
                        final item = state.legalItems[index];

                        // Calculate stagger interval for list items
                        final start = (0.3 + (index * 0.1)).clamp(0.0, 1.0);
                        final end = (start + 0.4).clamp(0.0, 1.0);

                        final itemAnimation = CurvedAnimation(
                          parent: _controller,
                          curve: Interval(start, end, curve: Curves.easeOut),
                        );

                        return AnimatedBuilder(
                          animation: itemAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: itemAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - itemAnimation.value) * 20),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.symmetric(horizontal: 15.dp),
                                title: objCommonWidgets.customText(
                                    context, item.title, 13, Colors.black, objConstantFonts.montserratMedium),
                                leading: Icon(Icons.gavel_rounded, color: const Color(0xFF0C7301), size: 18.dp),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.dp, right: 15.dp, bottom: 15.dp),
                                    child: objCommonWidgets.customText(
                                        context, item.content, 11.5, Colors.black, objConstantFonts.montserratRegular),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 30.dp),

                    // 🔹 Subtle Version Footer Animation
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                      ),
                      child: Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: objCommonWidgets.customText(context, 'Version 1.0.4', 10, Colors.black, objConstantFonts.montserratMedium),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.dp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.dp),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF292929), Color(0xFF6F706F)],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.checkmark_shield_fill, color: Colors.white, size: 30.dp),
          SizedBox(height: 10.dp),
          objCommonWidgets.customText(context, 'Botaniq Seller Policy', 16, objConstantColor.white, objConstantFonts.montserratSemiBold),
          SizedBox(height: 5.dp),
          objCommonWidgets.customText(context, 'Ensuring a fair and transparent organic marketplace for all our partners.', 12, objConstantColor.white, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }
}