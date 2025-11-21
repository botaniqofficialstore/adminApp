
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'RevenueScreen.dart';


class RevenueScreenState {
  final String currentRange;
  final double totalIncome;
  final double percentageGrowth;


  RevenueScreenState({
    this.currentRange = 'weekly',
    this.totalIncome = 0.0,
    this.percentageGrowth = 0.0,
  });


  RevenueScreenState copyWith({
    String? currentRange,
    double? totalIncome,
    double? percentageGrowth,
  }) {
    return RevenueScreenState(
      currentRange: currentRange ?? this.currentRange,
      totalIncome: totalIncome ?? this.totalIncome,
      percentageGrowth: percentageGrowth ?? this.percentageGrowth,
    );
  }
}

class RevenueScreenStateNotifier
    extends StateNotifier<RevenueScreenState> {
  RevenueScreenStateNotifier() : super(RevenueScreenState());

  @override
  void dispose() {
    super.dispose();
  }

  void changeRange(String range) {
    if (range == 'weekly') {
      state = state.copyWith(
        currentRange: 'weekly',
        totalIncome: 12450.75,
        percentageGrowth: 12.4,
      );
    } else if (range == 'monthly') {
      state = state.copyWith(
        currentRange: 'monthly',
        totalIncome: 54230.90,
        percentageGrowth: 8.2,
      );
    } else if (range == 'yearly') {
      state = state.copyWith(
        currentRange: 'yearly',
        totalIncome: 654320.00,
        percentageGrowth: 18.7,
      );
    }
  }


  List<RevenueData> getChartData() {
    switch (state.currentRange) {
      case 'weekly':
        return [
          RevenueData('1 Jan', 1200),
          RevenueData('2 Jan', 1500),
          RevenueData('3 Jan', 1100),
          RevenueData('4 Jan', 1800),
          RevenueData('5 Jan', 2000),
          RevenueData('6 Jan', 2400),
          RevenueData('7 Jan', 2100),
        ];
      case 'monthly':
        return [
          RevenueData('Aug', 5500),
          RevenueData('Sep', 6800),
          RevenueData('Oct', 7200),
          RevenueData('Nov', 8100),
        ];
      case 'yearly':
        return [
          RevenueData('Jan', 45000),
          RevenueData('Feb', 47000),
          RevenueData('Mar', 52000),
          RevenueData('Apr', 58000),
          RevenueData('May', 60000),
          RevenueData('Jun', 62000),
          RevenueData('Jul', 65000),
          RevenueData('Aug', 68000),
          RevenueData('Sep', 70000),
          RevenueData('Oct', 72000),
          RevenueData('Nov', 75000),
          RevenueData('Dec', 78000),
        ];
      default:
        return [];
    }
  }


}

final RevenueScreenStateProvider = StateNotifierProvider.autoDispose<
    RevenueScreenStateNotifier, RevenueScreenState>((ref) {
  var notifier = RevenueScreenStateNotifier();
  return notifier;
});
