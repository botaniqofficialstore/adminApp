
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewOrderScreenState {
  final TextEditingController searchController;

  NewOrderScreenState({
    required this.searchController,
  });

  NewOrderScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return NewOrderScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class NewOrderScreenStateNotifier
    extends StateNotifier<NewOrderScreenState> {
  NewOrderScreenStateNotifier() : super(NewOrderScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final NewOrderScreenStateProvider = StateNotifierProvider.autoDispose<
    NewOrderScreenStateNotifier, NewOrderScreenState>((ref) {
  var notifier = NewOrderScreenStateNotifier();
  return notifier;
});
