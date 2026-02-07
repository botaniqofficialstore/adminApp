import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:botaniq_admin/Screens/SellerScreens/SellerMainScreen/SellerMainScreenState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import '../../../../Constants/Constants.dart';
import 'SellerRevenueScreenState.dart';

class SellerRevenueScreen extends ConsumerWidget {
  const SellerRevenueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sellerRevenueScreenStateProvider);
    final notifier = ref.read(sellerRevenueScreenStateProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // optional
        statusBarIconBrightness: Brightness.light, // ANDROID → black icons
        statusBarBrightness: Brightness.dark, // iOS → black icons
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [

              headerView(context, ref),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildHeaderFilters(context, state, notifier),
                      SizedBox(height: 10.dp),

                      // 1. Total Revenue Widget
                      _buildTotalRevenueWidget(context, state),
                      SizedBox(height: 20.dp),

                      // 2. Chart Section
                      _buildChartSection(context, state, notifier),
                      SizedBox(height: 20.dp),

                      // 3. Transactions List
                      _buildOrderList(context, state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget headerView(BuildContext context, WidgetRef ref){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 5.dp),
      child: Row(
        children: [
          CupertinoButton(
              minimumSize: Size(0, 0),
              padding: EdgeInsets.zero,
              child: Icon(Icons.arrow_back_ios, size: 15.dp, color: Colors.white,),
              onPressed: (){
                var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callNavigation(ScreenName.home);
              }),
          SizedBox(width: 2.5.dp),
          objCommonWidgets.customText(context, 'Revenue Analysis', 15, Colors.white, objConstantFonts.montserratSemiBold)
        ],
      ),
    );
  }



  Widget _buildTotalRevenueWidget(
      BuildContext context,
      SellerRevenueScreenState state,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 15.dp),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1B), Color(0xFF2D2D2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.dp),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withAlpha(25),
                        radius: 18.dp,
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 18.dp,
                        ),
                      ),
                      SizedBox(width: 8.dp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          objCommonWidgets.customText(
                            context,
                            'Total Revenue',
                            12,
                            Colors.white,
                            objConstantFonts.montserratMedium,
                          ),
                          objCommonWidgets.customText(
                            context,
                            '12 Dec - 19 Dec 2025',
                            10,
                            Colors.white70,
                            objConstantFonts.montserratMedium,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10.dp),

                  /// Revenue + Orders
                  Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        '₹${state.totalRevenue.toStringAsFixed(2)}',
                        23,
                        Colors.green,
                        objConstantFonts.montserratSemiBold,
                      ),

                      const Spacer(), // 🔥 THIS FIXES IT

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          objCommonWidgets.customText(
                            context,
                            '${state.totalOrders}',
                            18,
                            Colors.yellowAccent,
                            objConstantFonts.montserratSemiBold,
                          ),
                          objCommonWidgets.customText(
                            context,
                            'Total Orders',
                            10,
                            Colors.white,
                            objConstantFonts.montserratMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }





  Widget _buildChartSection(
      BuildContext context,
      SellerRevenueScreenState state,
      SellerRevenueScreenStateNotifier notifier) {
    double chartWidth = state.chartPoints.length * 70.0;
    if (chartWidth < 400) chartWidth = 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.dp),
          child: objCommonWidgets.customText(
            context,
            'Revenue Chart',
            15,
            Colors.white,
            objConstantFonts.montserratSemiBold,
          ),
        ),

        SizedBox(height: 5.dp),

        Container(
          height: 400.dp,
          padding: EdgeInsets.symmetric(vertical: 25.dp, horizontal: 15.dp),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      if (event is FlTapDownEvent && touchResponse?.lineBarSpots != null) {
                        notifier.togglePoint(touchResponse!.lineBarSpots![0].spotIndex);
                      }
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.white,
                      tooltipBorderRadius: BorderRadius.circular(5.dp),
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final pt = state.chartPoints[touchedSpot.spotIndex];
                          return LineTooltipItem(
                            "📦 Orders: ${pt.orderCount}\n",
                            TextStyle(color: Colors.black, fontFamily: objConstantFonts.montserratSemiBold, fontSize: 10.dp),
                            children: [
                              TextSpan(
                                text: "💰 Revenue: ₹${pt.dailyRevenue.toInt()}/_",
                                style: TextStyle(color: Colors.black, fontFamily: objConstantFonts.montserratSemiBold, fontSize: 10.dp),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(color: Colors.white10, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (v, m) => objCommonWidgets.customText(context, v.toInt().toString(), 7, Colors.white, objConstantFonts.montserratMedium),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx < 0 || idx >= state.chartPoints.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: objCommonWidgets.customText(context, state.chartPoints[idx].label, 7, Colors.white, objConstantFonts.montserratMedium),
                          );
                        },
                      ),
                    ),
                  ),
                  //borderData: FlBorderData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Colors.white, width: 0.5),
                      bottom: BorderSide(color: Colors.white, width: 0.5),
                      top: BorderSide.none,
                      right: BorderSide.none,
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      spots: state.chartPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
                      isCurved: true,
                      curveSmoothness: 0.1,
                      barWidth: 1,
                      isStrokeCapRound: true,
                      color: Colors.green,
                      // Gradient color logic (Red for start, Green for end growth)
                      //gradient: const LinearGradient(colors: [Colors.redAccent, Color(0xFF00FFA3)]),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                          radius: state.selectedPointIndex == index ? 6 : 3,
                          color: state.selectedPointIndex == index ? Colors.yellowAccent : Colors.white,

                        ),
                      ),

                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),

                  ],

                  // Logic to show/hide the marker based on state
                  showingTooltipIndicators: state.selectedPointIndex != null
                      ? [
                    ShowingTooltipIndicators([
                      LineBarSpot(
                        LineChartBarData(spots: state.chartPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList()),
                        0,
                        FlSpot(state.selectedPointIndex!.toDouble(), state.chartPoints[state.selectedPointIndex!].value),
                      ),
                    ])
                  ]
                      : [],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderFilters(BuildContext context, SellerRevenueScreenState state, SellerRevenueScreenStateNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 10),
      child: Row(
        children: RevenueFilter.values.map((f) {
          bool isSelected = state.filter == f;
          return Expanded(
            child: CupertinoButton(
              onPressed: () => notifier.setFilter(f),
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.dp),
                padding: EdgeInsets.symmetric(vertical: 10.dp),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(8.dp),
                ),
                child: Center(
                  child: objCommonWidgets.customText(
                      context,
                      f.name
                          .replaceAll('last', '')
                          .toLowerCase()
                          .replaceFirstMapped(
                        RegExp(r'^[a-z]'),
                            (m) => m.group(0)!.toUpperCase(),
                      ),
                      12,
                      isSelected ? Colors.white : Colors.black, objConstantFonts.montserratSemiBold)
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, SellerRevenueScreenState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
              context,
              'Order Revenue Transactions',
              13,
              Colors.white, objConstantFonts.montserratSemiBold),
          SizedBox(height: 10.dp),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10.dp),
                padding: EdgeInsets.all(10.dp),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF323233), Color(0xFF2D2D2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.dp),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.dp),
                      decoration: BoxDecoration(color: Colors.white.withAlpha(20), borderRadius: BorderRadius.circular(10.dp)),
                      child: Icon(Icons.receipt_long, color: Colors.white, size: 20.dp),
                    ),
                    SizedBox(width: 10.dp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          objCommonWidgets.customText(
                              context,
                              order.id,
                              10,
                              Colors.white, objConstantFonts.montserratSemiBold),
                          objCommonWidgets.customText(
                              context,
                              DateFormat('₹${order.amount}/_').format(order.date),
                              15,
                              Colors.green, objConstantFonts.montserratSemiBold),


                        ],
                      ),
                    ),



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4.dp, horizontal: 7.dp),
                             decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(5.dp),
                              ),

                              child: objCommonWidgets.customText(
                                  context,
                                  'View Details',
                                  8,
                                  Colors.black, objConstantFonts.montserratSemiBold),
                            ),
                            onPressed: (){}
                        ),
                        SizedBox(height: 2.dp),
                        objCommonWidgets.customText(
                            context,
                            DateFormat('dd MMM yyyy, hh:mm a').format(order.date),
                            8,
                            Colors.white, objConstantFonts.montserratMedium),
                      ],
                    ),


                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

