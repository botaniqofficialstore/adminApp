import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductScreenState {
  final List<TextEditingController> benefitControllers;
  final TextEditingController productNameController;
  final TextEditingController productActualPriceController;
  final TextEditingController productSellingController;
  final TextEditingController productStockCountController;
  final TextEditingController productDescriptionController;
  final String? maxDeliveryDays;
  final String? productType;
  final String? productMainImage;
  final List<String?> extraImages;

  AddProductScreenState({
    required this.benefitControllers,
    required this.productNameController,
    required this.productActualPriceController,
    required this.productSellingController,
    required this.productStockCountController,
    required this.productDescriptionController,
    this.maxDeliveryDays,
    this.productType,
    this.productMainImage,
    this.extraImages = const [null, null, null, null],
  });

  AddProductScreenState copyWith({
    List<TextEditingController>? benefitControllers,
    TextEditingController? productNameController,
    TextEditingController? productActualPriceController,
    TextEditingController? productSellingController,
    TextEditingController? productStockCountController,
    TextEditingController? productDescriptionController,
    String? maxDeliveryDays,
    String? productType,
    String? productMainImage,
    List<String?>? extraImages,
  }) {
    return AddProductScreenState(
      benefitControllers: benefitControllers ?? this.benefitControllers,
      productNameController: productNameController ?? this.productNameController,
      productActualPriceController: productActualPriceController ?? this.productActualPriceController,
      productSellingController: productSellingController ?? this.productSellingController,
      productStockCountController: productStockCountController ?? this.productStockCountController,
      productDescriptionController: productDescriptionController ?? this.productDescriptionController,
      maxDeliveryDays: maxDeliveryDays ?? this.maxDeliveryDays,
        productType: productType ?? this.productType,
        productMainImage: productMainImage ?? this.productMainImage,
      extraImages: extraImages ?? this.extraImages,
    );
  }

  // Returns all non-empty benefits
  List<String> get benefits =>
      benefitControllers.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList();
}

class AddProductScreenStateNotifier extends StateNotifier<AddProductScreenState> {
  AddProductScreenStateNotifier()
      : super(AddProductScreenState(
      benefitControllers: [TextEditingController()],
  productNameController: TextEditingController(),
  productActualPriceController: TextEditingController(),
  productDescriptionController: TextEditingController(),
  productSellingController: TextEditingController(),
  productStockCountController: TextEditingController(),
  ));

  void updateDeliveryDayCount(String days){
    state = state.copyWith(maxDeliveryDays: days);
  }

  void updateProductType(String type){
    state = state.copyWith(productType: type);
  }

  void updateMainImage(String image){
    state = state.copyWith(productMainImage: image);
  }

  void updateExtraImage(int index, String imagePath) {
    final list = [...state.extraImages];
    list[index] = imagePath;
    state = state.copyWith(extraImages: list);
  }

  void deleteExtraImage(int index) {
    final list = [...state.extraImages];
    list[index] = null;
    state = state.copyWith(extraImages: list);
  }

  void addBenefitField() {
    if (state.benefitControllers.length == 10) return;
    final newList = [...state.benefitControllers, TextEditingController()];
    state = state.copyWith(benefitControllers: newList);
  }

  void removeBenefitField(int index) {
    final newList = [...state.benefitControllers];
    newList[index].dispose();         // dispose controller
    newList.removeAt(index);
    state = state.copyWith(benefitControllers: newList);
  }
}

final AddProductScreenStateProvider = StateNotifierProvider.autoDispose<
    AddProductScreenStateNotifier, AddProductScreenState>((ref) {
  return AddProductScreenStateNotifier();
});
