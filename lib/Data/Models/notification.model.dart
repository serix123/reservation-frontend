import 'package:online_reservation/Data/Models/event.model.dart';

class Notifications {
  int id;
  String? message;
  Event? event;
  DateTime? created_at;
  Notifications({required this.id, this.message, this.created_at, this.event});

  factory Notifications.fromJson(Map<String, dynamic>json){
    return Notifications(
      id: json['id'],
      message: json['message'] ?? "",
      event: json['event'] != null
          ? Event.fromJson(json['event'])
          : null,
      created_at: DateTime.parse(json['created_at']as String),
    );
  }

}
