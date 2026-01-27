import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../../Utility/SideMenu.dart';
import 'SellerMainScreenState.dart';

final GlobalKey<ScaffoldState> mainSellerScaffoldKey =
GlobalKey<ScaffoldState>();

class SellerMainScreen extends ConsumerStatefulWidget {
  const SellerMainScreen({super.key});

  @override
  SellerMainScreenState createState() => SellerMainScreenState();
}

class SellerMainScreenState extends ConsumerState<SellerMainScreen> {

  @override
  void initState() {
    super.initState();

    // Fetch API data once UI is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(SellerMainScreenGlobalStateProvider.notifier)
          .backgroundRefreshForAPI(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userScreenState =
    ref.watch(SellerMainScreenGlobalStateProvider);
    final userScreenNotifier =
    ref.watch(SellerMainScreenGlobalStateProvider.notifier);

    return PopScope(
      canPop: false, // 🔥 We fully control back navigation
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
        _handleBack(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // optional
          statusBarIconBrightness: Brightness.dark, // ANDROID → black icons
          statusBarBrightness: Brightness.light, // iOS → black icons
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              key: mainSellerScaffoldKey,
              extendBody: true,
              backgroundColor: const Color(0xFFF4F4F4),
        
              /// SIDE MENU
              drawer: SideMenu(
                onMenuClick: (module) {
                  final notifier = ref.read(
                      SellerMainScreenGlobalStateProvider.notifier);
        
                  if (module == ScreenName.logout) {
                    notifier.callLogoutNavigation(context);
                  } else {
                    notifier.callNavigation(module);
                  }
        
                  mainSellerScaffoldKey.currentState?.closeDrawer();
                },
              ),
        
              /// BODY (Animated Screen Swap)
              body: KeyedSubtree(
                key: ValueKey(userScreenState.currentModule),
                child: userScreenNotifier.getChildContainer(),
              ),
        
              /// FOOTER
              bottomNavigationBar: userScreenNotifier.isHideFooter() ? SizedBox.shrink() : UserFooterView(
                currentModule: userScreenState.currentModule,
                notificationCount: userScreenState.notificationCount,
                selectedFooterIndex: (index) {
                  userScreenNotifier.setFooterSelection(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 SAFE BACK HANDLER
  Future<void> _handleBack(BuildContext context) async {
    if (!context.mounted) return;

    final notifier =
    ref.read(SellerMainScreenGlobalStateProvider.notifier);
    final state =
    ref.read(SellerMainScreenGlobalStateProvider);

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
    if (mainSellerScaffoldKey.currentState?.isDrawerOpen ?? false) {
      mainSellerScaffoldKey.currentState?.closeDrawer();
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
        child: SafeArea(
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
                        CupertinoButton(
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
                              child: objCommonWidgets.customText(
                                context,
                                '1235',
                                10, Colors.white,
                                objConstantFonts.montserratBold,
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
