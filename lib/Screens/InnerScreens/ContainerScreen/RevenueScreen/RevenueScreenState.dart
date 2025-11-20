
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Constants/Constants.dart';


class RevenueScreenState {
  final ScreenName currentModule;

  RevenueScreenState({
    this.currentModule = ScreenName.home,
  });

  RevenueScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return RevenueScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class RevenueScreenStateNotifier
    extends StateNotifier<RevenueScreenState> {
  RevenueScreenStateNotifier() : super(RevenueScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final RevenueScreenStateProvider = StateNotifierProvider.autoDispose<
    RevenueScreenStateNotifier, RevenueScreenState>((ref) {
  var notifier = RevenueScreenStateNotifier();
  return notifier;
});
