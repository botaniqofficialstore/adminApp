import 'package:botaniq_admin/CommonPopupViews/OrderDetailsPopupView/OrderDetailsPopupView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RevenueFilter { lastWeek, lastMonth, lastYear }

class OrderModel {
  final String id;
  final DateTime date;
  final double amount;
  OrderModel({required this.id, required this.date, required this.amount});
}

class ChartPoint {
  final double value;
  final String label;
  final int orderCount;
  final double dailyRevenue;
  ChartPoint({required this.value, required this.label, required this.orderCount, required this.dailyRevenue});
}

class SellerRevenueScreenState {
  final RevenueFilter filter;
  final List<OrderModel> orders;
  final List<ChartPoint> chartPoints;
  final int? selectedPointIndex;

  SellerRevenueScreenState({
    this.filter = RevenueFilter.lastWeek,
    this.orders = const [],
    this.chartPoints = const [],
    this.selectedPointIndex,
  });

  double get totalRevenue => chartPoints.fold(0, (sum, item) => sum + item.dailyRevenue);
  int get totalOrders => chartPoints.fold(0, (sum, item) => sum + item.orderCount);

  SellerRevenueScreenState copyWith({
    RevenueFilter? filter,
    List<OrderModel>? orders,
    List<ChartPoint>? chartPoints,
    int? selectedPointIndex,
    bool clearSelection = false,
  }) {
    return SellerRevenueScreenState(
      filter: filter ?? this.filter,
      orders: orders ?? this.orders,
      chartPoints: chartPoints ?? this.chartPoints,
      selectedPointIndex: clearSelection ? null : (selectedPointIndex ?? this.selectedPointIndex),
    );
  }
}

class SellerRevenueScreenStateNotifier extends StateNotifier<SellerRevenueScreenState> {
  SellerRevenueScreenStateNotifier() : super(SellerRevenueScreenState()) {
    setFilter(RevenueFilter.lastWeek);
  }

  void setFilter(RevenueFilter filter) {
    List<ChartPoint> points = [];
    DateTime now = DateTime.now();
    int count = filter == RevenueFilter.lastWeek ? 7 : (filter == RevenueFilter.lastMonth ? 30 : 12);

    for (int i = count; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      double val = 200.0 + (i * 15) + (i % 3 == 0 ? 100 : -50);
      points.add(ChartPoint(
        value: val,
        label: "${date.day.toString().padLeft(2, '0')} ${_getMonth(date.month)}",
        orderCount: (val / 15).round() + 5,
        dailyRevenue: val * 4,
      ));
    }

    state = state.copyWith(
      filter: filter,
      chartPoints: points,
      clearSelection: true,
      orders: List.generate(8, (index) => OrderModel(
        id: "#897552${89747845 + index}",
        date: DateTime.now().subtract(Duration(hours: index * 2)),
        amount: 120 + index * 45,
      )),
    );
  }

  void togglePoint(int index) {
    if (state.selectedPointIndex == index) {
      state = state.copyWith(clearSelection: true);
    } else {
      state = state.copyWith(selectedPointIndex: index);
    }
  }

  String _getMonth(int m) {
    return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][m - 1];
  }

  void callDetailPopupView(BuildContext context){
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const OrderDetailsPopupView(),
      ),
    );

  }

}

final sellerRevenueScreenStateProvider = StateNotifierProvider.autoDispose<
    SellerRevenueScreenStateNotifier, SellerRevenueScreenState>((ref) => SellerRevenueScreenStateNotifier());