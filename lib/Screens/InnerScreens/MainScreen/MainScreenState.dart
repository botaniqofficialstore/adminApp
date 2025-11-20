import 'package:botaniq_admin/Screens/InnerScreens/ContainerScreen/DashboardScreen/DashboardScreen.dart';
import 'package:botaniq_admin/Screens/InnerScreens/ContainerScreen/NotificationScreen/NotificationScreen.dart';
import 'package:botaniq_admin/Screens/InnerScreens/ContainerScreen/ProfileScreen/ProfileScreen.dart';
import 'package:botaniq_admin/Screens/InnerScreens/ContainerScreen/RevenueScreen/RevenueScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../CodeReusable/CodeReusability.dart';
import '../../../Constants/ConstantVariables.dart';
import '../../../Constants/Constants.dart';

class MainScreenGlobalState {
  final ScreenName currentModule;
  final int notificationCount;
  final bool isFooterVisible;

  MainScreenGlobalState({
    this.currentModule = ScreenName.home,
    this.notificationCount = 0,
    this.isFooterVisible = true,
  });

  MainScreenGlobalState copyWith({
    ScreenName? currentModule,
    int? notificationCount,
    bool? isFooterVisible,
  }) {
    return MainScreenGlobalState(
      currentModule: currentModule ?? this.currentModule,
      notificationCount: notificationCount ?? this.notificationCount,
      isFooterVisible: isFooterVisible ?? this.isFooterVisible,
    );
  }
}

class MainScreenGlobalStateNotifier
    extends StateNotifier<MainScreenGlobalState> {
  MainScreenGlobalStateNotifier() : super(MainScreenGlobalState());

  @override
  void dispose() {
    super.dispose();
  }

  ///MARK: - METHODS
  ///This method used to clear state
  void clearStates() {
    state = MainScreenGlobalState();
  }

  ///This method is used to show footer
  void showFooter() {
    state = state.copyWith(isFooterVisible: true);
  }

  ///This method is used to hide footer
  void hideFooter() {
    state = state.copyWith(isFooterVisible: false);
  }

  /// This method used to get widget container
  Widget getChildContainer() {
    if (state.currentModule == ScreenName.notification) {
      return const NotificationScreen();
    } else if (state.currentModule == ScreenName.revenue) {
      return const RevenueScreen();
    } else if (state.currentModule == ScreenName.profile) {
      return const ProfileScreen();
    } else {
      return const DashboardScreen();
    }
  }

  ///This method used to handle footer selection
  void setFooterSelection(int index) {
    ScreenName selectedModule;
    if (index == 1) {
      selectedModule = ScreenName.notification;
    } else if (index == 2) {
      selectedModule = ScreenName.revenue;
    } else if (index == 3) {
      selectedModule = ScreenName.profile;
    } else {
      selectedModule = ScreenName.home;
    }
    state = state.copyWith(currentModule: selectedModule);
  }

  /// This Method to used to change screenName
  void callNavigation(ScreenName selectedScreen) {
    state = state.copyWith(currentModule: selectedScreen);
  }


  ///This method used to handle back navigation
  Future<void> callBackNavigation(
      BuildContext context, ScreenName module) async {
    if (!context.mounted) return;
    ScreenName onScreen = state.currentModule;

    if (module == ScreenName.profile ||
        module == ScreenName.notification ||
        module == ScreenName.revenue ) {
      onScreen = ScreenName.home;
    }

    state = state.copyWith(currentModule: onScreen);
  }

  void handleMenuSelection(BuildContext context, ScreenNames module) {

  }


  ///This method is used to GET Api for refresh token api response as success
  void backgroundRefreshForAPI(data) {
    CodeReusability().isConnectedToNetwork().then((isConnected) async {
      if (isConnected) {


      }
    });
  }



}

final MainScreenGlobalStateProvider = StateNotifierProvider.autoDispose<
    MainScreenGlobalStateNotifier, MainScreenGlobalState>((ref) {
  var notifier = MainScreenGlobalStateNotifier();
  return notifier;
});
