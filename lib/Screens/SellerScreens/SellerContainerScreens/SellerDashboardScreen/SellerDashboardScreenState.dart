import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';

class SellerDashboardScreenState {
  final String? currentDay;

  SellerDashboardScreenState({
    this.currentDay,
  });

  SellerDashboardScreenState copyWith({
    String? currentDay
  }) {
    return SellerDashboardScreenState(
        currentDay: currentDay ?? this.currentDay
    );
  }
}

class SellerDashboardScreenStateNotifier
    extends StateNotifier<SellerDashboardScreenState> {
  SellerDashboardScreenStateNotifier() : super(SellerDashboardScreenState());


  ///This method is used to get current day
  void updateCurrentDay(){
    final today = CodeReusability.getCurrentDayAndDate();
    state = state.copyWith(currentDay: today);
  }

  ///This method is used to handle screen navigation for sub modules in dashboard
  void callSubModuleScreenNavigation(int selectedIndex, SellerMainScreenGlobalStateNotifier userScreenNotifier){
    if (selectedIndex == 0){
      userScreenNotifier.callNavigation(ScreenName.newOrder);
    } else if (selectedIndex == 1){
      userScreenNotifier.callNavigation(ScreenName.confirmOrder);
    } else if (selectedIndex == 2){
      userScreenNotifier.callNavigation(ScreenName.packedOrder);
    } else if (selectedIndex == 3){
      userScreenNotifier.callNavigation(ScreenName.completedDelivery);
    }
  }

  ///This method is used to handle screen navigation for sub modules in dashboard
  void callSubCancelAndReturnsModuleScreenNavigation(int selectedIndex, SellerMainScreenGlobalStateNotifier userScreenNotifier){
    if (selectedIndex == 0){
      userScreenNotifier.callNavigation(ScreenName.cancelledOrder);
    } else if (selectedIndex == 1){
      userScreenNotifier.callNavigation(ScreenName.returnedOrder);
    }
  }


}

final SellerDashboardScreenStateProvider =
StateNotifierProvider.autoDispose<SellerDashboardScreenStateNotifier,
    SellerDashboardScreenState>((ref) {
  return SellerDashboardScreenStateNotifier();
});