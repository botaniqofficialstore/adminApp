import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PreferencesManager.dart';
import 'package:flutter/cupertino.dart';
import '../../../Utility/SideMenu.dart';
import 'SellerMainScreenState.dart';

final GlobalKey<ScaffoldState> mainSellerScaffoldKey = GlobalKey<ScaffoldState>();
class SellerMainScreen extends ConsumerStatefulWidget {
  const SellerMainScreen({super.key});

  @override
  SellerMainScreenState createState() => SellerMainScreenState();
}

class SellerMainScreenState extends ConsumerState<SellerMainScreen> {


  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(mainInterceptor);

    //Fetch count data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(SellerMainScreenGlobalStateProvider.notifier)
          .backgroundRefreshForAPI(context);
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(mainInterceptor);
    super.dispose();
  }

  bool mainInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (kDebugMode) {
      debugPrint("Back button intercepted!");
    }

    final state = ref.read(SellerMainScreenGlobalStateProvider);
    final notifier = ref.read(SellerMainScreenGlobalStateProvider.notifier);

    PreferencesManager.getInstance().then((prefs) {
      if (prefs.getBooleanValue(PreferenceKeys.isDialogOpened) == true) {
        Logger().log('Called isDialogOpened -------------->');
        return;
      }

      /// 1️⃣ Close COMMON POPUP first
      if (prefs.getBooleanValue(PreferenceKeys.isCommonPopup) == true) {
        Logger().log('Called isCommonPopup -------------->');
        notifier.closeCommonPopup(context);
        prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);
        return;
      }

      /// 2️⃣ Close BOTTOM SHEET next
      if (prefs.getBooleanValue(PreferenceKeys.isBottomSheet) == true) {
        Logger().log('Called isBottomSheet -------------->');
        notifier.closeBottomSheet(context);
        prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
        return;
      }

      /// 3️⃣ Close Drawer
      if (mainSellerScaffoldKey.currentState?.isDrawerOpen ?? false) {
        mainSellerScaffoldKey.currentState?.closeDrawer();
        return;
      }

      /// 4️⃣ Prevent back when loading
      if (prefs.getBooleanValue(PreferenceKeys.isLoadingBarStarted) == true) {
        return;
      }

      /// 5️⃣ Default back navigation
      notifier.callBackNavigation(context, state.currentModule);
    });

    /// IMPORTANT: Always return TRUE to intercept system back
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var userScreenState = ref.watch(SellerMainScreenGlobalStateProvider);
    var userScreenNotifier =
    ref.watch(SellerMainScreenGlobalStateProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
            extendBody: true,
            key: mainSellerScaffoldKey,
            backgroundColor: const Color(0xFFF4F4F4),
            drawer: SideMenu(
              onMenuClick: (module) {
                var notifier = ref.read(
                    SellerMainScreenGlobalStateProvider.notifier);

                if (module == ScreenName.logout) {
                  notifier.callLogoutNavigation(context);
                } else {
                  notifier.callNavigation(module);
                }

                mainSellerScaffoldKey.currentState?.closeDrawer();
              },
            ),

            /// ✅ ANIMATED SCREEN SWAP
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final isForward =
                    userScreenState.navigationDirection ==
                        NavigationDirection.forward;

                return SlideTransition(
                  position: Tween<Offset>(
                    begin: isForward
                        ? const Offset(0.2, 0)
                        : const Offset(-0.2, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(userScreenState.currentModule),
                child: userScreenNotifier.getChildContainer(),
              ),
            ),

            /// FOOTER (UNCHANGED)
            bottomNavigationBar: UserFooterView(
              currentModule: userScreenState.currentModule,
              notificationCount: userScreenState.notificationCount,
              selectedFooterIndex: (index) {
                userScreenNotifier.setFooterSelection(index);
              },
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

    return Container(
      decoration: BoxDecoration(
        color: objConstantColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 15.dp, left: 10.dp, right: 10.dp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(inactiveIcons.length, (index) {
                final isSelected = currentIndex == index;

                return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.dp),
                        child: CupertinoButton(
                          onPressed: () => widget.selectedFooterIndex(index),
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          child: Column(
                            children: [
                              Image.asset(
                                isSelected ? activeIcons[index] : inactiveIcons[index],
                                width: 20.dp,
                                color: objConstantColor.black.withAlpha(isSelected ? 250 : 150),
                                colorBlendMode: BlendMode.srcIn,
                              ),
                              SizedBox(height: 3.5.dp),
                              objCommonWidgets.customText(
                                context,
                                moduleTitle[index],
                                10, objConstantColor.black.withAlpha(isSelected ? 250 : 150) ,
                                isSelected ? objConstantFonts.montserratSemiBold : objConstantFonts.montserratMedium,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Badge for Cart
                      if (index == 1 && widget.notificationCount <= 0)
                        Positioned(
                          left: 33.dp,
                          top: -10.dp,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.dp, horizontal: 6.dp),
                            decoration: BoxDecoration(
                              color: objConstantColor.redd,
                              borderRadius: BorderRadius.circular(15),
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
    );
  }
}
