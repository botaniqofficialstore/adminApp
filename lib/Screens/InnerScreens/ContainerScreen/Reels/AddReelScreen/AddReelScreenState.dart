
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';

class AddReelScreenState {
  final TextEditingController urlController;
  final TextEditingController descriptionController;

  AddReelScreenState({
    required this.urlController,
    required this.descriptionController,
  });

  AddReelScreenState copyWith({
    TextEditingController? urlController,
    TextEditingController? descriptionController,
  }) {
    return AddReelScreenState(
      urlController: urlController ?? this.urlController,
      descriptionController: descriptionController ?? this.descriptionController,
    );
  }
}

class AddReelScreenStateNotifier
    extends StateNotifier<AddReelScreenState> {
  AddReelScreenStateNotifier() : super(AddReelScreenState(urlController: TextEditingController(), descriptionController: TextEditingController()),);

  @override
  void dispose() {
    super.dispose();
  }


}

final AddReelScreenStateProvider = StateNotifierProvider.autoDispose<
    AddReelScreenStateNotifier, AddReelScreenState>((ref) {
  var notifier = AddReelScreenStateNotifier();
  return notifier;
});
