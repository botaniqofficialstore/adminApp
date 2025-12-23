
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';

class AdvertisementScreenState {
  final ScreenName currentModule;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String? advImagePath;
  final bool? addPoster;

  AdvertisementScreenState({
    this.currentModule = ScreenName.home,
    required this.titleController,
    required this.descriptionController,
    this.advImagePath,
    required this.addPoster,
  });

  AdvertisementScreenState copyWith({
    ScreenName? currentModule,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    String? advImagePath,
    bool? addPoster
  }) {
    return AdvertisementScreenState(
      currentModule: currentModule ?? this.currentModule,
      titleController: titleController ?? this.titleController,
      descriptionController: descriptionController ?? this.descriptionController,
      advImagePath: advImagePath ?? this.advImagePath,
      addPoster: addPoster ?? this.addPoster,
    );
  }
}

class AdvertisementScreenStateNotifier
    extends StateNotifier<AdvertisementScreenState> {
  AdvertisementScreenStateNotifier() : super(AdvertisementScreenState(
      titleController: TextEditingController(),
      descriptionController: TextEditingController(), addPoster: true));

  @override
  void dispose() {
    super.dispose();
  }

  void setProfileImagePath(String path) {
    state = state.copyWith(advImagePath: path);
  }

  void updateAdPosterState(bool updatedState){
    state = state.copyWith(addPoster: updatedState);
  }



}

final AdvertisementScreenStateProvider = StateNotifierProvider.autoDispose<
    AdvertisementScreenStateNotifier, AdvertisementScreenState>((ref) {
  var notifier = AdvertisementScreenStateNotifier();
  return notifier;
});
