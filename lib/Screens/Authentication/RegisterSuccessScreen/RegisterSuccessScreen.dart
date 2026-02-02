import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import '../../../Constants/ConstantVariables.dart';
import '../LoginScreen/LoginScreen.dart';

class RegisterSuccessScreen extends StatefulWidget {
  const RegisterSuccessScreen({super.key});

  @override
  State<RegisterSuccessScreen> createState() => _RegisterSuccessScreenState();
}

class _RegisterSuccessScreenState extends State<RegisterSuccessScreen> {
  // We use separate booleans to trigger each element precisely
  bool _showBg = false;
  bool _showTitle = false;
  bool _showText1 = false;
  bool _showText2 = false;
  bool _showText3 = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  // A controlled sequence is much smoother than nested timers
  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _showBg = true);

    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    setState(() => _showTitle = true);

    await Future.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    setState(() => _showText1 = true);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _showText2 = true);

    await Future.delayed(const Duration(milliseconds: 240));
    if (!mounted) return;
    setState(() => _showText3 = true);

    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _showButton = true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black, // Prevents white flash
          body: Stack(
            fit: StackFit.expand,
            children: [
              /// 🔹 Background Image (Smooth Zoom)
              AnimatedScale(
                scale: _showBg ? 1.0 : 1.15,
                duration: const Duration(seconds: 3),
                curve: Curves.linearToEaseOut,
                child: Image.asset(
                  objConstantAssest.loginPicOne,
                  fit: BoxFit.cover,
                ),
              ),

              /// 🔹 Blur Overlay
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),

              Positioned(
                top: 0.dp,
                child: Lottie.asset(
                  objConstantAssest.celebration,
                  repeat: false,
                  height: MediaQuery.of(context).size.height/2 + 100.dp,
                 fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width
                ),
              ),

              /// 🔹 Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.dp),
                  child: Column(
                    children: [

                      SizedBox(height: 120.dp),


                      _SmoothFadeSlide(
                        show: _showTitle,
                        child: objCommonWidgets.customText(
                          context,
                          'Registration Successful',
                          20,
                          Colors.yellowAccent,
                          objConstantFonts.montserratBold,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 50.dp),



                      _SmoothFadeSlide(
                        show: _showText1,
                        child: objCommonWidgets.customText(
                            context,
                            'Thank you for registering. Your seller account has been successfully created.',
                            12,
                            Colors.white,
                            objConstantFonts.montserratSemiBold,
                            textAlign: TextAlign.center
                        ),
                      ),

                      SizedBox(height: 15.dp),

                      _SmoothFadeSlide(
                        show: _showText2,
                        child: objCommonWidgets.customText(
                            context,
                            'We’re excited to have you as part of our growing community of trusted seller partners.',
                            12,
                            Colors.white,
                            objConstantFonts.montserratRegular,
                            textAlign: TextAlign.center
                        ),
                      ),

                      SizedBox(height: 15.dp),

                      _SmoothFadeSlide(
                        show: _showText3,
                        child: objCommonWidgets.customText(
                            context,
                            'You’re now ready to showcase your products to customers who value quality and authenticity. Start selling today and grow your business with confidence.',
                            12,
                            Colors.white,
                            objConstantFonts.montserratRegular,
                            textAlign: TextAlign.center
                        ),
                      ),

                      const Spacer(),

                      _SmoothFadeSlide(
                        show: _showButton,
                        isButton: true,
                        child: CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 20.dp),
                          onPressed: () => Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 13.dp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.dp),
                            ),
                            child: Center(
                              child: objCommonWidgets.customText(
                                  context, 'Back to Login', 13, Colors.black, objConstantFonts.montserratSemiBold),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 50.dp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper component for optimized animations
class _SmoothFadeSlide extends StatelessWidget {
  final bool show;
  final Widget child;
  final bool isButton;

  const _SmoothFadeSlide({required this.show, required this.child, this.isButton = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: show ? Offset.zero : const Offset(0, 0.1),
      duration: Duration(milliseconds: isButton ? 800 : 600),
      curve: isButton ? Curves.easeOutBack : Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );
  }
}