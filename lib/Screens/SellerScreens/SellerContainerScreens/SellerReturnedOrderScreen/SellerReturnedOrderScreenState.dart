import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../Utility/Logger.dart';
import '../../../../Utility/CalendarFilterPopup.dart';

class SellerReturnedOrderScreenState {
  final List<bool> packedList;
  final String packagePhoto;
  final TextEditingController searchController;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? filterType;

  SellerReturnedOrderScreenState({
    required this.packedList,
    required this.packagePhoto,
    required this.searchController,
    this.filterStartDate,
    this.filterEndDate,
    this.filterType,
  });



  SellerReturnedOrderScreenState copyWith({
    List<bool>? packedList,
    String? packagePhoto,
    TextEditingController? searchController,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? filterType,
  }) {
    return SellerReturnedOrderScreenState(
      packedList: packedList ?? this.packedList,
      packagePhoto: packagePhoto ?? this.packagePhoto,
      searchController: searchController ?? this.searchController,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterType: filterType ?? this.filterType,
    );
  }
}

class SellerReturnedOrderScreenStateNotifier
    extends StateNotifier<SellerReturnedOrderScreenState> {
  SellerReturnedOrderScreenStateNotifier()
      : super(SellerReturnedOrderScreenState(
      packedList: List.generate(2, (_) => false), packagePhoto: '', searchController: TextEditingController(), filterStartDate: null,
      filterEndDate: null,
      filterType: ''));

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


  Future<void> makePhoneCall(String phoneNumber) async {
    // The 'tel:' prefix is essential for phone calls
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle the error gracefully (e.g., show a SnackBar)
      throw 'Could not launch $launchUri';
    }
  }


}

final SellerReturnedOrderScreenStateProvider =
StateNotifierProvider.autoDispose<
    SellerReturnedOrderScreenStateNotifier,
    SellerReturnedOrderScreenState>((ref) {
  return SellerReturnedOrderScreenStateNotifier();
});



