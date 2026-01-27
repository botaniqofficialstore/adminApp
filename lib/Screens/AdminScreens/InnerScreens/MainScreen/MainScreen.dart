import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../../../Utility/SideMenu.dart';
import 'MainScreenState.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(MainScreenGlobalStateProvider.notifier)
          .backgroundRefreshForAPI(context);
    });
  }

  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final userScreenState = ref.watch(MainScreenGlobalStateProvider);
    final userScreenNotifier =
    ref.watch(MainScreenGlobalStateProvider.notifier);

    return PopScope(
      canPop: false, // 🔥 We fully control back navigation
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
        _handleBack(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // ANDROID → WHITE ICONS
          statusBarBrightness: Brightness.dark, // iOS → WHITE ICONS
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: mainScaffoldKey,
              backgroundColor: objConstantColor.white,
              extendBodyBehindAppBar: true,
              drawer: SideMenu(
                onMenuClick: (module) {
                  final notifier =
                  ref.read(MainScreenGlobalStateProvider.notifier);

                  if (module == ScreenName.logout) {
                    notifier.callLogoutNavigation(context);
                  } else {
                    notifier.callNavigation(module);
                  }

                  mainScaffoldKey.currentState?.closeDrawer();
                },
              ),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E0033),
                      Color(0xFF0A0A0A),
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
                          } else if (scroll.direction ==
                              ScrollDirection.forward) {
                            userScreenNotifier.showFooter();
                          }
                        }
                        return true;
                      },
                      child: userScreenNotifier.getChildContainer(),
                    ),

                    /// BLUR FOOTER BACKGROUND
                    if (_showFooter(userScreenState.currentModule))
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        bottom: userScreenState.isFooterVisible
                            ? 15.dp
                            : -120.dp,
                        left: 35.dp,
                        right: 35.dp,
                        child: const _BlurFooterContainer(),
                      ),

                    /// FOOTER CONTENT
                    if (_showFooter(userScreenState.currentModule))
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        bottom: userScreenState.isFooterVisible
                            ? 15.dp
                            : -120.dp,
                        left: 25.dp,
                        right: 25.dp,
                        child: UserFooterView(
                          currentModule: userScreenState.currentModule,
                          notificationCount:
                          userScreenState.notificationCount,
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
        ),
      ),
    );
  }

  bool _showFooter(ScreenName module) {
    return module == ScreenName.home ||
        module == ScreenName.notification ||
        module == ScreenName.revenue ||
        module == ScreenName.profile;
  }


  /// 🔥 SAFE BACK HANDLER
  Future<void> _handleBack(BuildContext context) async {
    if (!context.mounted) return;

    final state = ref.read(MainScreenGlobalStateProvider);
    final notifier = ref.read(MainScreenGlobalStateProvider.notifier);

    final prefs = await PreferencesManager.getInstance();

    /// 1️⃣ Dialog open → block back
    if (prefs.getBooleanValue(PreferenceKeys.isDialogOpened) == true) {
      return;
    }

    /// 2️⃣ Common popup
    if (prefs.getBooleanValue(PreferenceKeys.isCommonPopup) == true) {
      notifier.closeCommonPopup(context);
      prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);
      return;
    }

    /// 3️⃣ Bottom sheet
    if (prefs.getBooleanValue(PreferenceKeys.isBottomSheet) == true) {
      notifier.closeBottomSheet(context);
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      return;
    }

    /// 4️⃣ Drawer
    if (mainScaffoldKey.currentState?.isDrawerOpen ?? false) {
      mainScaffoldKey.currentState?.closeDrawer();
      return;
    }

    /// 5️⃣ Loading state → block back

    if (prefs.getBooleanValue(
        PreferenceKeys.isLoadingBarStarted) ==
        true) {
      return;
    }

    /// 6️⃣ Custom back navigation
    notifier.callBackNavigation(
      context,
      state.currentModule,
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
