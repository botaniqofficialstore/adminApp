
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Utility/CalendarFilterPopup.dart';

class ScheduledDeliveryScreenState {
  final TextEditingController searchController;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  ScheduledDeliveryScreenState({
    required this.searchController,
    this.filterStartDate,
    this.filterEndDate,
  });

  ScheduledDeliveryScreenState copyWith({
    TextEditingController? searchController,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
  }) {
    return ScheduledDeliveryScreenState(
      searchController: searchController ?? this.searchController,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
    );
  }
}


class ScheduledDeliveryScreenStateNotifier
    extends StateNotifier<ScheduledDeliveryScreenState> {
  ScheduledDeliveryScreenStateNotifier() : super(ScheduledDeliveryScreenState(
      searchController: TextEditingController(),
      filterStartDate: null,
      filterEndDate: null)
  );

  @override
  void dispose() {
    super.dispose();
  }



  String dateLocalFormat(DateTime d) => "${d.day}/${d.month}/${d.year}";


  void setDefaultDates() {
    final DateTime now = DateTime.now();

    final DateTime startDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime endDate = startDate.add(const Duration(days: 8));

    state = state.copyWith(
      filterStartDate: startDate,
      filterEndDate: endDate,
    );

    Logger().log("------> $startDate to $endDate");
  }


  void updateDateRange(DateRangeResult? result){
    state = state.copyWith(filterStartDate: result?.start,filterEndDate: result?.end);
  }


}

final ScheduledDeliveryScreenStateProvider = StateNotifierProvider.autoDispose<
    ScheduledDeliveryScreenStateNotifier, ScheduledDeliveryScreenState>((ref) {
  var notifier = ScheduledDeliveryScreenStateNotifier();
  return notifier;
});
