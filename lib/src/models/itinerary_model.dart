import 'package:equatable/equatable.dart';

class ItineraryActivity extends Equatable {
  final String id;
  final String title;
  final String notes;
  final int durationMins;

  const ItineraryActivity({
    required this.id,
    required this.title,
    this.notes = '',
    this.durationMins = 60,
  });

  ItineraryActivity copyWith({String? notes, int? durationMins}) {
    return ItineraryActivity(
      id: id,
      title: title,
      notes: notes ?? this.notes,
      durationMins: durationMins ?? this.durationMins,
    );
  }

  @override
  List<Object?> get props => [id, title, notes, durationMins];
}

class ItineraryDay extends Equatable {
  final int dayIndex;
  final List<ItineraryActivity> activities;

  const ItineraryDay({required this.dayIndex, required this.activities});

  ItineraryDay copyWith({List<ItineraryActivity>? activities}) {
    return ItineraryDay(
      dayIndex: dayIndex,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [dayIndex, activities];
}
