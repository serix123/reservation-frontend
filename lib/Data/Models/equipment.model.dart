class EventEquipment{
  int equipment;
  String equipment_name;
  int quantity;

  EventEquipment({
    required this.equipment,
    required this.equipment_name,
    required this.quantity,
  });

  factory EventEquipment.fromJson(Map<String, dynamic> json) {
    return EventEquipment(
      equipment: json['equipment'],
      equipment_name: json['equipment_name'],
      quantity: json['quantity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'equipment': equipment,
      // 'equipment_name': equipment_name,
      'quantity': quantity,
    };
  }
}
class Equipment{
  int id;
  String equipment_name;
  int equipment_type;
  int equipment_quantity;
  int? work_type;

  Equipment({
    required this.id,
    required this.equipment_name,
    required this.equipment_type,
    required this.equipment_quantity,
    this.work_type,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      equipment_name: json['equipment_name'],
      equipment_type: json['equipment_type'],
      equipment_quantity: json['equipment_quantity'],
      work_type: json['work_type'] != null ? int.tryParse(json['work_type'].toString()) : null,
    );
  }
}