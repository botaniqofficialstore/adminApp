
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Constants/Constants.dart';


class ProfileScreenState {
  final ScreenName currentModule;

  ProfileScreenState({
    this.currentModule = ScreenName.home,
  });

  ProfileScreenState copyWith({
    ScreenName? currentModule,
  }) {
    return ProfileScreenState(
      currentModule: currentModule ?? this.currentModule,
    );
  }
}

class ProfileScreenStateNotifier
    extends StateNotifier<ProfileScreenState> {
  ProfileScreenStateNotifier() : super(ProfileScreenState());

  @override
  void dispose() {
    super.dispose();
  }


}

final ProfileScreenStateProvider = StateNotifierProvider.autoDispose<
    ProfileScreenStateNotifier, ProfileScreenState>((ref) {
  var notifier = ProfileScreenStateNotifier();
  return notifier;
});
