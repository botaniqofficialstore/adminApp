
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReturnRequestScreenState {
  final TextEditingController searchController;

  ReturnRequestScreenState({
    required this.searchController,
  });

  ReturnRequestScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return ReturnRequestScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class ReturnRequestScreenStateNotifier
    extends StateNotifier<ReturnRequestScreenState> {
  ReturnRequestScreenStateNotifier() : super(ReturnRequestScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final ReturnRequestScreenStateProvider = StateNotifierProvider.autoDispose<
    ReturnRequestScreenStateNotifier, ReturnRequestScreenState>((ref) {
  var notifier = ReturnRequestScreenStateNotifier();
  return notifier;
});
