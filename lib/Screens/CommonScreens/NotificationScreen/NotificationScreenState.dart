
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';


class NotificationScreenState {
  final ScreenName currentModule;

  NotificationScreenState({
    this.currentModule = ScreenName.home,
  });

  NotificationScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return NotificationScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class NotificationScreenStateNotifier
    extends StateNotifier<NotificationScreenState> {
  NotificationScreenStateNotifier() : super(NotificationScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final NotificationScreenStateProvider = StateNotifierProvider.autoDispose<
    NotificationScreenStateNotifier, NotificationScreenState>((ref) {
  var notifier = NotificationScreenStateNotifier();
  return notifier;
});
