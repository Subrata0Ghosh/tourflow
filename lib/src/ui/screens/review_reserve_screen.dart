import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/package_model.dart';
import '../../bloc/tour_event.dart';
import '../../bloc/tour_state.dart';
import '../../bloc/tour_bloc.dart';


class ReviewReserveScreen extends StatefulWidget {
  final TourPackage package;
  const ReviewReserveScreen({required this.package, super.key});
  @override
  State<ReviewReserveScreen> createState() => _ReviewReserveScreenState();
}

class _ReviewReserveScreenState extends State<ReviewReserveScreen> {
  final _formKey = GlobalKey<FormState>();
  int travelers = 1;
  final List<TextEditingController> _nameCtrls = [];
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  void _ensureControllers() {
    while (_nameCtrls.length < travelers) {
      _nameCtrls.add(TextEditingController());
    }
    while (_nameCtrls.length > travelers) {
      _nameCtrls.removeLast();
    }
  }

  void _onReserve() {
    if (!_formKey.currentState!.validate()) return;
    final names = _nameCtrls.map((c) => c.text.trim()).toList();
    context.read<TourBloc>().add(MakeReservation(
      packageId: widget.package.id,
      travelers: travelers,
      travelerNames: names,
      notes: _notesCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ensureControllers();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Reserve'),
        flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade400]))),
      ),
      body: BlocConsumer<TourBloc, TourState>(
        listener: (context, state) {
          if (state is ReservationSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text('Reservation Confirmed'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Reservation ID: ${state.reservation.id}'),
                  const SizedBox(height: 8),
                  Text('For ${state.reservation.travelers} traveler(s)'),
                ]),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                        // Pop to root and refresh packages so the main list is present
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // trigger reload on the bloc that's accessible from root
                        final bloc = context.read<TourBloc>();
                        bloc.add(LoadPackages());
                    },
                    child: const Text('Done'),
                  )
                ],
              ),
            );
          }
          if (state is TourError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: ListView(children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.package.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.package.description, style: TextStyle(color: Colors.grey.shade800)),
                  ]),
                ),
                const SizedBox(height: 12),
                const Text('Itinerary', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...widget.package.itinerary.map((d) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.teal.shade50, child: Text('${d.dayIndex}')),
                        title: Text('Day ${d.dayIndex}'),
                        subtitle: Text(d.activities.map((a) => a.title).join(', ')),
                      ),
                    )),
                const Divider(),
                const SizedBox(height: 6),
                Row(children: [
                  const Text('Travelers:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (travelers > 1) travelers--;
                      });
                    },
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                  ),
                  Text('$travelers', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        travelers++;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                  ),
                ]),
                const SizedBox(height: 8),
                ...List.generate(travelers, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextFormField(
                      controller: _nameCtrls[i],
                      decoration: InputDecoration(labelText: 'Traveler ${i + 1} name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    controller: _notesCtrl,
                    decoration: InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                const SizedBox(height: 12),
                state is TourLoading ? const Center(child: CircularProgressIndicator()) : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _onReserve, child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Confirm Reservation'))),
                )
              ]),
            ),
          );
        },
      ),
    );
  }
}
