import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerPackedOrderScreenState {
  final List<bool> packedList;
  final String packagePhoto;
  final List<Map<String, dynamic>> productList;

  SellerPackedOrderScreenState({
    required this.packedList,
    required this.packagePhoto,
    required this.productList,
  });


  SellerPackedOrderScreenState copyWith({
    List<bool>? packedList,
    String? packagePhoto,
    List<Map<String, dynamic>>? productList,
  }) {
    return SellerPackedOrderScreenState(
        packedList: packedList ?? this.packedList,
        packagePhoto: packagePhoto ?? this.packagePhoto,
      productList: productList ?? this.productList,
    );
  }
}

class SellerPackedOrderScreenStateNotifier
    extends StateNotifier<SellerPackedOrderScreenState> {
  SellerPackedOrderScreenStateNotifier()
      : super(SellerPackedOrderScreenState(
      packedList: List.generate(2, (_) => false), packagePhoto: '',
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


}

final sellerPackedOrderScreenStateProvider =
StateNotifierProvider.autoDispose<
    SellerPackedOrderScreenStateNotifier,
    SellerPackedOrderScreenState>((ref) {
  return SellerPackedOrderScreenStateNotifier();
});



