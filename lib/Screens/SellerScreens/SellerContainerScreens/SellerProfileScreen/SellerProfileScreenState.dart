import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';

class SellerProfileScreenState {
  final String brandName;
  final String brandLogo;

  SellerProfileScreenState({
    this.brandName = '',
    this.brandLogo = '',
  });

  SellerProfileScreenState copyWith({String? brandName, String? brandLogo}) {
    return SellerProfileScreenState(
      brandName: brandName ?? this.brandName,
      brandLogo: brandLogo ?? this.brandLogo,
    );
  }
}

class SellerProfileScreenStateNotifier extends StateNotifier<SellerProfileScreenState> {
  SellerProfileScreenStateNotifier() : super(SellerProfileScreenState());


  void callNavigation(int index, SellerMainScreenGlobalStateNotifier userScreenNotifier){
    if (index == 0){
      userScreenNotifier.callNavigation(ScreenName.profile);
    } else if (index == 1){
      userScreenNotifier.callNavigation(ScreenName.location);
    } else if (index == 2){
      userScreenNotifier.callNavigation(ScreenName.rating);
    } else if (index == 3){
      userScreenNotifier.callNavigation(ScreenName.products);
    } else if (index == 4){
      userScreenNotifier.callNavigation(ScreenName.settings);
    } else if (index == 5){
      userScreenNotifier.callNavigation(ScreenName.legal);
    } else if (index == 6){
      userScreenNotifier.callNavigation(ScreenName.businessHours);
    } else if (index == 7){
      //Support
    }
  }



}

final sellerProfileScreenStateProvider = StateNotifierProvider.autoDispose<SellerProfileScreenStateNotifier, SellerProfileScreenState>((ref) => SellerProfileScreenStateNotifier());

class ProfileItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool showCount;
  final int count;

  ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.showCount,
    required this.count,
  });
}
