import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerProductsScreenState {
  final List<Map<String, dynamic>> allProducts;
  final List<Map<String, dynamic>> filteredProducts;
  final String searchQuery;

  SellerProductsScreenState({
    required this.allProducts,
    required this.filteredProducts,
    this.searchQuery = '',
  });

  SellerProductsScreenState copyWith({
    List<Map<String, dynamic>>? allProducts,
    List<Map<String, dynamic>>? filteredProducts,
    String? searchQuery,
  }) {
    return SellerProductsScreenState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class SellerProductsScreenStateNotifier extends StateNotifier<SellerProductsScreenState> {
  SellerProductsScreenStateNotifier() : super(SellerProductsScreenState(
    allProducts: _getSampleData(),
    filteredProducts: _getSampleData(),
  ));

  void updateSearch(String query) {
    final filtered = state.allProducts
        .where((p) => p['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = state.copyWith(searchQuery: query, filteredProducts: filtered);
  }

  static List<Map<String, dynamic>> _getSampleData() {
    return [
      {'id': 1, 'name': 'Radish Pink Microgreen', 'price': '189', 'quantity': '250 gm', 'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png'},
      {'id': 2, 'name': 'Beetroot Microgreens', 'price': '219', 'quantity': '100 gm', 'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png'},
      {'id': 3, 'name': 'Body Lotion', 'price': '589', 'quantity': '80 ml', 'image': 'https://drive.google.com/uc?export=view&id=1bGeGt3KwsA9qxgye6_xyTlumIXJ9dB6w'},
      {'id': 4, 'name': 'Saffron', 'price': '349', 'quantity': '50 gm', 'image': 'https://drive.google.com/uc?export=view&id=1a-gMZQnJ8Wb-vIHWuN096fihPYlFfb8M'},
      {'id': 5, 'name': 'Ayurvedic Oil', 'price': '499', 'quantity': '250 ml', 'image': 'https://drive.google.com/uc?export=view&id=1xMbrdOw0U2fQgd5lg-Vjc8qYLCMCBRfx'},
      {'id': 6, 'name': 'Beard Oil', 'price': '7.50', 'quantity': '100 ml', 'image': 'https://drive.google.com/uc?export=view&id=1RrgnKP-jwliXtrX8wT9QZQkYRvKgwt-e'},
      {'id': 7, 'name': 'Face Cream', 'price': '349', 'quantity': '100 gm', 'image': 'https://drive.google.com/uc?export=view&id=11DFsZtITk6NZKAnHGM8hDL8iO-LQ4n5Y'},
      {'id': 8, 'name': 'Ayurvedic Hair Oil', 'price': '689', 'quantity': '200 ml', 'image': 'https://drive.google.com/uc?export=view&id=1yRv8IO_7AOrpmiVI37YzF88bpDPlV1Pd'},
      {'id': 9, 'name': 'Lavender Soap', 'price': '299', 'quantity': '250 gm', 'image': 'https://drive.google.com/uc?export=view&id=1ExMk6zlcF7POSiKmSn0F_7w-Omf7ezGL'},
      {'id': 10, 'name': 'Kerala Spices', 'price': '199', 'quantity': '100 gm', 'image': 'https://drive.google.com/uc?export=view&id=18sWwbn5yEI5yk2b1F9lYjd3HoH1kVgwx'},
    ];
  }
}

final sellerProductsScreenStateProvider = StateNotifierProvider.autoDispose<SellerProductsScreenStateNotifier, SellerProductsScreenState>((ref) => SellerProductsScreenStateNotifier());