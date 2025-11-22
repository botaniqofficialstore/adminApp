
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Constants/Constants.dart';

class AdvertisementScreenState {
  final ScreenName currentModule;

  AdvertisementScreenState({
    this.currentModule = ScreenName.home,
  });

  AdvertisementScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return AdvertisementScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class AdvertisementScreenStateNotifier
    extends StateNotifier<AdvertisementScreenState> {
  AdvertisementScreenStateNotifier() : super(AdvertisementScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final AdvertisementScreenStateProvider = StateNotifierProvider.autoDispose<
    AdvertisementScreenStateNotifier, AdvertisementScreenState>((ref) {
  var notifier = AdvertisementScreenStateNotifier();
  return notifier;
});
