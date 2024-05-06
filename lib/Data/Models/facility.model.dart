import 'package:online_reservation/Data/Models/event.model.dart';

class Facility {
  int id;
  String name;
  int? department;
  int? person_in_charge;
  List<Event>? events;

  Facility({
    required this.id,
    required this.name,
    this.department,
    this.person_in_charge,
    this.events,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    var list = json['events'] as List;
    List<Event> eventsList = list.map((i) => Event.fromJson(i)).toList();

    return Facility(
      id: json['id'],
      name: json['name'],
      events: eventsList,
    );
  }

}
