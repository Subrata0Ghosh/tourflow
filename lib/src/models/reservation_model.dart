import 'package:equatable/equatable.dart';
import 'package:tourflow/src/models/package_model.dart';

class Reservation extends Equatable {
  final String id;
  final TourPackage tourPackage;
  final int travelers;
  final List<String> travelerNames;
  final DateTime createdAt;
  final String notes;

  const Reservation({
    required this.id,
    required this.tourPackage,
    required this.travelers,
    required this.travelerNames,
    required this.createdAt,
    this.notes = '',
  });

  @override
  List<Object?> get props => [id, tourPackage.id, travelers, travelerNames];
}
