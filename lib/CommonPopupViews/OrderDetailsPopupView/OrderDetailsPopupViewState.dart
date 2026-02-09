import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class OrderDetailsPopupViewState {
  final int? selectedPointIndex;
  final List<Map<String, dynamic>> productList;

  OrderDetailsPopupViewState({
    this.selectedPointIndex,
    required this.productList,
  });


  OrderDetailsPopupViewState copyWith({
    int? selectedPointIndex,
    List<Map<String, dynamic>>? productList,
  }) {
    return OrderDetailsPopupViewState(
      selectedPointIndex: selectedPointIndex ?? this.selectedPointIndex,
      productList: productList ?? this.productList,
    );
  }
}

class OrderDetailsPopupViewStateNotifier extends StateNotifier<OrderDetailsPopupViewState> {
  OrderDetailsPopupViewStateNotifier() : super(OrderDetailsPopupViewState(
    productList: _getSampleData(),
  ));

  static List<Map<String, dynamic>> _getSampleData() {
    return [
      {
        'id': 1,
        'name': 'Radish Pink Microgreen',
        'price': '189',
        'quantity': '250 gm',
        'count' : 2,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png'
      },
      {
        'id': 2,
        'name': 'Beetroot Microgreens',
        'price': '219',
        'quantity': '100 gm',
        'count' : 1,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png'
      },
    ];
  }

  void showDownloadingToast(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Center(
            child: const Text(
              'Invoice Downloading...',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.dp),
          ),
        ),
      );
  }

}

final orderDetailsPopupViewStateProvider = StateNotifierProvider.autoDispose<
    OrderDetailsPopupViewStateNotifier, OrderDetailsPopupViewState>((ref) => OrderDetailsPopupViewStateNotifier());