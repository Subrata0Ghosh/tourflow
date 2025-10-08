import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/package_model.dart';
import '../../models/itinerary_model.dart';
import '../../bloc/tour_event.dart';
import '../../bloc/tour_state.dart';
import '../../bloc/tour_bloc.dart';
import 'review_reserve_screen.dart';

class CustomizeItineraryScreen extends StatefulWidget {
  final TourPackage package;
  const CustomizeItineraryScreen({required this.package, super.key});
  @override
  State<CustomizeItineraryScreen> createState() => _CustomizeItineraryScreenState();
}

class _CustomizeItineraryScreenState extends State<CustomizeItineraryScreen> {
  late List<ItineraryDay> editable;

  @override
  void initState() {
    super.initState();
    editable = widget.package.itinerary.map((d) => d.copyWith(activities: List.from(d.activities))).toList();
  }

  void _addActivity(int day) {
    final newAct = ItineraryActivity(id: DateTime.now().millisecondsSinceEpoch.toString(), title: 'New Activity');
    setState(() {
      editable[day].activities.add(newAct);
    });
  }

  void _saveItinerary() {
    context.read<TourBloc>().add(UpdateItinerary(widget.package.id, editable));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize - ${widget.package.title}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade400])),
        ),
      ),
      body: BlocListener<TourBloc, TourState>(
        listener: (context, state) {
          if (state is ItineraryUpdated) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewReserveScreen(package: state.package)));
          }
          if (state is TourError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: editable.length,
          itemBuilder: (context, idx) {
            final day = editable[idx];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Day ${day.dayIndex}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => _addActivity(idx), icon: const Icon(Icons.add_circle_outline, color: Colors.teal))
                  ]),
                  const SizedBox(height: 8),
                  ...day.activities.map((a) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.event, color: Colors.teal),
                          title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(a.notes.isEmpty ? 'Tap to add notes' : a.notes),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              final note = await showDialog<String>(
                                context: context,
                                builder: (_) {
                                  final ctrl = TextEditingController(text: a.notes);
                                  return AlertDialog(
                                    title: const Text('Edit notes'),
                                    content: TextField(controller: ctrl, maxLines: 3),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                      ElevatedButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Save'))
                                    ],
                                  );
                                },
                              );
                              if (note != null) {
                                setState(() {
                                  final idxAct = editable[idx].activities.indexWhere((x) => x.id == a.id);
                                  editable[idx].activities[idxAct] = a.copyWith(notes: note);
                                });
                              }
                            },
                          ),
                        ),
                      ))
                ]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveItinerary,
        label: const Text('Save & Review'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
