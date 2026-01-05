import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';
import '../../MainScreen/MainScreenState.dart';

class DashboardScreenState {
  final String? currentDay;

  DashboardScreenState({
    this.currentDay,
  });

  DashboardScreenState copyWith({
    String? currentDay
  }) {
    return DashboardScreenState(
    currentDay: currentDay ?? this.currentDay
    );
  }
}

class DashboardScreenStateNotifier
    extends StateNotifier<DashboardScreenState> {
  DashboardScreenStateNotifier() : super(DashboardScreenState());


  ///This method is used to get current day
  void updateCurrentDay(){
    final today = CodeReusability.getCurrentDayAndDate();
    state = state.copyWith(currentDay: today);
  }

  ///This method is used to handle screen navigation for sub modules in dashboard
  void callSubModuleScreenNavigation(int selectedIndex, MainScreenGlobalStateNotifier userScreenNotifier){
    if (selectedIndex == 0){
      userScreenNotifier.callNavigation(ScreenName.newOrder);
    } else if (selectedIndex == 1){
      userScreenNotifier.callNavigation(ScreenName.confirmOrder);
    } else if (selectedIndex == 2){
      userScreenNotifier.callNavigation(ScreenName.packedOrder);
    } else if (selectedIndex == 3){
      userScreenNotifier.callNavigation(ScreenName.completedDelivery);
    } else if (selectedIndex == 4){
      userScreenNotifier.callNavigation(ScreenName.completedDelivery);
    } else if (selectedIndex == 5){
      userScreenNotifier.callNavigation(ScreenName.returnedOrder);
    } else {
      userScreenNotifier.callNavigation(ScreenName.cancelledOrder);
    }
  }

  ///This method is used to handle screen navigation for sub modules in dashboard
  void callSubCancelAndReturnsModuleScreenNavigation(int selectedIndex, MainScreenGlobalStateNotifier userScreenNotifier){
    if (selectedIndex == 0){
      userScreenNotifier.callNavigation(ScreenName.cancelledOrder);
    } else if (selectedIndex == 1){
      userScreenNotifier.callNavigation(ScreenName.returnedOrder);
    }
  }


}

final DashboardScreenStateProvider =
StateNotifierProvider.autoDispose<DashboardScreenStateNotifier,
    DashboardScreenState>((ref) {
  return DashboardScreenStateNotifier();
});