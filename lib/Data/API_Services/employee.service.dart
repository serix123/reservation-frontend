import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:online_reservation/config/host.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';


class ApiService {
  final storage = const FlutterSecureStorage();
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('${appURL}employee/get/'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Employee> employees =
            body.map((dynamic item) => Employee.fromJson(item)).toList();
        return employees;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Employee> fetchProfile() async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(
        Uri.parse('${appURL}employee/get_profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Employee employee = Employee.fromJson(json.decode(response.body.replaceAll('False', 'false').replaceAll('True', 'true')));
        return employee;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}
