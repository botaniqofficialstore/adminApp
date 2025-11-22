
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Constants/Constants.dart';

class ReelsScreenState {
  final ScreenName currentModule;

  ReelsScreenState({
    this.currentModule = ScreenName.home,
  });

  ReelsScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return ReelsScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class ReelsScreenStateNotifier
    extends StateNotifier<ReelsScreenState> {
  ReelsScreenStateNotifier() : super(ReelsScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final ReelsScreenStateProvider = StateNotifierProvider.autoDispose<
    ReelsScreenStateNotifier, ReelsScreenState>((ref) {
  var notifier = ReelsScreenStateNotifier();
  return notifier;
});
