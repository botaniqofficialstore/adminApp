import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerProductAddScreenState {
  final int currentStep;
  final String productName;
  final String productType;
  final double actualPrice;
  final double sellingPrice;
  final int stockCount;
  final List<String> benefits;

  SellerProductAddScreenState({
    this.currentStep = 0,
    this.productName = '',
    this.productType = '',
    this.actualPrice = 0.0,
    this.sellingPrice = 0.0,
    this.stockCount = 0,
    this.benefits = const [],
  });

  // Live discount calculation
  double get discountPercentage {
    if (actualPrice <= 0 || sellingPrice <= 0) return 0;
    if (sellingPrice >= actualPrice) return 0;
    return ((actualPrice - sellingPrice) / actualPrice) * 100;
  }

  SellerProductAddScreenState copyWith({
    int? currentStep,
    String? productName,
    String? productType,
    double? actualPrice,
    double? sellingPrice,
    int? stockCount,
    List<String>? benefits,
  }) {
    return SellerProductAddScreenState(
      currentStep: currentStep ?? this.currentStep,
      productName: productName ?? this.productName,
      productType: productType ?? this.productType,
      actualPrice: actualPrice ?? this.actualPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockCount: stockCount ?? this.stockCount,
      benefits: benefits ?? this.benefits,
    );
  }
}

class SellerProductAddScreenStateNotifier extends StateNotifier<SellerProductAddScreenState> {
  SellerProductAddScreenStateNotifier() : super(SellerProductAddScreenState());

  void setStep(int step) => state = state.copyWith(currentStep: step);

  void updateProductDetails({String? name, String? type}) {
    state = state.copyWith(productName: name, productType: type);
  }

  void updatePrices({double? actual, double? selling}) {
    state = state.copyWith(actualPrice: actual, sellingPrice: selling);
  }

  void updateStock(int count) => state = state.copyWith(stockCount: count);

  bool canMoveToNext(int step) {
    switch (step) {
      case 0: return state.productName.isNotEmpty && state.productType.isNotEmpty;
      case 1: return state.actualPrice > 0 && state.sellingPrice > 0;
      case 2: return true; // Images handled later
      case 3: return state.benefits.isNotEmpty;
      default: return true;
    }
  }
}

final sellerProductAddScreenStateProvider =
StateNotifierProvider.autoDispose<SellerProductAddScreenStateNotifier, SellerProductAddScreenState>((ref) {
  return SellerProductAddScreenStateNotifier();
});