class Equipment{
  int equipment;
  String equipment_name;
  int quantity;

  Equipment({
    required this.equipment,
    required this.equipment_name,
    required this.quantity,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      equipment: json['equipment'],
      equipment_name: json['equipment_name'],
      quantity: json['quantity'],
    );
  }
}