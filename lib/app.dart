import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/ui/screens/package_list_screen.dart';
import 'src/repository/tour_repository.dart';
import 'src/bloc/tour_bloc.dart';


class TourApp extends StatelessWidget {
  const TourApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Provide a default repository and bloc so the app (and widget tests)
    // can be used directly without wiring providers in main.dart.
    return RepositoryProvider(
      create: (_) => TourRepository(),
      child: BlocProvider(
        create: (ctx) => TourBloc(ctx.read<TourRepository>()),
        child: MaterialApp(
          title: 'TourFlow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            primaryColor: Colors.teal.shade600,
            scaffoldBackgroundColor: const Color(0xFFF7FAFC),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
            ),
            // cards use default theme; individual Card widgets already set shapes
          ),
          home: const PackageListScreen(),
        ),
      ),
    );
  }
}
