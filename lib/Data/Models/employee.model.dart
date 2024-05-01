class Employee {
  int id;
  String firstName;
  String lastName;
  int? immediateHead;
  Employee? immediateHeadDetails;
  int? department;

  Employee({required this.id, required this.firstName, required this.lastName, this.immediateHead,this.immediateHeadDetails, this.department});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      immediateHead: json['immediate_head'],
      immediateHeadDetails: json['immediate_head_details']!= null ? Employee.fromJson(json['immediate_head_details']) : null,
      department: json['department'],
    );
  }
}
