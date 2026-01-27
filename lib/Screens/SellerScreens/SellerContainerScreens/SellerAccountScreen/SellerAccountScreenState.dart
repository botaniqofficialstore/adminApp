import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerAccountScreenState {
  final bool pushNotify;

  SellerAccountScreenState({
    this.pushNotify = true,
  });

  SellerAccountScreenState copyWith({bool? pushNotify}) {
    return SellerAccountScreenState(
      pushNotify: pushNotify ?? this.pushNotify,
    );
  }
}

class SellerAccountScreenStateNotifier extends StateNotifier<SellerAccountScreenState> {
  SellerAccountScreenStateNotifier() : super(SellerAccountScreenState());

  void togglePush(bool val) => state = state.copyWith(pushNotify: val);
}

final sellerAccountScreenStateProvider =
StateNotifierProvider.autoDispose<SellerAccountScreenStateNotifier, SellerAccountScreenState>(
        (ref) => SellerAccountScreenStateNotifier());