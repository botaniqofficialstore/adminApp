
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../Constants/Constants.dart';

class DeliveryPartnerScreenState {
  final ScreenName currentModule;
  final TextEditingController searchController;

  DeliveryPartnerScreenState({
    this.currentModule = ScreenName.home,
    required this.searchController,
  });

  DeliveryPartnerScreenState copyWith({
    ScreenName? currentModule,
    TextEditingController? searchController,
  }) {
    return DeliveryPartnerScreenState(
      currentModule: currentModule ?? this.currentModule,
      searchController: searchController ?? this.searchController,
    );
  }
}

class DeliveryPartnerScreenStateNotifier
    extends StateNotifier<DeliveryPartnerScreenState> {
  DeliveryPartnerScreenStateNotifier() : super(DeliveryPartnerScreenState(searchController: TextEditingController()));

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
