import 'dart:async';
import 'package:tourflow/src/models/package_model.dart';
import 'package:tourflow/src/models/itinerary_model.dart';
import 'package:tourflow/src/models/reservation_model.dart';
import 'package:uuid/uuid.dart';

class TourRepository {
  final _uuid = const Uuid();

  Future<List<TourPackage>> fetchPackages() async {
    // keep a small delay to simulate network but fast for tests
    await Future.delayed(const Duration(milliseconds: 50));
    final pkg1 = TourPackage(
      id: 'pkg-001',
      title: 'Heritage Explorer',
      location: 'Jaipur',
      description: 'Palaces, forts and local cuisine.',
      pricePerPerson: 120.0,
      days: 3,
      itinerary: [
        ItineraryDay(dayIndex: 1, activities: [
          ItineraryActivity(id: 'a1', title: 'City Palace visit'),
          ItineraryActivity(id: 'a2', title: 'Local market walk'),
        ]),
        ItineraryDay(dayIndex: 2, activities: [
          ItineraryActivity(id: 'a3', title: 'Amber Fort'),
          ItineraryActivity(id: 'a4', title: 'Cultural show'),
        ]),
        ItineraryDay(dayIndex: 3, activities: [
          ItineraryActivity(id: 'a5', title: 'Cooking class'),
        ]),
      ],
    );

    final pkg2 = TourPackage(
      id: 'pkg-002',
      title: 'Hill Retreat',
      location: 'Manali',
      description: 'Mountains, trekking and campfires.',
      pricePerPerson: 150.0,
      days: 4,
      itinerary: List.generate(4, (i) => ItineraryDay(dayIndex: i + 1, activities: [
        ItineraryActivity(id: 'h${i}a1', title: 'Trek ${i + 1}'),
      ])),
    );

    return [pkg1, pkg2];
  }

  Future<TourPackage> getPackageById(String id) async {
    final list = await fetchPackages();
    final found = list.firstWhere((p) => p.id == id, orElse: () => throw Exception('Package not found'));
    return found;
  }

  Future<Reservation> reserve({
    required TourPackage tourPackage,
    required int travelers,
    required List<String> travelerNames,
    String notes = '',
  }) async {
    // simulated validations and possible failure
    await Future.delayed(const Duration(milliseconds: 500));
    if (travelers < 1) throw Exception('Must reserve for at least one traveler');
    if (travelerNames.length != travelers) throw Exception('Traveler names count mismatch');
    final res = Reservation(
      id: _uuid.v4(),
      tourPackage: tourPackage,
      travelers: travelers,
      travelerNames: travelerNames,
      createdAt: DateTime.now(),
      notes: notes,
    );
    return res;
  }
}
