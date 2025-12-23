import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreenState {
  final TextEditingController searchController;
  final int selectedIndex;

  ProductScreenState({
    required this.searchController,
    required this.selectedIndex,
  });

  ProductScreenState copyWith({
    TextEditingController? searchController,
    int? selectedIndex,
  }) {
    return ProductScreenState(
      searchController: searchController ?? this.searchController,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}


class ProductScreenStateNotifier
    extends StateNotifier<ProductScreenState> {
  ProductScreenStateNotifier() : super(ProductScreenState(
      searchController: TextEditingController(),
    selectedIndex: 0,));

  @override
  void dispose() {
    super.dispose();
  }

  void updateSelectedIndex(int newIndex) {
    state = state.copyWith(selectedIndex: newIndex);
  }


}

final ProductScreenStateProvider = StateNotifierProvider.autoDispose<
    ProductScreenStateNotifier, ProductScreenState>((ref) {
  var notifier = ProductScreenStateNotifier();
  return notifier;
});
