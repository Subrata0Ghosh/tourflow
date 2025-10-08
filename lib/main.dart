import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'src/bloc/tour_bloc.dart';
import 'src/repository/tour_repository.dart';

void main() {
  final repo = TourRepository(); // mock repo
  runApp(
    RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (context) => TourBloc(repo),
        child: const TourApp(),
      ),
    ),
  );
}
