import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/tour_bloc.dart';
import '../../bloc/tour_event.dart';
import '../../bloc/tour_state.dart';
import '../widgets/package_card.dart';
import 'customize_itinerary_screen.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({super.key});
  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TourBloc>().add(LoadPackages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TourFlow'),
        centerTitle: false,
        // use same gradient style as other screens to avoid visual artifacts
        flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade400]))),
        elevation: 0,
      ),
      body: BlocConsumer<TourBloc, TourState>(
        listener: (context, state) {
          if (state is TourError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is PackageSelected) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CustomizeItineraryScreen(package: state.package)),
            );
          }
        },
        builder: (context, state) {
          if (state is TourLoading || state is TourInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PackagesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.packages.length,
              itemBuilder: (context, idx) {
                final pkg = state.packages[idx];
                return PackageCard(
                  tourPackage: pkg,
                  onSelect: () => context.read<TourBloc>().add(SelectPackage(pkg.id)),
                );
              },
            );
          } else if (state is TourError) {
            return Center(child: Text(state.message));
          }
          // If the bloc is in another transient state (PackageSelected, ItineraryUpdated,
          // ReservationSuccess), trigger a reload so the main list is shown when
          // returning from deeper screens. Use a post frame callback to avoid
          // dispatching events during build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<TourBloc>().add(LoadPackages());
          });
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
