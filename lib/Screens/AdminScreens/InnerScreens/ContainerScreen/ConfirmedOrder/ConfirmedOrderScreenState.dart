
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmedOrderScreenState {
  final TextEditingController searchController;

  ConfirmedOrderScreenState({
    required this.searchController,
  });

  ConfirmedOrderScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return ConfirmedOrderScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class ConfirmedOrderScreenStateNotifier
    extends StateNotifier<ConfirmedOrderScreenState> {
  ConfirmedOrderScreenStateNotifier() : super(ConfirmedOrderScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final ConfirmedOrderScreenStateProvider = StateNotifierProvider.autoDispose<
    ConfirmedOrderScreenStateNotifier, ConfirmedOrderScreenState>((ref) {
  var notifier = ConfirmedOrderScreenStateNotifier();
  return notifier;
});
