import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ReturnOrderModel {
  final String orderId;
  final String productName;
  final String productImage;
  final String customerName;
  final String customerPhone;
  final String price;
  final int itemCount;
  final String quantity;
  final bool isExpanded;

  // Outbound Logistics (Flow 1)
  final String outboundPartner;
  final String orderedDate;
  final String deliveredToCustomerDate;

  // Return Logistics (Flow 2)
  final String returnPartner;
  final String returnInitiatedDate;
  final String returnedToSellerDate;
  final String returnReason;

  ReturnOrderModel({
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.customerName,
    required this.customerPhone,
    required this.price,
    required this.itemCount,
    required this.quantity,
    required this.outboundPartner,
    required this.orderedDate,
    required this.deliveredToCustomerDate,
    required this.returnPartner,
    required this.returnInitiatedDate,
    required this.returnedToSellerDate,
    required this.returnReason,
    this.isExpanded = false,
  });

  ReturnOrderModel copyWith({bool? isExpanded}) {
    return ReturnOrderModel(
      orderId: orderId,
      productName: productName,
      productImage: productImage,
      customerName: customerName,
      customerPhone: customerPhone,
      price: price,
      itemCount: itemCount,
      quantity: quantity,
      outboundPartner: outboundPartner,
      orderedDate: orderedDate,
      deliveredToCustomerDate: deliveredToCustomerDate,
      returnPartner: returnPartner,
      returnInitiatedDate: returnInitiatedDate,
      returnedToSellerDate: returnedToSellerDate,
      returnReason: returnReason,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class SellerReturnOrderHistoryScreenState {
  final List<ReturnOrderModel> returnOrders;
  final TextEditingController searchController;

  SellerReturnOrderHistoryScreenState({
    required this.returnOrders,
    required this.searchController,
  });

  SellerReturnOrderHistoryScreenState copyWith({
    List<ReturnOrderModel>? returnOrders,
    TextEditingController? searchController,
  }) {
    return SellerReturnOrderHistoryScreenState(
      returnOrders: returnOrders ?? this.returnOrders,
      searchController: searchController ?? this.searchController,
    );
  }
}

class SellerReturnOrderHistoryScreenStateNotifier
    extends StateNotifier<SellerReturnOrderHistoryScreenState> {
  SellerReturnOrderHistoryScreenStateNotifier()
      : super(SellerReturnOrderHistoryScreenState(
    searchController: TextEditingController(),
    returnOrders: [],
  ));

  void loadInitialData() {
    state = state.copyWith(returnOrders: [
      ReturnOrderModel(
        orderId: "97845120452",
        productName: "Premium Arabica Coffee Beans",
        productImage: "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=500&auto=format&fit=crop",
        customerName: "Vikram Malhotra",
        customerPhone: "+91 99887 76655",
        price: "₹1,450.00",
        itemCount: 2,
        quantity: "500g",
        // Outbound
        outboundPartner: "Express Logistics (Ravi Kumar)",
        orderedDate: "Jan 10, 2024 • 10:00 AM",
        deliveredToCustomerDate: "Jan 12, 2024 • 02:15 PM",
        // Return
        returnPartner: "Reverse-Ship (Amit Singh)",
        returnInitiatedDate: "Jan 13, 2024 • 09:00 AM",
        returnedToSellerDate: "Jan 15, 2024 • 04:45 PM",
        returnReason: "Packaging was torn; moisture detected.",
      ),
      ReturnOrderModel(
        orderId: "97845120452",
        productName: "Premium Arabica Coffee Beans",
        productImage: "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?q=80&w=500&auto=format&fit=crop",
        customerName: "Vikram Malhotra",
        customerPhone: "+91 99887 76655",
        price: "₹1,450.00",
        itemCount: 2,
        quantity: "500g",
        // Outbound
        outboundPartner: "Express Logistics (Ravi Kumar)",
        orderedDate: "Jan 10, 2024 • 10:00 AM",
        deliveredToCustomerDate: "Jan 12, 2024 • 02:15 PM",
        // Return
        returnPartner: "Reverse-Ship (Amit Singh)",
        returnInitiatedDate: "Jan 13, 2024 • 09:00 AM",
        returnedToSellerDate: "Jan 15, 2024 • 04:45 PM",
        returnReason: "Packaging was torn; moisture detected.",
      ),
    ]);
  }

  void toggleExpansion(int index) {
    final List<ReturnOrderModel> updatedList = [...state.returnOrders];
    updatedList[index] = updatedList[index].copyWith(isExpanded: !updatedList[index].isExpanded);
    state = state.copyWith(returnOrders: updatedList);
  }
}

final sellerReturnOrderHistoryScreenStateProvider =
StateNotifierProvider.autoDispose<SellerReturnOrderHistoryScreenStateNotifier, SellerReturnOrderHistoryScreenState>((ref) {
  return SellerReturnOrderHistoryScreenStateNotifier();
});