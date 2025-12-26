import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/ReturnRequest/ReturnRequestScreen.dart';
import 'package:botaniq_admin/Screens/Authentication/LoginScreen/LoginScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerDashboardScreen/SellerDashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../../../Utility/PushNotificationService/NotificationService.dart';
import '../../AdminScreens/InnerScreens/ContainerScreen/DashboardScreen/DashboardScreen.dart';
import '../../AdminScreens/InnerScreens/ContainerScreen/NotificationScreen/NotificationScreen.dart';


class SellerMainScreenGlobalState {
  final ScreenName currentModule;
  final int notificationCount;
  final bool isFooterVisible;

  SellerMainScreenGlobalState({
    this.currentModule = ScreenName.home,
    this.notificationCount = 0,
    this.isFooterVisible = true,
  });

  SellerMainScreenGlobalState copyWith({
    ScreenName? currentModule,
    int? notificationCount,
    bool? isFooterVisible,
  }) {
    return SellerMainScreenGlobalState(
      currentModule: currentModule ?? this.currentModule,
      notificationCount: notificationCount ?? this.notificationCount,
      isFooterVisible: isFooterVisible ?? this.isFooterVisible,
    );
  }
}

class SellerMainScreenGlobalStateNotifier
    extends StateNotifier<SellerMainScreenGlobalState> {
  SellerMainScreenGlobalStateNotifier() : super(SellerMainScreenGlobalState());

  @override
  void dispose() {
    super.dispose();
  }

  ///MARK: - METHODS
  ///This method used to clear state
  void clearStates() {
    state = SellerMainScreenGlobalState();
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
    } else {
      return const SellerDashboardScreen();
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

  /// This Method to used to change screenName
  void callHomeNavigation() {
    state = state.copyWith(currentModule: ScreenName.home);
  }

  /// This Method to used for logout
  void callLogoutNavigation(BuildContext context) {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isUserLogged, false);
      //Call Navigation
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }


  ///This method used to handle back navigation
  Future<void> callBackNavigation(
      BuildContext context, ScreenName module) async {
    if (!context.mounted) return;
    ScreenName onScreen = state.currentModule;

    if (module == ScreenName.profile ||
        module == ScreenName.notification ||
        module == ScreenName.revenue ||
        module == ScreenName.advertisement ||
        module == ScreenName.changePassword ||
        module == ScreenName.products ||
        module == ScreenName.contracts ||
        module == ScreenName.reels ||
        module == ScreenName.deliveryPartner ||
        module == ScreenName.delivery ||
        module == ScreenName.newOrder ||
        module == ScreenName.confirmOrder ||
        module == ScreenName.packedOrder ||
        module == ScreenName.shceduledDelivery ||
        module == ScreenName.completedDelivery ||
        module == ScreenName.cancelledOrder ||
        module == ScreenName.returnedOrder) {
      onScreen = ScreenName.home;
    } else if (module == ScreenName.addContract){
      onScreen = ScreenName.contracts;
    } else if (module == ScreenName.addDeliveryPartner){
      onScreen = ScreenName.deliveryPartner;
    } else if (module == ScreenName.addReel){
      onScreen = ScreenName.reels;
    } else if (module == ScreenName.addProduct){
      onScreen = ScreenName.products;
    }

    state = state.copyWith(currentModule: onScreen);
  }

  void closeCommonPopup(BuildContext context){
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }

  void closeBottomSheet(BuildContext context){
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }



  ///This method is used to GET Api for refresh token api response as success
  void backgroundRefreshForAPI(data) {
    CodeReusability().isConnectedToNetwork().then((isConnected) async {
      if (isConnected) {


      }
    });
  }



}

final SellerMainScreenGlobalStateProvider = StateNotifierProvider.autoDispose<
    SellerMainScreenGlobalStateNotifier, SellerMainScreenGlobalState>((ref) {
  var notifier = SellerMainScreenGlobalStateNotifier();
  return notifier;
});
