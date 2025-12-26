
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerScreenState {
  final TextEditingController searchController;

  CustomerScreenState({
    required this.searchController,
  });

  CustomerScreenState copyWith({
    TextEditingController? searchController,
  }) {
    return CustomerScreenState(
      searchController: searchController ?? this.searchController,
    );
  }
}

class CustomerScreenStateNotifier
    extends StateNotifier<CustomerScreenState> {
  CustomerScreenStateNotifier() : super(CustomerScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final CustomerScreenStateProvider = StateNotifierProvider.autoDispose<
    CustomerScreenStateNotifier, CustomerScreenState>((ref) {
  var notifier = CustomerScreenStateNotifier();
  return notifier;
});
