import 'dart:typed_data';
import 'package:online_reservation/Data/Models/equipment.model.dart';

class Event {
  int? id;
  String? slip_number;
  String? event_name;
  String? event_description;
  String? contact_number;
  String? additional_needs;
  int? reserved_facility;
  int? participants_quantity;
  DateTime start_time;
  DateTime end_time;
  List<EventEquipment>? equipments;
  String? status;
  String? file;
  Uint8List? fileUpload;
  String? fileName;

  Event({
    this.id,
    this.slip_number,
    required this.event_name,
    this.event_description,
    this.contact_number,
    this.additional_needs,
    this.reserved_facility,
    this.participants_quantity,
    required this.start_time,
    required this.end_time,
    this.equipments,
    this.status,
    this.file
  });

  factory Event.fromJson(Map<String, dynamic> json) {

    var list = json['equipments'] as List?; // Safely cast to List or null
    List<EventEquipment>? eventsList;
    if (list != null) {
      eventsList = list.map((i) => EventEquipment.fromJson(i)).toList();
    }
    return Event(
      id: json['id'],
      slip_number: json['slip_number'],
      event_name: json['event_name'],
      event_description: json['event_description'],
      contact_number: json['contact_number'],
      additional_needs: json['additional_needs'],
      reserved_facility: json['reserved_facility'],
      participants_quantity: json['participants_quantity'],
      start_time: DateTime.parse(json['start_time']as String),
      end_time: DateTime.parse(json['end_time']as String),
      equipments: eventsList,
      status: json['status'],
      file: json['event_file'],
    );
  }

  Map<String, dynamic> toJson() => {
    // 'id': id,
    'slip_number': slip_number,
    'event_name': event_name,
    'event_description': event_description,
    'contact_number': contact_number,
    'additional_needs': additional_needs,
    'reserved_facility': reserved_facility,
    'participants_quantity': participants_quantity,
    'start_time': start_time.toIso8601String(),
    'end_time': end_time.toIso8601String(),
    'equipments':equipments?.map((equipment) => equipment.toJson()).toList(),
    'status': status,
    // 'event_file': file,
  };
}