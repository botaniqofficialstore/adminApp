import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        'date' : '05:23 PM, 17/02/2026'
      },
      {
        'id': 2,
        'name': 'Beetroot Microgreens',
        'price': '219',
        'quantity': '100 gm',
        'count': 1,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png',
        'date' : '12:30 PM, 13/02/2026'
      },
      {
        'id': 3,
        'name': 'Organic Hair Oil',
        'price': '450',
        'quantity': '200 ml',
        'count': 1,
        'image': 'https://drive.google.com/uc?export=view&id=1yRv8IO_7AOrpmiVI37YzF88bpDPlV1Pd',
        'date' : '09:13 AM, 10/02/2026'
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
}

final sellerCompletedDeliveryScreenStateProvider =
StateNotifierProvider.autoDispose<SellerCompletedDeliveryScreenStateNotifier,
    SellerCompletedDeliveryScreenState>((ref) {
  return SellerCompletedDeliveryScreenStateNotifier();
});