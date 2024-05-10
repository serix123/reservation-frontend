import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;

  const FacilityCard({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(facility.image!),
            ),
            title: Text(facility.name),
            subtitle: Text("Department: ${facility.department}"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Person in Charge: ${facility.person_in_charge}",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Implement navigation or other interaction
                  print("Navigating to details for ${facility.name}");
                },
                child: Text('DETAILS'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
