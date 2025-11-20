import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import '../../MainScreen/MainScreen.dart';
import 'ProfileScreenState.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    var dashboardScreenState = ref.watch(ProfileScreenStateProvider);
    var dashboardScreenNotifier = ref.watch(ProfileScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 15.dp),
            child: Column(
              children: [
                SizedBox(height: 5.dp,),

                Row(
                  children: [
                    objCommonWidgets.customText(
                      context,
                      'Profile',
                      30,
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

                SizedBox(height: 25.dp,),
              ],
            ),
          )

        ),
      ),
    );
  }

}