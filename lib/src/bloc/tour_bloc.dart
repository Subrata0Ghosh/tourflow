import 'package:bloc/bloc.dart';
import 'tour_event.dart';
import 'tour_state.dart';
import '../repository/tour_repository.dart';
// import '../models/package_model.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  final TourRepository repository;
  TourBloc(this.repository) : super(TourInitial()) {
    on<LoadPackages>(_onLoadPackages);
    on<SelectPackage>(_onSelectPackage);
    on<UpdateItinerary>(_onUpdateItinerary);
    on<MakeReservation>(_onMakeReservation);
  }

  Future<void> _onLoadPackages(LoadPackages e, Emitter<TourState> emit) async {
    emit(TourLoading());
    try {
      final pkgs = await repository.fetchPackages();
      emit(PackagesLoaded(pkgs));
    } catch (err) {
      emit(TourError('Failed to load packages: ${err.toString()}'));
    }
  }

  Future<void> _onSelectPackage(SelectPackage e, Emitter<TourState> emit) async {
    emit(TourLoading());
    try {
      final pkg = await repository.getPackageById(e.packageId);
      emit(PackageSelected(pkg));
    } catch (err) {
      emit(TourError('Package selection failed: ${err.toString()}'));
    }
  }

  Future<void> _onUpdateItinerary(UpdateItinerary e, Emitter<TourState> emit) async {
    emit(TourLoading());
    try {
      final pkg = await repository.getPackageById(e.packageId);
      final updated = pkg.copyWith(itinerary: e.itinerary);
      emit(ItineraryUpdated(updated));
    } catch (err) {
      emit(TourError('Failed to update itinerary: ${err.toString()}'));
    }
  }

  Future<void> _onMakeReservation(MakeReservation e, Emitter<TourState> emit) async {
    emit(TourLoading());
    try {
      final pkg = await repository.getPackageById(e.packageId);
      final res = await repository.reserve(
        tourPackage: pkg,
        travelers: e.travelers,
        travelerNames: e.travelerNames,
        notes: e.notes,
      );
      emit(ReservationSuccess(res));
    } catch (err) {
      emit(TourError('Reservation failed: ${err.toString()}'));
    }
  }
}
