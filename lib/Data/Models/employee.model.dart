import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/approval.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';

class Employee {
  int id;
  String firstName;
  String lastName;
  String? email;
  bool? isAdmin;
  int? user;
  int? immediateHead;
  Employee? immediateHeadDetails;
  int? department;
  Department? departmentDetails;
  List<Approval>? approvals;
  List<Approval>? immediate_head_approvals;
  List<Approval>? person_in_charge_approvals;
  List<Facility>? managed_facilities;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.isAdmin,
    this.user,
    this.immediateHead,
    this.immediateHeadDetails,
    this.department,
    this.departmentDetails,
    this.approvals,
    this.immediate_head_approvals,
    this.person_in_charge_approvals,
    this.managed_facilities,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    var approvalsList =
        json['approvals'] as List?; // Safely cast to List or null
    List<Approval>? approvals;
    if (approvalsList != null) {
      approvals = approvalsList.map((i) => Approval.fromJson(i)).toList();
      if(approvals.isEmpty){
        approvals = [];
      }
    }
    var immediateHeadApprovalsList = json['immediate_head_approvals']
        as List?; // Safely cast to List or null
    List<Approval>? immediateHeadApprovals;
    if (immediateHeadApprovalsList != null) {
      immediateHeadApprovals =
          immediateHeadApprovalsList.map((i) => Approval.fromJson(i)).toList();
      if(immediateHeadApprovals.isEmpty){
        immediateHeadApprovals = [];
      }
    }
    var personInChargeApprovalsList = json['person_in_charge_approvals']
        as List?; // Safely cast to List or null
    List<Approval>? personInChargeApprovals;
    if (personInChargeApprovalsList != null) {
      personInChargeApprovals =
          personInChargeApprovalsList.map((i) => Approval.fromJson(i)).toList();
      if(personInChargeApprovalsList.isEmpty){
        personInChargeApprovalsList = [];
      }
    }
    var managedFacilitiesList =
        json['managed_facilities'] as List?; // Safely cast to List or null
    List<Facility>? managedFacilities;
    if (managedFacilitiesList != null) {
      managedFacilities =
          managedFacilitiesList.map((i) => Facility.fromJson(i)).toList();
      if(managedFacilities.isEmpty){
        managedFacilities = [];
      }
    }
    return Employee(
      id: json['id'],
      firstName: json['first_name']?? "",
      lastName: json['last_name']?? "",
      email: json['email']?? "",
      isAdmin: json['is_admin'] ?? false,
      user: json['user'],
      immediateHead: json['immediate_head'],
      immediateHeadDetails: json['immediate_head_details'] != null
          ? Employee.fromJson(json['immediate_head_details'])
          : null,
      department: json['department'],
      departmentDetails: json['department_details'] != null
          ? Department.fromJson(json['department_details'])
          : null,
      approvals: approvals,
      immediate_head_approvals: immediateHeadApprovals,
      person_in_charge_approvals: personInChargeApprovals,
      managed_facilities: managedFacilities,
    );
  }


  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'immediate_head': immediateHead,
    'department': department,
    // 'event_file': file,
  };
}
