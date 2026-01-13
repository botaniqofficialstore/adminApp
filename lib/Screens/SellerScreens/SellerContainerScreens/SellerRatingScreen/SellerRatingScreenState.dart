import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatedProduct {
  final String name;
  final String image;
  final double rating;
  final int reviewCount;
  final int newCount;

  RatedProduct({
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.newCount});
}

class SellerRatingScreenState {
  final double overallRating;
  final List<RatedProduct> topProducts;

  SellerRatingScreenState({
    this.overallRating = 4.5,
    this.topProducts = const [],
  });

  SellerRatingScreenState copyWith({double? overallRating, List<RatedProduct>? topProducts}) {
    return SellerRatingScreenState(
      overallRating: overallRating ?? this.overallRating,
      topProducts: topProducts ?? this.topProducts,
    );
  }
}

class SellerRatingScreenStateNotifier extends StateNotifier<SellerRatingScreenState> {
  SellerRatingScreenStateNotifier() : super(SellerRatingScreenState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    state = state.copyWith(topProducts: [
      RatedProduct(
        name: "Red Amaranthus",
        image: 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
        rating: 4.9,
        reviewCount: 124,
          newCount: 165
      ),
      RatedProduct(
        name: "Beetroot",
        image: 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png',
        rating: 4.7,
        reviewCount: 89,
          newCount: 15
      ),
      RatedProduct(
        name: "Sun Flower",
        image: 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/sunflower_Micro.png',
        rating: 4.7,
        reviewCount: 1452,
          newCount: 0
      ),
      RatedProduct(
        name: "Broccoli",
        image: 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/broccoli_Micro.png',
        rating: 4.2,
        reviewCount: 458,
          newCount: 0
      ),
    ]);
  }
}

final sellerRatingScreenStateProvider =
StateNotifierProvider.autoDispose<SellerRatingScreenStateNotifier, SellerRatingScreenState>(
        (ref) => SellerRatingScreenStateNotifier());