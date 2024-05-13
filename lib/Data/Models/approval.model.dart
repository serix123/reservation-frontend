import 'package:online_reservation/Data/Models/event.model.dart';
import 'package:online_reservation/Utils/utils.dart';

class Approval {
  int id;
  String? slip_number;
  int? event;
  Event? event_details;
  int? requesitioner;
  String? status;
  int? immediate_head_approver;
  int? person_in_charge_approver;
  // int? admin_approver;
  int? immediate_head_status;
  int? person_in_charge_status;
  int? admin_status;
  DateTime? status_update_date;
  DateTime? immediate_head_update_date;
  DateTime? person_in_charge_update_date;
  DateTime? admin_update_date;


  Approval({
    required this.id,
    required this.slip_number,
    required this.event,
    required this.event_details,
    required this.requesitioner,
    required this.status,
    required this.immediate_head_approver,
    required this.person_in_charge_approver,
    // required this.admin_approver,
    required this.immediate_head_status,
    required this.person_in_charge_status,
    required this.admin_status,
    required this.status_update_date,
    required this.immediate_head_update_date,
    required this.person_in_charge_update_date,
    required this.admin_update_date,
  });


  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      slip_number: json['slip_number'],
      status: json['status'],
      id: json['id'],
      event: json['event'],
      event_details: json['event_details'] != null
          ? Event.fromJson(json['event_details'])
          : null,
      requesitioner: json['requesitioner'],
      immediate_head_approver: json['immediate_head_approver'],
      person_in_charge_approver: json['person_in_charge_approver'],
      // admin_approver: json['admin_approver'],
      immediate_head_status: json['immediate_head_status'],
      person_in_charge_status: json['person_in_charge_status'],
      admin_status: json['admin_status'],
      status_update_date: Utils.parseDateTime(json['status_update_date']),
      immediate_head_update_date: Utils.parseDateTime(json['immediate_head_update_date']),
      person_in_charge_update_date: Utils.parseDateTime(json['person_in_charge_update_date']),
      admin_update_date: Utils.parseDateTime(json['admin_update_date']),

    );
  }
}
