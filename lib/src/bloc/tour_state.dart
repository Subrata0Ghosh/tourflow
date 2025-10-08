import 'package:equatable/equatable.dart';
import '../models/package_model.dart';
import '../models/reservation_model.dart';

abstract class TourState extends Equatable {
  const TourState();
  @override
  List<Object?> get props => [];
}

class TourInitial extends TourState {}

class TourLoading extends TourState {}

class PackagesLoaded extends TourState {
  final List<TourPackage> packages;
  const PackagesLoaded(this.packages);
  @override
  List<Object?> get props => [packages];
}

class PackageSelected extends TourState {
  final TourPackage package;
  const PackageSelected(this.package);
  @override
  List<Object?> get props => [package];
}

class ItineraryUpdated extends TourState {
  final TourPackage package;
  const ItineraryUpdated(this.package);
  @override
  List<Object?> get props => [package];
}

class ReservationSuccess extends TourState {
  final Reservation reservation;
  const ReservationSuccess(this.reservation);
  @override
  List<Object?> get props => [reservation];
}

class TourError extends TourState {
  final String message;
  const TourError(this.message);
  @override
  List<Object?> get props => [message];
}
