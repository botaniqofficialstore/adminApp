import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Constants/Constants.dart';

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


}

final DashboardScreenStateProvider =
StateNotifierProvider.autoDispose<DashboardScreenStateNotifier,
    DashboardScreenState>((ref) {
  return DashboardScreenStateNotifier();
});