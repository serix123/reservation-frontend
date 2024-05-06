import 'package:online_reservation/Data/Models/equipment.model.dart';

class Event {
  int? id;
  String? slip_number;
  String event_name;
  int? reserved_facility;
  DateTime start_time;
  DateTime end_time;
  List<Equipment>? equipments;
  String? status;

  Event({
    this.id,
    this.slip_number,
    required this.event_name,
    this.reserved_facility,
    this.equipments,
    this.status,
    required this.start_time,
    required this.end_time
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var list = json['equipments'] as List;
    List<Equipment>? eventsList = list.map((i) => Equipment.fromJson(i)).toList();
    return Event(
      id: json['id'],
      slip_number: json['slip_number'],
      event_name: json['event_name'],
      reserved_facility: json['reserved_facility'],
      start_time: DateTime.parse(json['start_time']as String),
      end_time: DateTime.parse(json['end_time']as String),
      equipments: eventsList,
      status: json['status'],
    );
  }
}