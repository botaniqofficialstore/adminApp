import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../CommonPopupViews/CalendarFilterPopup/CalendarFilterPopup.dart';

class SellerCompletedDeliveryScreenState {
  final List<Map<String, dynamic>> productList;
  final List<Map<String, dynamic>> allProducts; // To keep original data

  SellerCompletedDeliveryScreenState({
    required this.productList,
    required this.allProducts,
  });

  SellerCompletedDeliveryScreenState copyWith({
    List<Map<String, dynamic>>? productList,
    List<Map<String, dynamic>>? allProducts,
  }) {
    return SellerCompletedDeliveryScreenState(
      productList: productList ?? this.productList,
      allProducts: allProducts ?? this.allProducts,
    );
  }
}

class SellerCompletedDeliveryScreenStateNotifier
    extends StateNotifier<SellerCompletedDeliveryScreenState> {
  SellerCompletedDeliveryScreenStateNotifier()
      : super(SellerCompletedDeliveryScreenState(
    productList: _getSampleData(),
    allProducts: _getSampleData(),
  ));

  static List<Map<String, dynamic>> _getSampleData() {
    return [
      {
        'id': 1,
        'name': 'Radish Pink Microgreen',
        'price': '189',
        'quantity': '250 gm',
        'count': 2,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
        'date': 'Feb 02, 05:23 PM'
      },
      {
        'id': 2,
        'name': 'Beetroot Microgreens',
        'price': '219',
        'quantity': '100 gm',
        'count': 1,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png',
        'date': 'Feb 07, 12:30 PM'
      },
      {
        'id': 3,
        'name': 'Organic Hair Oil',
        'price': '450',
        'quantity': '200 ml',
        'count': 1,
        'image': 'https://drive.google.com/uc?export=view&id=1yRv8IO_7AOrpmiVI37YzF88bpDPlV1Pd',
        'date': 'Feb 09, 09:13 AM'
      },
    ];
  }

  void filterOrders(String query) {
    if (query.isEmpty) {
      state = state.copyWith(productList: state.allProducts);
    } else {
      final filteredList = state.allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final id = product['id'].toString();
        return name.contains(query.toLowerCase()) || id.contains(query);
      }).toList();
      state = state.copyWith(productList: filteredList);
    }
  }

  void showCalendarFilterPopup(BuildContext context) async {
    await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withAlpha(180),
      barrierDismissible: false,
      barrierLabel: 'calendar',
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: const CalendarFilterPopup(isCustomRange: true),
      ),
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
  }
}

final sellerCompletedDeliveryScreenStateProvider =
StateNotifierProvider.autoDispose<SellerCompletedDeliveryScreenStateNotifier,
    SellerCompletedDeliveryScreenState>((ref) {
  return SellerCompletedDeliveryScreenStateNotifier();
});