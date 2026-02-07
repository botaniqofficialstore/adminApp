
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerConfirmOrderScreenState {
  final TextEditingController searchController;
  final List<Map<String, dynamic>> productList;

  SellerConfirmOrderScreenState({
    required this.searchController,
    required this.productList,
  });

  SellerConfirmOrderScreenState copyWith({
    TextEditingController? searchController,
    List<Map<String, dynamic>>? productList,
  }) {
    return SellerConfirmOrderScreenState(
      searchController: searchController ?? this.searchController,
      productList: productList ?? this.productList,
    );
  }
}

class SellerConfirmOrderScreenStateNotifier
    extends StateNotifier<SellerConfirmOrderScreenState> {
  SellerConfirmOrderScreenStateNotifier() : super(SellerConfirmOrderScreenState(
      searchController: TextEditingController(),
    productList: _getSampleData(),
  ));

  @override
  void dispose() {
    super.dispose();
  }

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


}

final sellerConfirmOrderScreenStateProvider = StateNotifierProvider.autoDispose<
    SellerConfirmOrderScreenStateNotifier, SellerConfirmOrderScreenState>((ref) {
  var notifier = SellerConfirmOrderScreenStateNotifier();
  return notifier;
});
