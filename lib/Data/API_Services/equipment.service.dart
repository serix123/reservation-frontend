import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/equipment.model.dart';
import 'dart:convert';

import 'package:online_reservation/config/host.dart';

class EquipmentAPIService {
  Future<List<Equipment>> fetchEquipments() async {
    try {
      final response = await http.get(Uri.parse('${appURL}equipment/'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body) as List;
        List<Equipment> equipments = body.map((item) {
          return Equipment.fromJson(item);
        }).toList();

        return equipments;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}
