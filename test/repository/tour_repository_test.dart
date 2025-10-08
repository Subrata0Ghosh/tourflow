import 'package:flutter_test/flutter_test.dart';
import 'package:tourflow/src/repository/tour_repository.dart';

void main() {
  group('TourRepository', () {
    final repo = TourRepository();

    test('fetchPackages returns list', () async {
      final pkgs = await repo.fetchPackages();
      expect(pkgs, isNotEmpty);
    });

    test('getPackageById returns package or throws', () async {
      final pkgs = await repo.fetchPackages();
      final id = pkgs.first.id;
      final found = await repo.getPackageById(id);
      expect(found.id, equals(id));
    });

    test('reserve with invalid travelers throws', () async {
      final pkgs = await repo.fetchPackages();
      final pkg = pkgs.first;
      expect(
        () => repo.reserve(tourPackage: pkg, travelers: 0, travelerNames: []),
        throwsA(isA<Exception>()),
      );
    });
  });
}
