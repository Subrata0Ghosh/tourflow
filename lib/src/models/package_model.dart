import 'package:equatable/equatable.dart';
import 'itinerary_model.dart';

class TourPackage extends Equatable {
  final String id;
  final String title;
  final String location;
  final String description;
  final double pricePerPerson;
  final int days;
  final List<ItineraryDay> itinerary;

  const TourPackage({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.pricePerPerson,
    required this.days,
    required this.itinerary,
  });

  TourPackage copyWith({List<ItineraryDay>? itinerary}) {
    return TourPackage(
      id: id,
      title: title,
      location: location,
      description: description,
      pricePerPerson: pricePerPerson,
      days: days,
      itinerary: itinerary ?? this.itinerary,
    );
  }

  @override
  List<Object?> get props => [id, title, location, pricePerPerson, days];
}
