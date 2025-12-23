
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryScreenState {
  final TextEditingController searchController;

  DeliveryScreenState({
    required this.searchController,
  });

  DeliveryScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return DeliveryScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class DeliveryScreenStateNotifier
    extends StateNotifier<DeliveryScreenState> {
  DeliveryScreenStateNotifier() : super(DeliveryScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final DeliveryScreenStateProvider = StateNotifierProvider.autoDispose<
    DeliveryScreenStateNotifier, DeliveryScreenState>((ref) {
  var notifier = DeliveryScreenStateNotifier();
  return notifier;
});
