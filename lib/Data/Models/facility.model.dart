import 'package:online_reservation/Data/Models/event.model.dart';

class Facility {
  int id;
  String name;
  int? department;
  int? person_in_charge;
  List<Event>? events;
  String? image;
  String? facility_description;

  Facility({
    required this.id,
    required this.name,
    this.department,
    this.person_in_charge,
    this.events,
    this.image,
    this.facility_description
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    var list = json['events'] as List?; // Safely cast to List or null
    List<Event>? eventsList;
    if (list != null) {
      eventsList = list.map((i) => Event.fromJson(i)).toList();
    }

    return Facility(
      id: json['id'],
      name: json['name']?? "",
      department: json['department']!= null ? int.tryParse(json['department'].toString()) : null,
      person_in_charge: json['person_in_charge']!= null ? int.tryParse(json['person_in_charge'].toString()) : null,
      image: json['image'],
      facility_description: json['facility_description']?? "Nice Place...",
      events: eventsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'facility_description': facility_description,
      'department': department,
      'person_in_charge': person_in_charge,
    };
  }

}
