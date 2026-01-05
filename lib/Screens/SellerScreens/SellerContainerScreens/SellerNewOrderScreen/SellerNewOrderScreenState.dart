
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerNewOrderScreenState {
  final TextEditingController searchController;

  SellerNewOrderScreenState({
    required this.searchController,
  });

  SellerNewOrderScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return SellerNewOrderScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class SellerNewOrderScreenNotifier
    extends StateNotifier<SellerNewOrderScreenState> {
  SellerNewOrderScreenNotifier() : super(SellerNewOrderScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final SellerNewOrderScreenProvider = StateNotifierProvider.autoDispose<
    SellerNewOrderScreenNotifier, SellerNewOrderScreenState>((ref) {
  var notifier = SellerNewOrderScreenNotifier();
  return notifier;
});
