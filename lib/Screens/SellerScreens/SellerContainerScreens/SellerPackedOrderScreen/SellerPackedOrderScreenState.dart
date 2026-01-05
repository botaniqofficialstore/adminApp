import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';

class SellerPackedOrderScreenState {
  final List<bool> packedList;
  final String packagePhoto;

  SellerPackedOrderScreenState({
    required this.packedList,
    required this.packagePhoto,
  });


  SellerPackedOrderScreenState copyWith({
    List<bool>? packedList,
    String? packagePhoto,
  }) {
    return SellerPackedOrderScreenState(
        packedList: packedList ?? this.packedList,
        packagePhoto: packagePhoto ?? this.packagePhoto
    );
  }
}

class SellerPackedOrderScreenStateNotifier
    extends StateNotifier<SellerPackedOrderScreenState> {
  SellerPackedOrderScreenStateNotifier()
      : super(SellerPackedOrderScreenState(
      packedList: List.generate(2, (_) => false), packagePhoto: ''));


}

final SellerPackedOrderScreenStateProvider =
StateNotifierProvider.autoDispose<
    SellerPackedOrderScreenStateNotifier,
    SellerPackedOrderScreenState>((ref) {
  return SellerPackedOrderScreenStateNotifier();
});



