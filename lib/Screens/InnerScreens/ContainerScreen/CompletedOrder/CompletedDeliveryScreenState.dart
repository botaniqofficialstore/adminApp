
import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/constants/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Utility/Logger.dart';

class CompletedDeliveryScreenState {
  final TextEditingController searchController;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? filterType;

  CompletedDeliveryScreenState({
    required this.searchController,
    this.filterStartDate,
    this.filterEndDate,
    this.filterType,
  });

  CompletedDeliveryScreenState copyWith({
    TextEditingController? searchController,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? filterType,
  }) {
    return CompletedDeliveryScreenState(
      searchController: searchController ?? this.searchController,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterType: filterType ?? this.filterType,
    );
  }
}

class CompletedDeliveryScreenStateNotifier
    extends StateNotifier<CompletedDeliveryScreenState> {
  CompletedDeliveryScreenStateNotifier() : super(CompletedDeliveryScreenState(searchController: TextEditingController(),
      filterStartDate: null,
      filterEndDate: null,
  filterType: ''));

  @override
  void dispose() {
    super.dispose();
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

  void updateCustomRangeTitle(DateFilterType filterType){
    final filterLabel = getDateFilterLabel(filterType);
    state = state.copyWith(filterType: filterLabel);
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

final CompletedDeliveryScreenStateProvider = StateNotifierProvider.autoDispose<
    CompletedDeliveryScreenStateNotifier, CompletedDeliveryScreenState>((ref) {
  var notifier = CompletedDeliveryScreenStateNotifier();
  return notifier;
});
