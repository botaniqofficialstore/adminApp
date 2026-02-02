import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../CommonViews/MapScreen.dart';



class SellerLocationScreenState {
  final bool isLoading;
  final LatLng? selectedLocation;
  final String selectPickupAddress;

  SellerLocationScreenState({
    this.isLoading = false,
    required this.selectedLocation,
    this.selectPickupAddress = '',

  });


  SellerLocationScreenState copyWith({
    bool? isLoading,
    LatLng? selectedLocation,
    String? selectPickupAddress,
  }) {
    return SellerLocationScreenState(
      isLoading: isLoading ?? this.isLoading,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectPickupAddress: selectPickupAddress ?? this.selectPickupAddress,
    );
  }
}

class SellerLocationScreenStateNotifier extends StateNotifier<SellerLocationScreenState> {
  SellerLocationScreenStateNotifier() : super(SellerLocationScreenState(selectedLocation: null
  ));


  void callMapPopup(BuildContext context) async {
    final Map<String, dynamic>? result =
    await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Map',
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => MapScreen(),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );

    if (result != null) {
      final LatLng? selectedLocation = result['location'];
      final String selectedAddress = result['address'] ?? '';

      setSelectedLocation(selectedLocation!, selectedAddress);
    }
  }

  /// Call this when location is selected from map/autocomplete
  void setSelectedLocation(LatLng location, String address) {
    state = state.copyWith(selectedLocation: location, selectPickupAddress: address);
  }

}











final sellerLocationScreenStateProvider =
StateNotifierProvider.autoDispose<SellerLocationScreenStateNotifier, SellerLocationScreenState>((ref) {
  return SellerLocationScreenStateNotifier();
});