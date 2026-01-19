import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:botaniq_admin/Utility/ProductVerificationPopup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';

class SellerProductAddScreenState {
  final int currentStep;
  final int maxCompletedStep;
  final int deliveryDays;
  final TextEditingController productNameController;
  final TextEditingController productTypeController;
  final String? productCategory;
  final TextEditingController productActualPriceController;
  final TextEditingController productSellingPriceController;
  final String mainPhoto;
  final List<String> productImages;
  final List<Map<String, TextEditingController>> benefitSets;
  final int maxSets;
  final int maxBenefitLength;
  final TextEditingController productStockCountController;


  SellerProductAddScreenState({
    this.currentStep = 0,
    this.maxCompletedStep = 0,
    this.deliveryDays = 0,
    required this.productNameController,
    required this.productTypeController,
    this.productCategory,
    required this.productActualPriceController,
    required this.productSellingPriceController,
    required this.benefitSets,
    this.mainPhoto = '',
    this.productImages = const [],
    this.maxSets = 15,
    this.maxBenefitLength = 300,
    required this.productStockCountController,
  });

  // Live discount calculation
  double get discountPercentage {
    final int actualPrice =
        int.tryParse(productActualPriceController.text.trim()) ?? 0;

    final int sellingPrice =
        int.tryParse(productSellingPriceController.text.trim()) ?? 0;

    if (actualPrice <= 0 || sellingPrice <= 0) return 0;
    if (sellingPrice >= actualPrice) return 0;

    return ((actualPrice - sellingPrice) / actualPrice) * 100;
  }


  // Uploaded images count
  int get filledSetCount {
    final int main = mainPhoto.isNotEmpty ? 1 : 0;
    return main + productImages.length;
  }

  Color get progressColor {
    if (filledSetCount == 1) return Colors.red;
    if (filledSetCount == 2) return Colors.deepOrange;
    if (filledSetCount == 3) return Colors.yellowAccent;
    return Colors.green;
  }

  bool isBenefitSetFilled(int index) {
    return benefitSets[index]['vitamin']!.text.trim().isNotEmpty &&
        benefitSets[index]['benefit']!.text.trim().isNotEmpty;
  }

  int get benefitFilledSetCount {
    return benefitSets.where((set) {
      return set['vitamin']!.text.trim().isNotEmpty &&
          set['benefit']!.text.trim().isNotEmpty;
    }).length;
  }

  Color get benefitProgressColor {
    if (benefitFilledSetCount < 2) {
      return Colors.redAccent;
    } else if (benefitFilledSetCount < 3) {
      return Colors.orangeAccent;
    } else if (benefitFilledSetCount < 4) {
      return Colors.yellowAccent;
    } else {
      return Colors.green;
    }
  }



  SellerProductAddScreenState copyWith({
    int? currentStep,
    int? maxCompletedStep,
    int? deliveryDays,
    TextEditingController? productNameController,
    TextEditingController? productTypeController,
    String? productCategory,
    TextEditingController? productActualPriceController,
    TextEditingController? productSellingPriceController,
    String? mainPhoto,
    List<String>? productImages,
    List<Map<String, TextEditingController>>? benefitSets,
    int? maxSets,
    int? maxBenefitLength,
    TextEditingController? productStockCountController,
  }) {
    return SellerProductAddScreenState(
      currentStep: currentStep ?? this.currentStep,
      maxCompletedStep: maxCompletedStep ?? this.maxCompletedStep,
      deliveryDays: deliveryDays ?? this.deliveryDays,
      productNameController: productNameController ?? this.productNameController,
      productTypeController: productTypeController ?? this.productTypeController,
      productCategory: productCategory ?? this.productCategory,
      productActualPriceController: productActualPriceController ?? this.productActualPriceController,
      productSellingPriceController: productSellingPriceController ?? this.productSellingPriceController,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      productImages: productImages ?? this.productImages,
      benefitSets: benefitSets ?? this.benefitSets,
      productStockCountController: productStockCountController ?? this.productStockCountController,
    );
  }
}

class SellerProductAddScreenStateNotifier extends StateNotifier<SellerProductAddScreenState> {
  SellerProductAddScreenStateNotifier() : super(SellerProductAddScreenState(
    //------
    productNameController: TextEditingController(),
    productTypeController: TextEditingController(),
    productActualPriceController: TextEditingController(),
    productSellingPriceController: TextEditingController(),
    benefitSets: [],
    productStockCountController: TextEditingController(),
  ));




  void setStep(int step) {
    state = state.copyWith(
      currentStep: step,
      maxCompletedStep:
      step > state.maxCompletedStep ? step : state.maxCompletedStep,
    );
  }


  void updateProductCategory(String category) =>
      state = state.copyWith(productCategory: category);

  void onChanged() {
    state = state.copyWith();
  }

  void upDateDelivery(int days) => state = state.copyWith(deliveryDays: days);


  ///Mark:-  Product Image Upload Methods
  void updateMainPhoto(String imagePath) {
    state = state.copyWith(mainPhoto: imagePath);
  }

  void removeProductPhoto(int index) {
    // Create a new list copy excluding the item at the specified index
    final updatedPhotos = List<String>.from(state.productImages)..removeAt(index);

    // Update the state with the new list
    state = state.copyWith(productImages: updatedPhotos);
  }

  Future<void> uploadImage(BuildContext context, int index, {bool isMainImage = false}) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(context, ImageSource.gallery);
    if (imagePath != null) {
      if (isMainImage){
        updateMainPhoto(imagePath);
      } else {
        updateProductPhoto(imagePath, index);
      }
    }
  }

  void updateProductPhoto(String imagePath, int index) {
    // Create a NEW list instance using the spread operator [...]
    final List<String> uploadedImages = [...state.productImages];

    if (index < uploadedImages.length) {
      // Updating an existing slot
      uploadedImages[index] = imagePath;
    } else {
      // Adding a new image
      uploadedImages.add(imagePath);
    }

    // Now state.copyWith sees a different list reference and triggers a rebuild
    state = state.copyWith(productImages: uploadedImages);
  }



  ///Mark:-  Add Benefits Methods
  void addNewBenefitSet(BuildContext context) {
    // Max limit check
    if (state.benefitSets.length >= state.maxSets) {
      _showError(
        context,
        "Maximum ${state.maxSets} benefits allowed",
      );
      return;
    }

    // Validate last set before adding
    if (state.benefitSets.isNotEmpty) {
      final lastIndex = state.benefitSets.length - 1;
      final lastSet = state.benefitSets[lastIndex];

      final isValid = lastSet['vitamin']!.text.trim().isNotEmpty &&
          lastSet['benefit']!.text.trim().isNotEmpty;

      if (!isValid) {
        _showError(
          context,
          "Fill all fields before adding another benefit",
        );
        return;
      }
    }

    HapticFeedback.lightImpact();

    final updatedSets = [
      ...state.benefitSets,
      {
        'vitamin': TextEditingController(),
        'benefit': TextEditingController(),
      }
    ];

    state = state.copyWith(benefitSets: updatedSets);
  }


  void removeBenefitSet(int index) {
    final sets = [...state.benefitSets];

    // If only one set exists, just clear its values
    if (sets.length == 1) {
      sets[0]['vitamin']!.clear();
      sets[0]['benefit']!.clear();

      state = state.copyWith(benefitSets: sets);
      return;
    }

    // Dispose controllers before removing
    sets[index]['vitamin']?.dispose();
    sets[index]['benefit']?.dispose();

    sets.removeAt(index);

    state = state.copyWith(benefitSets: sets);
  }




  void _showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
        ),
      );
    }
  }


  ///Mark:- Empty Validation for Pages
  bool canMoveToNext(int step) {
    if (step == 0) {
      final productName = state.productNameController.text.trim();
      final productType = state.productTypeController.text.trim();

      return productName.isNotEmpty &&
          productType.isNotEmpty &&
          state.productCategory != null &&
          state.productCategory!.trim().isNotEmpty;
    }

    if (step == 1) {
      int productActualPrice = int.tryParse(state.productActualPriceController.text.trim()) ?? 0;
      int productSellingPrice = int.tryParse(state.productSellingPriceController.text.trim()) ?? 0;

      return productActualPrice > 0 && productSellingPrice > 0;
    }

    if (step == 2) {
      return (state.mainPhoto.isNotEmpty && state.productImages.length > 2);
    }

    if (step == 3) {
      return state.benefitFilledSetCount >= 4;
    }

    if (step == 4) {
      int stockCount = int.tryParse(state.productStockCountController.text.trim()) ?? 0;

      return (stockCount > 0);
    }

    if (step == 5){

      return (state.deliveryDays > 0);
    }

    return true;
  }


  void showVerificationPopup(BuildContext context) {
    ProductVerificationPopup.show(context);
  }

}

final sellerProductAddScreenStateProvider =
StateNotifierProvider.autoDispose<SellerProductAddScreenStateNotifier, SellerProductAddScreenState>((ref) {
  return SellerProductAddScreenStateNotifier();
});