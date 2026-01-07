import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerSettingsScreenState {
  final bool pushNotify;
  final bool whatsappNotify;
  final bool smsNotify;

  SellerSettingsScreenState({
    this.pushNotify = true,
    this.whatsappNotify = false,
    this.smsNotify = false,
  });

  SellerSettingsScreenState copyWith({bool? pushNotify, bool? whatsappNotify, bool? smsNotify}) {
    return SellerSettingsScreenState(
      pushNotify: pushNotify ?? this.pushNotify,
      whatsappNotify: whatsappNotify ?? this.whatsappNotify,
      smsNotify: smsNotify ?? this.smsNotify,
    );
  }
}

class SellerSettingsScreenStateNotifier extends StateNotifier<SellerSettingsScreenState> {
  SellerSettingsScreenStateNotifier() : super(SellerSettingsScreenState());

  void togglePush(bool val) => state = state.copyWith(pushNotify: val);
  void toggleWhatsapp(bool val) => state = state.copyWith(whatsappNotify: val);
  void toggleSms(bool val) => state = state.copyWith(smsNotify: val);



}

final sellerSettingsScreenStateProvider =
StateNotifierProvider.autoDispose<SellerSettingsScreenStateNotifier,
    SellerSettingsScreenState>((ref) => SellerSettingsScreenStateNotifier());
