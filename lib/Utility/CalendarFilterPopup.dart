import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Constants/ConstantVariables.dart';


class CalendarFilterPopup extends StatefulWidget {
  const CalendarFilterPopup({super.key});

  @override
  State<CalendarFilterPopup> createState() => CalendarFilterPopupState();
}

class CalendarFilterPopupState extends State<CalendarFilterPopup> {
  DateTime? start;
  DateTime? end;

  /// Today (local – start of day)
  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// ✅ End of NEXT FULL MONTH
  DateTime get _lastAllowedDate {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 2, 0);
    return DateTime(nextMonth.year, nextMonth.month, nextMonth.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    if (start == null) return false;
    if (end == null) return _isSameDay(day, start!);
    return day.isAfter(start!.subtract(const Duration(days: 1))) &&
        day.isBefore(end!.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.dp),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.dp),
        child: Container(
          padding: EdgeInsets.all(16.dp),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(24.dp),
            border: Border.all(color: Colors.white.withAlpha(65)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// TITLE
              objCommonWidgets.customText(
                context,
                'Filter by Date',
                15,
                objConstantColor.yellow,
                objConstantFonts.montserratSemiBold,
              ),

              SizedBox(height: 12.dp),
              Divider(color: Colors.white.withAlpha(60)),




              /// MODERN CALENDAR
              TableCalendar(
                firstDay: _today,
                lastDay: _lastAllowedDate,
                focusedDay: start ?? _today,

                rangeStartDay: start,
                rangeEndDay: end,
                rangeSelectionMode: RangeSelectionMode.toggledOn,

                availableGestures: AvailableGestures.horizontalSwipe,

                /// ✅ Disable only past days
                enabledDayPredicate: (day) => !day.isBefore(_today),

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    start = selectedDay;
                    end = null;
                  });
                },

                onRangeSelected: (startDay, endDay, focusedDay) {
                  setState(() {
                    start = startDay;
                    end = endDay;
                  });
                },

                /// 🔹 HEADER (MONTH + ARROWS)
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,

                  titleTextStyle: TextStyle(
                    color: Colors.white,        // ✅ Month & year text
                    fontSize: 14.dp,
                    fontFamily: objConstantFonts.montserratSemiBold
                  ),

                  leftChevronIcon: Icon(
                    Icons.keyboard_double_arrow_left,
                    color: objConstantColor.white,        // ✅ Arrow white
                  ),
                  rightChevronIcon: Icon(
                    Icons.keyboard_double_arrow_right,
                    color: objConstantColor.white,        // ✅ Arrow white
                  ),
                ),

                /// 🔹 WEEK DAYS (SUN MON TUE…)
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.white,        // ✅ Weekdays white
                      fontSize: 12.dp,
                      fontFamily: objConstantFonts.montserratMedium
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.white,        // ✅ Weekend labels white
                      fontSize: 12.dp,
                      fontFamily: objConstantFonts.montserratMedium
                  ),
                ),

                /// 🔹 DAY CELL STYLING
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,

                  /// Past days
                  disabledTextStyle: TextStyle(
                    color: Colors.grey,         // ✅ Past days gray
                      fontSize: 12.dp,
                      fontFamily: objConstantFonts.montserratMedium
                  ),

                  /// Default future days (including Sat & Sun)
                  defaultTextStyle: TextStyle(
                    color: Colors.white,        // ✅ Future days white
                      fontSize: 13.dp,
                      fontFamily: objConstantFonts.montserratMedium
                  ),
                  weekendTextStyle:  TextStyle(
                    color: Colors.white,        // ✅ Future weekends white
                      fontSize: 13.dp,
                      fontFamily: objConstantFonts.montserratMedium
                  ),

                  /// Today (not selected)
                  todayDecoration: const BoxDecoration(
                    color: Colors.white,        // ✅ White circle
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.black,
                      fontSize: 13.dp,
                      fontFamily: objConstantFonts.montserratSemiBold
                  ),

                  /// Selected single day
                  selectedDecoration: BoxDecoration(
                    color: objConstantColor.yellow,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.black,
                      fontSize: 13.dp,
                      fontFamily: objConstantFonts.montserratSemiBold
                  ),

                  /// Range highlight (middle days)
                  rangeHighlightColor:
                  objConstantColor.yellow.withOpacity(0.35),

                  /// Range start
                  rangeStartDecoration: BoxDecoration(
                    color: objConstantColor.yellow,
                    shape: BoxShape.circle,
                  ),
                  rangeStartTextStyle: TextStyle(
                    color: Colors.black,
                      fontSize: 13.dp,
                      fontFamily: objConstantFonts.montserratSemiBold
                  ),

                  /// Range end
                  rangeEndDecoration: BoxDecoration(
                    color: objConstantColor.yellow,
                    shape: BoxShape.circle,
                  ),
                  rangeEndTextStyle: TextStyle(
                    color: Colors.black,
                      fontSize: 13.dp,
                      fontFamily: objConstantFonts.montserratSemiBold
                  ),
                ),
              ),




              SizedBox(height: 14.dp),

              /// ACTION BUTTONS
              Row(
                children: [

                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.dp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.dp),
                        ),
                        child: Center(
                          child: objCommonWidgets.customText(
                            context,
                            'Cancel',
                            13,
                            Colors.black,
                            objConstantFonts.montserratMedium,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.dp),

                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: start == null
                          ? null
                          : () {
                        /// ✅ RETURN UTC DATES
                        Navigator.pop(
                          context,
                          DateRangeResult(
                            start!.toUtc(),
                            end?.toUtc(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.dp),
                        decoration: BoxDecoration(
                          color: objConstantColor.yellow,
                          borderRadius: BorderRadius.circular(20.dp),
                        ),
                        child: Center(
                          child: objCommonWidgets.customText(
                            context,
                            'Apply',
                            13,
                            Colors.black,
                            objConstantFonts.montserratSemiBold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ UTC SAFE RESULT
class DateRangeResult {
  final DateTime start;
  final DateTime? end;

  DateRangeResult(this.start, this.end);
}
