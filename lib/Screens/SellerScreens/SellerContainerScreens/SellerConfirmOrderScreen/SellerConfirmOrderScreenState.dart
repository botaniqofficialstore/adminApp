
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerConfirmOrderScreenState {
  final TextEditingController searchController;

  SellerConfirmOrderScreenState({
    required this.searchController,
  });

  SellerConfirmOrderScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return SellerConfirmOrderScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class SellerConfirmOrderScreenStateNotifier
    extends StateNotifier<SellerConfirmOrderScreenState> {
  SellerConfirmOrderScreenStateNotifier() : super(SellerConfirmOrderScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final sellerConfirmOrderScreenStateProvider = StateNotifierProvider.autoDispose<
    SellerConfirmOrderScreenStateNotifier, SellerConfirmOrderScreenState>((ref) {
  var notifier = SellerConfirmOrderScreenStateNotifier();
  return notifier;
});
