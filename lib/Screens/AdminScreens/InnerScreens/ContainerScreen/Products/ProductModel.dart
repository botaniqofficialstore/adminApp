class ProductData {
  final String id;
  final String productId;
  final String productName;
  final int productPrice;
  final int productSellingPrice;
  final int gram;
  final String image;
  final String coverImage;
  final String createdAt;
  final String updatedAt;
  final int v;
  final int isWishlisted;
  final int inCart;

  ProductData({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productSellingPrice,
    required this.gram,
    required this.image,
    required this.coverImage,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.isWishlisted,
    required this.inCart,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['_id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productPrice: json['productPrice'] ?? 0,
      productSellingPrice: json['productSellingPrice'] ?? 0,
      gram: json['gram'] ?? 0,
      image: json['image'] ?? '',
      coverImage: json['coverImage'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      isWishlisted: json['isWishlisted'] ?? 0,
      inCart: json['inCart'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productSellingPrice': productSellingPrice,
      'gram': gram,
      'image': image,
      'coverImage': coverImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'isWishlisted': isWishlisted,
      'inCart': inCart,
    };
  }
}

//This method is used to store the product details and shared to product details screen
class ProductDetailStatus {
  int isWishlisted;
  int inCart;
  int count;
  String coverImage;
  String productID;

  ProductDetailStatus({
    this.isWishlisted = 0,
    this.inCart = 0,
    this.count = 0,
    this.coverImage = '',
    this.productID = ''
  });

  // Convert to JSON (for storing in local storage or APIs)
  Map<String, dynamic> toJson() {
    return {
      'isWishlisted': isWishlisted,
      'inCart': inCart,
      'count': count,
      'coverImage': coverImage,
      'productID': productID
    };
  }

  // Create from JSON (for reading from storage or APIs)
  factory ProductDetailStatus.fromJson(Map<String, dynamic> json) {
    return ProductDetailStatus(
        isWishlisted: json['isWishlisted'] ?? 0,
        inCart: json['inCart'] ?? 0,
        count: json['count'] ?? 0,
        coverImage: json['coverImage'] ?? '',
        productID: json['productID'] ?? ''
    );
  }
}
