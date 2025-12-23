import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';
import '../../MainScreen/MainScreenState.dart';

class DashboardScreenState {
  final ScreenName currentModule;

  DashboardScreenState({
    this.currentModule = ScreenName.home,
  });

  DashboardScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return DashboardScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class DashboardScreenStateNotifier
    extends StateNotifier<DashboardScreenState> {
  DashboardScreenStateNotifier() : super(DashboardScreenState());

  ///This method is used to handle screen navigation for sub modules in dashboard
  void callSubModuleScreenNavigation(int selectedIndex, MainScreenGlobalStateNotifier userScreenNotifier){
    if (selectedIndex == 0){
      userScreenNotifier.callNavigation(ScreenName.newOrder);
    } else if (selectedIndex == 1){
      userScreenNotifier.callNavigation(ScreenName.confirmOrder);
    } else if (selectedIndex == 2){
      userScreenNotifier.callNavigation(ScreenName.packedOrder);
    } else if (selectedIndex == 3){
      userScreenNotifier.callNavigation(ScreenName.shceduledDelivery);
    } else if (selectedIndex == 4){
      userScreenNotifier.callNavigation(ScreenName.completedDelivery);
    } else if (selectedIndex == 5){
      userScreenNotifier.callNavigation(ScreenName.returnedOrder);
    } else {
      userScreenNotifier.callNavigation(ScreenName.cancelledOrder);
    }
  }


}

final DashboardScreenStateProvider =
StateNotifierProvider.autoDispose<DashboardScreenStateNotifier,
    DashboardScreenState>((ref) {
  return DashboardScreenStateNotifier();
});