import 'dart:ffi';

import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import '../../MainScreen/MainScreen.dart';
import 'RevenueScreenState.dart';

class RevenueScreen extends ConsumerStatefulWidget {
  const RevenueScreen({super.key});

  @override
  RevenueScreenState createState() => RevenueScreenState();
}

class RevenueScreenState extends ConsumerState<RevenueScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> revenueTypeList = [
    {'title': 'Product Revenue', 'income': 10599.45},
    {'title': 'Delivery Revenue', 'income': 1499.23},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      var notifier = ref.watch(RevenueScreenStateProvider.notifier);
      notifier.changeRange('weekly');
    });
  }



  @override
  Widget build(BuildContext context) {
    var state = ref.watch(RevenueScreenStateProvider);
    var notifier = ref.watch(RevenueScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.dp),

                // HEADER
                Row(
                  children: [
                    objCommonWidgets.customText(
                      context,
                      'Revenue',
                      23,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Image.asset(
                        objConstantAssest.menuIcon,
                        height: 25.dp,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      onPressed: () => mainScaffoldKey.currentState?.openDrawer(),
                    )
                  ],
                ),

                SizedBox(height: 10.dp),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        // FILTER BUTTONS (Weekly, Monthly, Yearly)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _rangeButton('Weekly', state.currentRange == 'weekly', () => notifier.changeRange('weekly')),
                            _rangeButton('Monthly', state.currentRange == 'monthly', () => notifier.changeRange('monthly')),
                            _rangeButton('Yearly', state.currentRange == 'yearly', () => notifier.changeRange('yearly')),
                          ],
                        ),

                        SizedBox(height: 20.dp),

                        // REVENUE SUMMARY CARD
                        _summaryCard('Total Revenue', state.totalIncome, state.percentageGrowth, 26),

                        SizedBox(height: 20.dp),

                        GridView.builder(
                          shrinkWrap: true,                              // FIX
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: revenueTypeList.length,
                          itemBuilder: (context, index) {
                            final title = revenueTypeList[index]['title'] ?? '';

                            return _summaryCard(title, double.tryParse('${revenueTypeList[index]['income']}') ?? 0.0, state.percentageGrowth, 20);
                          },
                        ),

                        SizedBox(height: 20.dp),

                        // CHART
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.dp),
                          ),
                          padding: EdgeInsets.all(12.dp),
                          child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePanning: true,      // <-- Enable horizontal scroll
                              enablePinching: true,     // Optional: pinch zoom
                              zoomMode: ZoomMode.x,     // Only horizontal zooming
                            ),
                              primaryXAxis: CategoryAxis(
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                majorGridLines: const MajorGridLines(width: 0),

                                // ⭐ Important for scrolling
                                autoScrollingMode: AutoScrollingMode.start,
                                autoScrollingDelta: 7,   // Show only 7 points at a time (weekly size)
                              ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                              axisLine: const AxisLine(width: 0),
                              majorGridLines: MajorGridLines(color: Colors.white.withOpacity(0.1)),
                            ),
                            legend: Legend(isVisible: false),
                            series: <CartesianSeries>[
                              SplineAreaSeries<RevenueData, String>(
                                dataSource: notifier.getChartData(),
                                xValueMapper: (rev, _) => rev.label,
                                yValueMapper: (rev, _) => rev.amount,
                                gradient: LinearGradient(
                                  colors: [Colors.greenAccent, Colors.transparent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderColor: Colors.greenAccent,
                                borderWidth: 3,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.dp),

                        Row(
                          children: [
                            revenueCard(context, 'Pre-Order Revenue', '1599'),
                          ],
                        ),



                        SizedBox(height: 50.dp),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rangeButton(String label, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.dp),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 18.dp),
          decoration: BoxDecoration(
            color: isActive ? Colors.greenAccent : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30.dp),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white,
              fontSize: 15.dp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double income, double growth, double fontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.dp),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.dp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(context, title,
              12.5,
              Colors.white70,
              objConstantFonts.montserratMedium),
          SizedBox(height: 5.dp),
          objCommonWidgets.customText(context, "₹${income.toStringAsFixed(2)}",
              fontSize,
              objConstantColor.white,
              objConstantFonts.montserratSemiBold),
          SizedBox(height: 8.dp),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.top, // keeps icon at first line
                  child: Icon(
                    growth >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: growth >= 0 ? Colors.greenAccent : Colors.redAccent,
                    size: 16.dp,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5.dp)),
                TextSpan(
                  text: "${growth.toStringAsFixed(1)}% from last period",
                  style: TextStyle(
                    fontSize: 13.dp,
                    color: growth >= 0 ? Colors.greenAccent : Colors.redAccent,
                    fontFamily: objConstantFonts.montserratMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget revenueCard(BuildContext context, String title, String value){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.dp),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.dp, right: 20.dp, top: 20.dp, bottom: 10.dp),      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            objCommonWidgets.customText(context, title,
                15,
                Colors.white,
                objConstantFonts.montserratMedium),
            SizedBox(height: 5.dp),
            objCommonWidgets.customText(context, "Order's still not delivered.",
                10,
                Colors.white70,
                objConstantFonts.montserratMedium),
            SizedBox(height: 30.dp),
            objCommonWidgets.customText(context, "₹$value",
                20,
                objConstantColor.white,
                objConstantFonts.montserratSemiBold),
          ],
        ),
      ),
    );
  }

}

class RevenueData {
  final String label;
  final double amount;
  RevenueData(this.label, this.amount);
}
