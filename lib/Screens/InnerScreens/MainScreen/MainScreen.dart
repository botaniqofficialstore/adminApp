import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../Constants/ConstantVariables.dart';
import '../../../Constants/Constants.dart';
import '../../../Utility/PreferencesManager.dart';
import '../../../Utility/SideMenu.dart';
import 'MainScreenState.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';


final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {


  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(mainInterceptor);

    //Fetch count data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(MainScreenGlobalStateProvider.notifier).backgroundRefreshForAPI(context);
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(mainInterceptor);
    super.dispose();
  }

  bool mainInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (kDebugMode) {
      print("Back button intercepted!");
    }
    var state = ref.watch(MainScreenGlobalStateProvider);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);

    PreferencesManager.getInstance().then((prefs) {
      if (prefs.getBooleanValue(PreferenceKeys.isDialogOpened) == true) {
        return false;
      }
      if (mainScaffoldKey.currentState?.isDrawerOpen ?? false == true) {
        mainScaffoldKey.currentState?.closeDrawer();
        return false;
      } else if (prefs.getBooleanValue(PreferenceKeys.isLoadingBarStarted) ==
          true) {
        return false;
      } else {
        userScreenNotifier.callBackNavigation(context, state.currentModule);
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(MainScreenGlobalStateProvider);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          key: mainScaffoldKey,
          backgroundColor: objConstantColor.white,
          drawer: SideMenu(
            onMenuClick: (module) {
              // HANDLE MENU SELECTION
              var notifier = ref.read(MainScreenGlobalStateProvider.notifier);
              notifier.callNavigation(module);

              // Close drawer after selection
              mainScaffoldKey.currentState?.closeDrawer();
            },
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E0033), // Dark Violet Color(0xFF26323e),//
                  Color(0xFF0A0A0A), // Almost Black
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [

            NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll is UserScrollNotification) {
                if (scroll.direction == ScrollDirection.reverse) {
                  userScreenNotifier.hideFooter();
                } else if (scroll.direction == ScrollDirection.forward) {
                  userScreenNotifier.showFooter();
                }
              }
              return true;
            },
              child: userScreenNotifier.getChildContainer(),
            ),

                /// FOOTER
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: userScreenState.isFooterVisible ? 15.dp : -120.dp,
                  left: 35.dp,
                  right: 35.dp,
                  child: const _BlurFooterContainer(),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: userScreenState.isFooterVisible ? 15.dp : -120.dp,
                  left: 25.dp,
                  right: 25.dp,
                  child: UserFooterView(
                    currentModule: userScreenState.currentModule,
                    notificationCount: userScreenState.notificationCount,
                    selectedFooterIndex: (index) {
                      userScreenNotifier.setFooterSelection(index);
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


}



/// GLASS BLUR FOOTER CONTAINER (iPhone Style)
class _BlurFooterContainer extends StatelessWidget {
  const _BlurFooterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35.dp),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 65.dp,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10), // frosted glass effect
            borderRadius: BorderRadius.circular(35.dp),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class UserFooterView extends ConsumerStatefulWidget {
  final ScreenName currentModule;
  final int notificationCount;
  final Function(int) selectedFooterIndex;

  const UserFooterView({
    required this.currentModule,
    required this.selectedFooterIndex,
    this.notificationCount = 0,
    super.key,
  });

  @override
  UserFooterViewState createState() => UserFooterViewState();
}

class UserFooterViewState extends ConsumerState<UserFooterView> {
  final List<String> inactiveIcons = [
    objConstantAssest.homeIcon,
    objConstantAssest.notificationIcon,
    objConstantAssest.incomeIcon,
    objConstantAssest.profileIcon,
  ];

  final List<String> activeIcons = [
    objConstantAssest.homeSelectedIcon,
    objConstantAssest.notificationSelectedIcon,
    objConstantAssest.incomeSelectedIcon,
    objConstantAssest.profileSelectedIcon,
  ];

  final List<String> moduleTitle = ['Home', 'Notification', 'Revenue', 'Profile'];

  int get currentIndex {
    if (widget.currentModule == ScreenName.home) return 0;
    if (widget.currentModule == ScreenName.notification) return 1;
    if (widget.currentModule == ScreenName.revenue) return 2;
    if (widget.currentModule == ScreenName.profile) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {

    return IgnorePointer(
      ignoring: false,
      child: SizedBox(
        height: 65.dp,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.dp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(inactiveIcons.length, (index) {
                  final isSelected = currentIndex == index;

                  return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          children: [
                            CupertinoButton(
                              onPressed: () => widget.selectedFooterIndex(index),
                              padding: EdgeInsets.zero,
                              child: Image.asset(
                                isSelected ? activeIcons[index] : inactiveIcons[index],
                                width: 20.dp,
                                color: isSelected ? Colors.white : Colors.white70,
                                colorBlendMode: BlendMode.srcIn,
                              ),
                            ),
                            objCommonWidgets.customText(
                              context,
                              moduleTitle[index],
                              10,
                              isSelected ? Colors.white : Colors.white70,
                              isSelected ? objConstantFonts.montserratSemiBold : objConstantFonts.montserratMedium,
                            ),
                          ],
                        ),

                        //Badge for Cart
                        if (index == 1 && widget.notificationCount <= 0)
                          Positioned(
                            left: 33.dp,
                            top: 1.dp,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.dp, horizontal: 5.dp),
                              decoration: BoxDecoration(
                                color: objConstantColor.redd,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '1235',
                                style: TextStyle(
                                  fontSize: 10.dp,
                                  color: Colors.white,
                                  fontFamily: objConstantFonts.montserratBold,
                                ),
                              ),
                            ),
                          ),
                      ]
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
