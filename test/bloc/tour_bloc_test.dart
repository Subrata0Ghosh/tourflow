import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourflow/src/bloc/tour_bloc.dart';
import 'package:tourflow/src/repository/tour_repository.dart';
import 'package:tourflow/src/bloc/tour_event.dart';
import 'package:tourflow/src/bloc/tour_state.dart';

void main() {
  group('TourBloc', () {
    late TourRepository repo;
    late TourBloc bloc;

    setUp(() {
      repo = TourRepository();
      bloc = TourBloc(repo);
    });

    blocTest<TourBloc, TourState>(
      'emits [TourLoading, PackagesLoaded] when LoadPackages',
      build: () => bloc,
      act: (b) async {
        b.add(LoadPackages());
        // wait slightly longer than repo delay
        await Future.delayed(const Duration(milliseconds: 80));
      },
      expect: () => [isA<TourLoading>(), isA<PackagesLoaded>()],
    );

    blocTest<TourBloc, TourState>(
      'select package emits PackageSelected',
      build: () => bloc,
      act: (b) async {
        b.add(LoadPackages());
        await Future.delayed(const Duration(milliseconds: 80));
        final pkgs = await repo.fetchPackages();
        b.add(SelectPackage(pkgs.first.id));
        await Future.delayed(const Duration(milliseconds: 80));
      },
      expect: () => [isA<TourLoading>(), isA<PackagesLoaded>(), isA<TourLoading>(), isA<PackageSelected>()],
    );
  });
}
