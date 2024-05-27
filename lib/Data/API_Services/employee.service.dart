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
      print(e);
    }
    return [];
  }

  Future<Employee?> fetchProfile() async {
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
      print('error: $e');
    }
    return null;
  }

  Future<Employee?> updateEmployee(Employee employee) async {
    try {
      String? token = await storage.read(key: "access");
      final body = jsonEncode(employee.toJson());
      final response = await http.patch(
        Uri.parse('${appURL}employee/update-emp/${employee.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body
      );
      if (response.statusCode == 200) {
        Employee employee = Employee.fromJson(json.decode(response.body.replaceAll('False', 'false').replaceAll('True', 'true')));
        return employee;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('error: $e');
    }
    return null;
  }

  Future<bool> deleteEmployee(Employee employee) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.delete(
        Uri.parse('${authURL}delete/${employee.user}/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete employees');
      }
    } catch (e) {
      print('error: $e');
    }
    return false;
  }
}
