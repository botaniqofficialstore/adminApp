import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../Utility/Logger.dart';
import '../../../../Utility/CalendarFilterPopup.dart';

class SellerCompletedDeliveryScreenState {
  final List<bool> packedList;
  final String packagePhoto;
  final TextEditingController searchController;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? filterType;
  final List<Map<String, dynamic>> productList;

  SellerCompletedDeliveryScreenState({
    required this.packedList,
    required this.packagePhoto,
    required this.searchController,
    this.filterStartDate,
    this.filterEndDate,
    this.filterType,
    required this.productList,
  });



  SellerCompletedDeliveryScreenState copyWith({
    List<bool>? packedList,
    String? packagePhoto,
    TextEditingController? searchController,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? filterType,
    List<Map<String, dynamic>>? productList,
  }) {
    return SellerCompletedDeliveryScreenState(
        packedList: packedList ?? this.packedList,
        packagePhoto: packagePhoto ?? this.packagePhoto,
      searchController: searchController ?? this.searchController,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterType: filterType ?? this.filterType,
      productList: productList ?? this.productList,
    );
  }
}

class SellerCompletedDeliveryScreenStateNotifier
    extends StateNotifier<SellerCompletedDeliveryScreenState> {
  SellerCompletedDeliveryScreenStateNotifier()
      : super(SellerCompletedDeliveryScreenState(
      packedList: List.generate(2, (_) => false), packagePhoto: '', searchController: TextEditingController(), filterStartDate: null,
      filterEndDate: null,
      filterType: '',
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

  ///This method is used to get start and end date for filter
  void getFilteredDate(DateFilterType filterType) {
    final filterDates = CodeReusability().getDateRange(filterType);
    final filterLabel = getDateFilterLabel(filterType);

    state = state.copyWith(
        filterStartDate: filterDates.start,
        filterEndDate: filterDates.end,
        filterType: filterLabel
    );

    Logger().log("------> ${filterDates.start} to ${filterDates.end}");
  }

  void updateCustomRangeTitle(DateRangeResult? result){
    final selectedDateRange = CodeReusability().formatDateRange(
      result!.start,
      result.end,
    );
    state = state.copyWith(filterType: selectedDateRange);
  }

  ///This method is used to get selected filter type
  String getDateFilterLabel(DateFilterType type) {
    switch (type) {
      case DateFilterType.today:
        return 'Today';
      case DateFilterType.last7Days:
        return 'Last 7 Days';
      case DateFilterType.last6Months:
        return 'Last 6 Months';
      case DateFilterType.lastYear:
        return 'Last 1 Year';
      case DateFilterType.customRange:
        return 'Custom Range';
    }
  }


}

final sellerCompletedDeliveryScreenStateProvider =
StateNotifierProvider.autoDispose<
    SellerCompletedDeliveryScreenStateNotifier,
    SellerCompletedDeliveryScreenState>((ref) {
  return SellerCompletedDeliveryScreenStateNotifier();
});



