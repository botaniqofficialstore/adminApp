import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerSettingsScreenState.dart';

class SellerSettingsScreen extends ConsumerStatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  SellerSettingsScreenState createState() => SellerSettingsScreenState();
}

class SellerSettingsScreenState extends ConsumerState<SellerSettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animation Definitions
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Start the animation sequence
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerSettingsScreenStateProvider);
    final notifier = ref.read(sellerSettingsScreenStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Animation
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
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
                        objCommonWidgets.customText(context, 'Settings', 14, objConstantColor.black, objConstantFonts.montserratMedium),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.dp),

              // 🔹 Label Animation
              _buildStaggeredWrapper(
                delay: 0.3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.dp),
                  child: objCommonWidgets.customText(
                    context,
                    'RECOMMENDATION & REMINDERS',
                    10,
                    objConstantColor.navyBlue,
                    objConstantFonts.montserratMedium,
                  ),
                ),
              ),

              SizedBox(height: 10.dp),

              // 🔹 Description Card Animation
              _buildStaggeredWrapper(
                delay: 0.4,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
                  child: objCommonWidgets.customText(
                      context,
                      "Keep this on to avoid missing new orders and delivery updates. Notifications will be sent via app, WhatsApp, and SMS.",
                      10,
                      objConstantColor.navyBlue,
                      objConstantFonts.montserratMedium
                  ),
                ),
              ),

              SizedBox(height: 5.dp),

              // 🔹 Toggles Animation (Cascading one by one)
              _buildStaggeredWrapper(
                delay: 0.5,
                child: _buildModernToggle("Push Notifications", state.pushNotify, notifier.togglePush),
              ),
              SizedBox(height: 1.dp),
              _buildStaggeredWrapper(
                delay: 0.6,
                child: _buildModernToggle("WhatsApp Alerts", state.whatsappNotify, notifier.toggleWhatsapp),
              ),
              SizedBox(height: 1.dp),
              _buildStaggeredWrapper(
                delay: 0.7,
                child: _buildModernToggle("SMS Updates", state.smsNotify, notifier.toggleSms),
              ),

              SizedBox(height: 12.dp),
            ],
          ),
        ),
      ),
    );
  }

  /// 🛠️ PRO HELPER: Wraps a widget with a staggered fade/slide entrance
  Widget _buildStaggeredWrapper({required double delay, required Widget child}) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay, (delay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, animChild) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 10.dp),
            child: animChild,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildModernToggle(String title, bool value, Function(bool) onChanged) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.dp, horizontal: 15.dp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            objCommonWidgets.customText(context, title, 11.5, objConstantColor.black, objConstantFonts.montserratMedium),
            Transform.scale(
                scale: 0.85,
                child: CupertinoSwitch(
                    activeTrackColor: Colors.green,
                    value: value,
                    onChanged: onChanged
                )
            ),
          ],
        ),
      ),
    );
  }
}