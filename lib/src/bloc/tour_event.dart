import 'package:equatable/equatable.dart';
// import '../models/package_model.dart';
import '../models/itinerary_model.dart';
// import '../models/reservation_model.dart';

abstract class TourEvent extends Equatable {
  const TourEvent();
  @override
  List<Object?> get props => [];
}

class LoadPackages extends TourEvent {}

class SelectPackage extends TourEvent {
  final String packageId;
  const SelectPackage(this.packageId);
  @override
  List<Object?> get props => [packageId];
}

class UpdateItinerary extends TourEvent {
  final String packageId;
  final List<ItineraryDay> itinerary;
  const UpdateItinerary(this.packageId, this.itinerary);
  @override
  List<Object?> get props => [packageId, itinerary];
}

class MakeReservation extends TourEvent {
  final String packageId;
  final int travelers;
  final List<String> travelerNames;
  final String notes;
  const MakeReservation({
    required this.packageId,
    required this.travelers,
    required this.travelerNames,
    this.notes = '',
  });

  @override
  List<Object?> get props => [packageId, travelers, travelerNames, notes];
}
