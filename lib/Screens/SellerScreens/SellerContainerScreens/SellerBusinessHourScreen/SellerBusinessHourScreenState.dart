import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessDay {
  final TimeOfDay open;
  final TimeOfDay close;
  final bool isClosed;

  BusinessDay({required this.open, required this.close, this.isClosed = false});

  BusinessDay copyWith({TimeOfDay? open, TimeOfDay? close, bool? isClosed}) =>
      BusinessDay(open: open ?? this.open, close: close ?? this.close, isClosed: isClosed ?? this.isClosed);
}

class SellerBusinessHourState {
  final Map<String, BusinessDay> schedule;
  SellerBusinessHourState({required this.schedule});

  SellerBusinessHourState copyWith({Map<String, BusinessDay>? schedule}) =>
      SellerBusinessHourState(schedule: schedule ?? this.schedule);
}

class SellerBusinessHourNotifier extends StateNotifier<SellerBusinessHourState> {
  SellerBusinessHourNotifier() : super(SellerBusinessHourState(schedule: {
    'Monday': BusinessDay(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 17, minute: 0)),
    'Tuesday': BusinessDay(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 17, minute: 0)),
    'Wednesday': BusinessDay(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 17, minute: 0)),
    'Thursday': BusinessDay(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 17, minute: 0)),
    'Friday': BusinessDay(open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 17, minute: 0)),
    'Saturday': BusinessDay(open: const TimeOfDay(hour: 10, minute: 0), close: const TimeOfDay(hour: 14, minute: 0)),
    'Sunday': BusinessDay(open: const TimeOfDay(hour: 0, minute: 0), close: const TimeOfDay(hour: 0, minute: 0), isClosed: true),
  }));

  void updateDay(String day, {TimeOfDay? open, TimeOfDay? close, bool? isClosed}) {
    state = state.copyWith(schedule: {...state.schedule, day: state.schedule[day]!.copyWith(open: open, close: close, isClosed: isClosed)});
  }

  void syncMondayToAll() {
    final mon = state.schedule['Monday']!;
    state = state.copyWith(schedule: state.schedule.map((k, v) => MapEntry(k, mon)));
  }
}

final sellerBusinessHourProvider = StateNotifierProvider.autoDispose<SellerBusinessHourNotifier, SellerBusinessHourState>((ref) => SellerBusinessHourNotifier());