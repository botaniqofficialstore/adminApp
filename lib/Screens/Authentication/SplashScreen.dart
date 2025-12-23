
import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../Constants/ConstantColors.dart';
import '../../Utility/Logger.dart';
import '../../Utility/PreferencesManager.dart';
import '../AdminScreens/InnerScreens/MainScreen/MainScreen.dart';
import 'LoginScreen/LoginScreen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' show LocalAuthException;


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

  final LocalAuthentication _auth = LocalAuthentication();
  bool _authTriggered = false;


  @override
  void initState() {
    super.initState();

    // Play your animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.forward();

    // Trigger navigation only once
    Future.delayed(const Duration(seconds: 1), _callNavigation);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _callNavigation() async {
    if (_authTriggered) return;
    _authTriggered = true;
    Logger().log('Called:  _callNavigation');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );

    /*PreferencesManager.getInstance().then((pref) async {
      bool isLoggedIn = pref.getBooleanValue(PreferenceKeys.isUserLogged);

      if (isLoggedIn) {
        bool passed = await authenticateUser();

        if (!mounted) return;

        if (passed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });*/
  }


  Future<bool> authenticateUser() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        return true;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access Botaniq Admin',
        biometricOnly: false,
        // FIX: THIS PREVENTS MULTIPLE PROMPTS
        persistAcrossBackgrounding: false,
      );

      return didAuthenticate;

    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
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
