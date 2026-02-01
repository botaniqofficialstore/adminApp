import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/ChangePasswordScreen/ChangePasswordScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/RevenueScreen/RevenueScreen.dart';
import 'package:botaniq_admin/Screens/Authentication/LoginScreen/LoginScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/ConfirmPackedOrderScreen/ConfirmPackedOrderScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerAccountScreen/SellerAccountScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerBusinessHourScreen/SellerBusinessHourScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerCancelledOrderScreen/SellerCancelledOrderScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerCompletedDeliveryScreen/SellerCompletedDeliveryScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerConfirmOrderScreen/SellerConfirmOrderScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerDashboardScreen/SellerDashboardScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerLegalScreen/SellerLegalScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerNewOrderScreen/SellerNewOrderScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerPackedOrderScreen/SellerPackedOrderScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerProductAddScreen/SellerProductAddScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerProductDetailsScreen/SellerProductDetailsScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerProductFeebackScreen/SellerProductFeedbackScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerProductsScreen/SellerProductsScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerProfileScreen/SellerProfileScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerRatingScreen/SellerRatingScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerReturnOrderHistoryScreen/SellerReturnOrderHistoryScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerReturnedOrderScreen/SellerReturnedOrderScreen.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerSettingsScreen/SellerSettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../../../Utility/PushNotificationService/NotificationService.dart';
import '../../../Utility/ConfirmClosePopup.dart';
import '../../CommonScreens/NotificationScreen/NotificationScreen.dart';


enum NavigationDirection { forward, backward }

class SellerMainScreenGlobalState {
  final ScreenName currentModule;
  final int notificationCount;

  SellerMainScreenGlobalState({
    this.currentModule = ScreenName.home,
    this.notificationCount = 0,
  });

  SellerMainScreenGlobalState copyWith({
    ScreenName? currentModule,
    int? notificationCount,
  }) {
    return SellerMainScreenGlobalState(
      currentModule: currentModule ?? this.currentModule,
      notificationCount: notificationCount ?? this.notificationCount,
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


  /// This method used to get widget container
  Widget getChildContainer() {
    if (state.currentModule == ScreenName.notification) {
      return const NotificationScreen();
    } else if (state.currentModule == ScreenName.newOrder) {
      return const SellerNewOrderScreen();
    } else if (state.currentModule == ScreenName.confirmOrder) {
      return const SellerConfirmOrderScreen();
    } else if (state.currentModule == ScreenName.confirmPacked) {
      return const ConfirmPackedOrderScreen();
    } else if (state.currentModule == ScreenName.packedOrder) {
      return const SellerPackedOrderScreen();
    } else if (state.currentModule == ScreenName.completedDelivery) {
      return const SellerCompletedDeliveryScreen();
    } else if (state.currentModule == ScreenName.changePassword) {
      return const ChangePasswordScreen();
    } else if (state.currentModule == ScreenName.cancelledOrder) {
      return const SellerCancelledOrderScreen();
    } else if (state.currentModule == ScreenName.returnedOrder) {
      return const SellerReturnedOrderScreen();
    } else if (state.currentModule == ScreenName.returnedOrderHistory) {
      return const SellerReturnOrderHistoryScreen();
    } else if (state.currentModule == ScreenName.revenue) {
      return const RevenueScreen();
    } else if (state.currentModule == ScreenName.profile) {
      return const SellerProfileScreen();
    } else if (state.currentModule == ScreenName.settings) {
      return const SellerSettingsScreen();
    } else if (state.currentModule == ScreenName.legal) {
      return const SellerLegalScreen();
    } else if (state.currentModule == ScreenName.rating) {
      return const SellerRatingScreen();
    } else if (state.currentModule == ScreenName.productReview) {
      return const SellerProductFeedbackScreen();
    } else if (state.currentModule == ScreenName.businessHours) {
      return const SellerBusinessHourScreen();
    } else if (state.currentModule == ScreenName.products) {
      return const SellerProductsScreen();
    } else if (state.currentModule == ScreenName.productDetails) {
      return const SellerProductDetailsScreen();
    } else if (state.currentModule == ScreenName.addProduct) {
      return const SellerProductAddScreen();
    } else if (state.currentModule == ScreenName.account) {
      return const SellerAccountScreen();
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

    state = state.copyWith(
      currentModule: selectedModule,
    );
  }

  /// This Method to used to change screenName
  void callNavigation(ScreenName selectedScreen) {
    state = state.copyWith(
      currentModule: selectedScreen,
    );
  }

  /// This Method to used to change screenName
  void callHomeNavigation() {
    state = state.copyWith(currentModule: ScreenName.home);
  }

  void callOrderHistoryNavigation() {
    state = state.copyWith(currentModule: ScreenName.returnedOrderHistory);
  }

  void callReturnOrderScreenNavigation() {
    state = state.copyWith(currentModule: ScreenName.returnedOrder);
  }

  bool isHideFooter(){
    return state.currentModule == ScreenName.addProduct;
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
      final bool shouldPop = await ConfirmClosePopup.show(context, title: "You're in the middle of adding a new organic product. If you go back now, the details you've entered won’t be saved.",
          description: "Would you like to continue adding the product or exit for now?") ?? false;

      if (shouldPop && context.mounted) {
        onScreen = ScreenName.products;
      }
    } else if (state.currentModule == ScreenName.confirmPacked) {
      onScreen = ScreenName.confirmOrder;
    } else if (state.currentModule == ScreenName.settings ||
        state.currentModule == ScreenName.legal ||
        state.currentModule == ScreenName.rating ||
        state.currentModule == ScreenName.businessHours ||
        state.currentModule == ScreenName.products ||
        state.currentModule == ScreenName.account) {
      onScreen = ScreenName.profile;
    } else if (state.currentModule == ScreenName.productReview) {
      onScreen = ScreenName.rating;
    } else if (state.currentModule == ScreenName.returnedOrderHistory) {
      onScreen = ScreenName.returnedOrder;
    } else if (state.currentModule == ScreenName.productDetails){
      onScreen = ScreenName.products;
    }

    state = state.copyWith(
      currentModule: onScreen,
    );
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
