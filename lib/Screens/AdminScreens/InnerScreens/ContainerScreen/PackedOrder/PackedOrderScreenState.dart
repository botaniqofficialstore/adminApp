
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackedOrderScreenState {
  final TextEditingController searchController;

  PackedOrderScreenState({
    required this.searchController,
  });

  PackedOrderScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return PackedOrderScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class PackedOrderScreenStateNotifier
    extends StateNotifier<PackedOrderScreenState> {
  PackedOrderScreenStateNotifier() : super(PackedOrderScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final PackedOrderScreenStateProvider = StateNotifierProvider.autoDispose<
    PackedOrderScreenStateNotifier, PackedOrderScreenState>((ref) {
  var notifier = PackedOrderScreenStateNotifier();
  return notifier;
});
