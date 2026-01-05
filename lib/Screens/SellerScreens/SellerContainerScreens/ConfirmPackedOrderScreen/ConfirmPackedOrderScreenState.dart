import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utility/MediaHandler.dart';

class ConfirmPackedOrderScreenState {
  final List<bool> packedList;
  final String packagePhoto;

  ConfirmPackedOrderScreenState({
    required this.packedList,
    required this.packagePhoto,
  });

  bool get isAllPacked =>
      packedList.every((e) => e) && packagePhoto.trim().isNotEmpty;


  ConfirmPackedOrderScreenState copyWith({
    List<bool>? packedList,
    String? packagePhoto,
  }) {
    return ConfirmPackedOrderScreenState(
      packedList: packedList ?? this.packedList,
      packagePhoto: packagePhoto ?? this.packagePhoto
    );
  }
}

class ConfirmPackedOrderScreenStateNotifier
    extends StateNotifier<ConfirmPackedOrderScreenState> {
  ConfirmPackedOrderScreenStateNotifier()
      : super(ConfirmPackedOrderScreenState(
      packedList: List.generate(2, (_) => false), packagePhoto: ''));

  void togglePacked(int index) {
    final updated = [...state.packedList];
    updated[index] = !updated[index];
    state = state.copyWith(packedList: updated);
  }

  void updatePackagePhoto(String imagePath) {
    state = state.copyWith(packagePhoto: imagePath);
  }

  Future<void> uploadImage(BuildContext context) async {
    final imagePath = await MediaHandler().handleCommonMediaPicker(
        context, ImageSource.camera);
    if (imagePath != null) {
      updatePackagePhoto(imagePath);
    }
  }

}

final ConfirmPackedOrderScreenStateProvider =
StateNotifierProvider.autoDispose<
    ConfirmPackedOrderScreenStateNotifier,
    ConfirmPackedOrderScreenState>((ref) {
  return ConfirmPackedOrderScreenStateNotifier();
});



