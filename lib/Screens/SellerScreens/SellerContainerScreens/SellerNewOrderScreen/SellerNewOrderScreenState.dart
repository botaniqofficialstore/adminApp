
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerNewOrderScreenState {
  final List<Map<String, dynamic>> productList;

  SellerNewOrderScreenState({
    required this.productList,
  });

  SellerNewOrderScreenState copyWith({
    List<Map<String, dynamic>>? productList,
  }) {
    return SellerNewOrderScreenState(
      productList: productList ?? this.productList,
    );
  }
}

class SellerNewOrderScreenNotifier
    extends StateNotifier<SellerNewOrderScreenState> {
  SellerNewOrderScreenNotifier() : super(SellerNewOrderScreenState(productList: _getSampleData(),));

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
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png'
      },
      {
        'id': 2,
        'name': 'Beetroot Microgreens',
        'price': '219',
        'quantity': '100 gm',
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png'
      },
    ];
  }


}

final sellerNewOrderScreenProvider = StateNotifierProvider.autoDispose<
    SellerNewOrderScreenNotifier, SellerNewOrderScreenState>((ref) {
  var notifier = SellerNewOrderScreenNotifier();
  return notifier;
});
