import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Constants/Constants.dart';

class SellerConfirmOrderScreenState {
  final TextEditingController searchController;
  final List<Map<String, dynamic>> productList;
  final List<Map<String, dynamic>> originalList; // Keep master list for searching

  SellerConfirmOrderScreenState({
    required this.searchController,
    required this.productList,
    required this.originalList,
  });

  SellerConfirmOrderScreenState copyWith({
    TextEditingController? searchController,
    List<Map<String, dynamic>>? productList,
    List<Map<String, dynamic>>? originalList,
  }) {
    return SellerConfirmOrderScreenState(
      searchController: searchController ?? this.searchController,
      productList: productList ?? this.productList,
      originalList: originalList ?? this.originalList,
    );
  }
}

class SellerConfirmOrderScreenStateNotifier
    extends StateNotifier<SellerConfirmOrderScreenState> {
  SellerConfirmOrderScreenStateNotifier()
      : super(SellerConfirmOrderScreenState(
    searchController: TextEditingController(),
    productList: _getSampleData(),
    originalList: _getSampleData(),
  ));

  @override
  void dispose() {
    state.searchController.dispose();
    super.dispose();
  }

  static List<Map<String, dynamic>> _getSampleData() {
    return [
      {
        'id': 1,
        'name': 'Radish Pink Microgreen',
        'price': '189',
        'quantity': '250 gm',
        'count': 2,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/radhishPink_Micro.png',
        'orderDate': 'Feb 02, 05:23 PM',
        'confirmDate': 'Feb 02, 08:30 PM',
        'customerName': 'Priya Das',
        'address': 'Suite 101, Business Park, Bengaluru, Karnataka'
      },
      {
        'id': 2,
        'name': 'Beetroot Microgreens',
        'price': '219',
        'quantity': '100 gm',
        'count': 1,
        'image': 'https://botaniqofficialstore.github.io/botaniqofficialstore/assets/microgreens/betroot_Micro.png',
        'orderDate': 'Feb 07, 12:30 PM',
        'confirmDate': 'Feb 03, 10:15 AM',
        'address': 'Door No. 12, Rose Villa, MG Road, Ernakulam',
        'customerName': 'Anjali Nair',
      },
      {
        'id': 3,
        'name': 'Organic Hair Oil',
        'price': '450',
        'quantity': '200 ml',
        'count': 1,
        'image': 'https://drive.google.com/uc?export=view&id=1yRv8IO_7AOrpmiVI37YzF88bpDPlV1Pd',
        'orderDate': 'Feb 09, 09:13 AM',
        'confirmDate': 'Feb 09, 02:43 PM',
        'address': 'Flat 402, Green Valley Apartments, Thrissur, Kerala',
        'customerName': 'Rahul Sharma',
      },
    ];
  }

  // Search/Filter logic
  void filterOrders(String query) {
    if (query.isEmpty) {
      state = state.copyWith(productList: state.originalList);
    } else {
      final filtered = state.originalList.where((order) {
        final name = order['name'].toString().toLowerCase();
        final id = order['id'].toString();
        return name.contains(query.toLowerCase()) || id.contains(query);
      }).toList();
      state = state.copyWith(productList: filtered);
    }
  }

  void callUpdateAction(SellerMainScreenGlobalStateNotifier notifier) {
    // Navigates to the packed screen as requested
    notifier.callNavigation(ScreenName.confirmPacked);
  }
}

final sellerConfirmOrderScreenStateProvider = StateNotifierProvider.autoDispose<
    SellerConfirmOrderScreenStateNotifier, SellerConfirmOrderScreenState>((ref) {
  return SellerConfirmOrderScreenStateNotifier();
});