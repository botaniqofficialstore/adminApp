import 'package:flutter_riverpod/flutter_riverpod.dart';


/// --- STATE CLASS ---
class SellerProductDetailsScreenState {
  final int inCart;
  final int count;

  SellerProductDetailsScreenState({
    this.inCart = 0,
    this.count = 1,
  });

  SellerProductDetailsScreenState copyWith({
    int? inCart,
    int? count,
  }) {
    return SellerProductDetailsScreenState(
      inCart: inCart ?? this.inCart,
      count: count ?? this.count,
    );
  }
}

/// --- STATE NOTIFIER ---
class SellerProductDetailsScreenStateNotifier
    extends StateNotifier<SellerProductDetailsScreenState> {
  SellerProductDetailsScreenStateNotifier()
      : super(SellerProductDetailsScreenState());

  @override
  void dispose() {
    super.dispose();
  }

}

/// --- PROVIDER ---
final sellerProductDetailsScreenStateProvider =
StateNotifierProvider.autoDispose<SellerProductDetailsScreenStateNotifier,
    SellerProductDetailsScreenState>((ref) {
  return SellerProductDetailsScreenStateNotifier();
});
