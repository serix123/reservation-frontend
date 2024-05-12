import 'package:online_reservation/Data/Models/event.model.dart';

class Approval {
  int id;
  String? slip_number;
  int? event;
  Event? event_details;
  int? requesitioner;
  String? status;
  int? immediate_head_approver;
  int? person_in_charge_approver;
  int? immediate_head_status;
  int? person_in_charge_status;
  int? admin_status;


  Approval({
    required this.id,
    required this.slip_number,
    required this.event,
    required this.event_details,
    required this.requesitioner,
    required this.status,
    required this.immediate_head_approver,
    required this.person_in_charge_approver,
    required this.immediate_head_status,
    required this.person_in_charge_status,
    required this.admin_status,
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
      immediate_head_status: json['immediate_head_status'],
      person_in_charge_status: json['person_in_charge_status'],
      admin_status: json['admin_status'],
      // department: json['department']!= null ? int.tryParse(json['department'].toString()) : null,
      // id: json['id']!= null ? int.tryParse(json['id'].toString()) : null,
      // event: json['event']!= null ? int.tryParse(json['event'].toString()) : null,
      // requesitioner: json['requesitioner']!= null ? int.tryParse(json['requesitioner'].toString()) : null,
      // immediate_head_approver: json['immediate_head_approver']!= null ? int.tryParse(json['immediate_head_approver'].toString()) : null,
      // person_in_charge_approver: json['person_in_charge_approver']!= null ? int.tryParse(json['person_in_charge_approver'].toString()) : null,
      // immediate_head_status: json['immediate_head_status']!= null ? int.tryParse(json['immediate_head_status'].toString()) : null,
      // person_in_charge_status: json['person_in_charge_status']!= null ? int.tryParse(json['person_in_charge_status'].toString()) : null,
      // admin_status: json['admin_status']!= null ? int.tryParse(json['admin_status'].toString()) : null,

    );
  }
}
