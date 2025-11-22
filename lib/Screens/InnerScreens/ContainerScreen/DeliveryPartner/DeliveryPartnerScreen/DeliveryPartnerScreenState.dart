
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Constants/Constants.dart';

class DeliveryPartnerScreenState {
  final ScreenName currentModule;

  DeliveryPartnerScreenState({
    this.currentModule = ScreenName.home,
  });

  DeliveryPartnerScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return DeliveryPartnerScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class DeliveryPartnerScreenStateNotifier
    extends StateNotifier<DeliveryPartnerScreenState> {
  DeliveryPartnerScreenStateNotifier() : super(DeliveryPartnerScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final DeliveryPartnerScreenStateProvider = StateNotifierProvider.autoDispose<
    DeliveryPartnerScreenStateNotifier, DeliveryPartnerScreenState>((ref) {
  var notifier = DeliveryPartnerScreenStateNotifier();
  return notifier;
});
