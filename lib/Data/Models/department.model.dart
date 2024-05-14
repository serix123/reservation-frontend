
class Department {
  int id;
  int? immediate_head;
  String? name;

  Department({
    required this.id,
     this.immediate_head,
     this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'] ?? "",
      immediate_head: json['immediate_head']!= null ? int.tryParse(json['immediate_head'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['immediate_head'] = immediate_head;
    map['name'] = name;
    return map;
  }
}
