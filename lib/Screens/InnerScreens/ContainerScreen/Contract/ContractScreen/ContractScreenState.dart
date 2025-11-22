
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Constants/Constants.dart';

class ContractScreenState {
  final ScreenName currentModule;
  final TextEditingController searchController;

  ContractScreenState({
    this.currentModule = ScreenName.home,
    required this.searchController,
  });

  ContractScreenState copyWith({
    ScreenName? currentModule,
    TextEditingController? searchController,
  }) {
    return ContractScreenState(
      currentModule: currentModule ?? this.currentModule,
      searchController: searchController ?? this.searchController,
    );
  }
}

class ContractScreenStateNotifier
    extends StateNotifier<ContractScreenState> {
  ContractScreenStateNotifier() : super(ContractScreenState(searchController: TextEditingController()));

  @override
  void dispose() {
    super.dispose();
  }


}

final ContractScreenStateProvider = StateNotifierProvider.autoDispose<
    ContractScreenStateNotifier, ContractScreenState>((ref) {
  var notifier = ContractScreenStateNotifier();
  return notifier;
});
