import 'package:flutter/material.dart';
import '../../models/package_model.dart';

class PackageCard extends StatelessWidget {
  final TourPackage tourPackage;
  final VoidCallback onSelect;
  const PackageCard({required this.tourPackage, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.0);
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: radius),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: radius.topLeft, topRight: radius.topRight),
              gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade400]),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.card_travel, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(tourPackage.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                Chip(
                  backgroundColor: Colors.white.withValues(alpha: .18),
                  label: Text('${tourPackage.days} days', style: const TextStyle(color: Color.fromARGB(255, 209, 161, 73))),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.teal.shade700),
                  const SizedBox(width: 6),
                  Text(tourPackage.location, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              Text(tourPackage.description, style: TextStyle(color: Colors.grey.shade800)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('\$${tourPackage.pricePerPerson.toStringAsFixed(0)} / person', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ElevatedButton(onPressed: onSelect, child: const Text('Customize & Reserve'))
              ])
            ]),
          ),
        ],
      ),
    );
  }
}
