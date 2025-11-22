
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Constants/Constants.dart';

class ProductScreenState {
  final ScreenName currentModule;

  ProductScreenState({
    this.currentModule = ScreenName.home,
  });

  ProductScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return ProductScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class ProductScreenStateNotifier
    extends StateNotifier<ProductScreenState> {
  ProductScreenStateNotifier() : super(ProductScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final ProductScreenStateProvider = StateNotifierProvider.autoDispose<
    ProductScreenStateNotifier, ProductScreenState>((ref) {
  var notifier = ProductScreenStateNotifier();
  return notifier;
});
