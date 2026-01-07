import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductReview {
  final String userName;
  final String userImage;
  final double rating;
  final String date;
  final String comment;

  ProductReview({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class SellerProductFeedBackScreenState {
  final String productName;
  final String productImage;
  final double overallRating;
  final List<ProductReview> reviews;

  SellerProductFeedBackScreenState({
    this.productName = 'Red Amaranthus',
    this.productImage = 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
    this.overallRating = 4.9,
    this.reviews = const [],
  });

  SellerProductFeedBackScreenState copyWith({
    String? productName,
    String? productImage,
    double? overallRating,
    List<ProductReview>? reviews,
  }) {
    return SellerProductFeedBackScreenState(
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      overallRating: overallRating ?? this.overallRating,
      reviews: reviews ?? this.reviews,
    );
  }
}

class SellerProductFeedBackScreenStateNotifier extends StateNotifier<SellerProductFeedBackScreenState> {
  SellerProductFeedBackScreenStateNotifier() : super(SellerProductFeedBackScreenState()) {
    _loadReviews();
  }

  void _loadReviews() {
    state = state.copyWith(reviews: [
      ProductReview(
        userName: "Alex Johnson",
        userImage: "https://i.pravatar.cc/150?u=1",
        rating: 5.0,
        date: "2 days ago",
        comment: "The quality of these microgreens is exceptional! Extremely fresh and arrived in perfect condition. Highly recommended for garnish.",
      ),
      ProductReview(
        userName: "Maria Garcia",
        userImage: "https://i.pravatar.cc/150?u=2",
        rating: 4.5,
        date: "1 week ago",
        comment: "Fast delivery and great packaging. The flavor is very intense and earthy. Will definitely order again.",
      ),
      ProductReview(
        userName: "James Wilson",
        userImage: "https://i.pravatar.cc/150?u=3",
        rating: 4.0,
        date: "2 weeks ago",
        comment: "Very good quality, though I wish the portion size was slightly larger for the price point.",
      ),
      ProductReview(
        userName: "Sarah Miller",
        userImage: "https://i.pravatar.cc/150?u=4",
        rating: 5.0,
        date: "1 month ago",
        comment: "Absolutely love these! They stayed fresh in my fridge for over a week. Perfect for my morning smoothies.",
      ),
      ProductReview(
        userName: "David Chen",
        userImage: "https://i.pravatar.cc/150?u=5",
        rating: 4.8,
        date: "1 month ago",
        comment: "Incredible vibrant color. Used these for a dinner party and everyone asked where I got them. A bit pricey but worth it for the premium feel.",
      ),
      ProductReview(
        userName: "Emily Watson",
        userImage: "https://i.pravatar.cc/150?u=6",
        rating: 3.5,
        date: "2 months ago",
        comment: "The product itself is 5 stars, but the delivery took two days longer than promised. The greens were still cold, so no harm done.",
      ),
      ProductReview(
        userName: "Michael Ross",
        userImage: "https://i.pravatar.cc/150?u=7",
        rating: 5.0,
        date: "2 months ago",
        comment: "Consistency is key for my restaurant, and Botaniq delivers every single time. Best microgreens in the city, hands down.",
      ),
      ProductReview(
        userName: "Jessica Alba",
        userImage: "https://i.pravatar.cc/150?u=8",
        rating: 4.2,
        date: "3 months ago",
        comment: "Great crunch and peppery taste. I appreciate the eco-friendly packaging they used.",
      ),
      ProductReview(
        userName: "Robert Fox",
        userImage: "https://i.pravatar.cc/150?u=9",
        rating: 5.0,
        date: "3 months ago",
        comment: "Super healthy addition to my diet. I love how these are grown locally.",
      ),
      ProductReview(
        userName: "Linda Thorne",
        userImage: "https://i.pravatar.cc/150?u=10",
        rating: 2.0,
        date: "4 months ago",
        comment: "I received the wrong variety of Amaranthus. Customer support was helpful in fixing it, but it was still a bit frustrating.",
      ),
    ]);
  }
}

final sellerProductFeedBackScreenStateProvider =
StateNotifierProvider.autoDispose<SellerProductFeedBackScreenStateNotifier, SellerProductFeedBackScreenState>(
        (ref) => SellerProductFeedBackScreenStateNotifier());