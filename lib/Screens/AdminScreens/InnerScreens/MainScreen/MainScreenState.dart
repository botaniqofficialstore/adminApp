import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/CancelledOrder/CancelledOrderScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/ChangePasswordScreen/ChangePasswordScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/CompletedOrder/CompletedDeliveryScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/ConfirmedOrder/ConfirmedOrderScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/Contract/AddContractScreen/AddContractScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/Contract/ContractScreen/ContractScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/DashboardScreen/DashboardScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/DeliveryPartner/AddDeliveryPartnerScreen/AddDeliveryPartnerScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/DeliveryPartner/DeliveryPartnerScreen/DeliveryPartnerScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/DeliveryScreen/DeliveryScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/NewOrder/NewOrderScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/NotificationScreen/NotificationScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/Products/AddProductScreen/AddProductScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/Products/ProductScreen/ProductScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/ProfileScreen/ProfileScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/Reels/AddReelScreen/AddReelScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/Reels/ReelsScreen/ReelsScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/RevenueScreen/RevenueScreen.dart';
import 'package:botaniq_admin/Screens/AdminScreens/InnerScreens/ContainerScreen/ScheduledDelivery/ScheduledDeliveryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../CodeReusable/CodeReusability.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PushNotificationService/NotificationService.dart';
import '../ContainerScreen/AdvertisementScreen/AdvertisementScreen.dart';
import '../ContainerScreen/PackedOrder/PackedOrderScreen.dart';

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
    } else if (state.currentModule == ScreenName.contracts) {
      return const ContractScreen();
    } else if (state.currentModule == ScreenName.reels) {
      return const ReelsScreen();
    } else if (state.currentModule == ScreenName.products) {
      return const ProductScreen();
    } else if (state.currentModule == ScreenName.deliveryPartner) {
      return const DeliveryPartnerScreen();
    } else if (state.currentModule == ScreenName.changePassword) {
      return const ChangePasswordScreen();
    } else if (state.currentModule == ScreenName.advertisement) {
      return const AdvertisementScreen();
    } else if (state.currentModule == ScreenName.addContract) {
      return const AddContractScreen();
    } else if (state.currentModule == ScreenName.addDeliveryPartner) {
      return const AddDeliveryPartnerScreen();
    } else if (state.currentModule == ScreenName.addReel) {
      return const AddReelScreen();
    } else if (state.currentModule == ScreenName.addProduct) {
      return const AddProductScreen();
    } else if (state.currentModule == ScreenName.delivery) {
      return const DeliveryScreen();
    } else if (state.currentModule == ScreenName.newOrder) {
      return const NewOrderScreen();
    } else if (state.currentModule == ScreenName.confirmOrder) {
      return const ConfirmedOrderScreen();
    } else if (state.currentModule == ScreenName.packedOrder) {
      return const PackedOrderScreen();
    } else if (state.currentModule == ScreenName.shceduledDelivery) {
      return const ScheduledDeliveryScreen();
    } else if (state.currentModule == ScreenName.completedDelivery) {
      return const CompletedDeliveryScreen();
    } else if (state.currentModule == ScreenName.cancelledOrder) {
      return const CancelledOrderScreen();
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

final MainScreenGlobalStateProvider = StateNotifierProvider.autoDispose<
    MainScreenGlobalStateNotifier, MainScreenGlobalState>((ref) {
  var notifier = MainScreenGlobalStateNotifier();
  return notifier;
});
