
import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../Constants/ConstantColors.dart';
import '../../Utility/PreferencesManager.dart';
import 'LoginScreen/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _qMoveAnimation;
  late Animation<Offset> _botaniSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // ✅ Add listener for animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate when animation is done
        _callNavigation();
      }
    });

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _callNavigation() {
    PreferencesManager.getInstance().then((pref) async {
      bool isLoggedIn = pref.getBooleanValue(PreferenceKeys.isUserLogged);


      if (isLoggedIn){
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );*/
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors().white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: objConstantColor.navyBlue,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(25.dp),
          child: Container(
          decoration: BoxDecoration(
            color: objConstantColor.navyBlue,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(30.dp), // smaller padding
          child: Column(
            mainAxisSize: MainAxisSize.min, // removes extra column space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                objConstantAssest.logo,
                width: 150.dp,
              ),
              objCommonWidgets.customText(
                context,
                'Since 2025',
                10,
                objConstantColor.white,
                objConstantFonts.montserratMedium,
              ),
            ],
          ),
        ),

        ),
      ),
    );
  }

}
