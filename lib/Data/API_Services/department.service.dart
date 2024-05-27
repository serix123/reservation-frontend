import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/department.model.dart';
import 'dart:convert';
import 'package:online_reservation/config/host.dart';

class DepartmentAPIService {
  Future<List<Department>> fetchDepartment() async {
    try {
      final response = await http.get(Uri.parse('${appURL}department/'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Department> departments = body.map((dynamic item) => Department.fromJson(item)).toList();
        return departments;
      } else {
        throw Exception('Failed to load Employees');
      }
    } catch (e) {
      print('$e');
    }
    return [];
  }

  Future<Department?> createDepartment(Department department) async {
    try {
      final body = json.encode(department.toJson());
      print(body);
      final response = await http.post(Uri.parse('${appURL}department/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 201) {
        return Department.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create department: ${response.body}');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }

  Future<Department?> updateDepartment(Department department) async {
    try {
      final body = jsonEncode(department.toJson());
      final response = await http.patch(Uri.parse('${appURL}department/${department.id}/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        return Department.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update department: ${response.body}');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }

  Future<bool> deleteDepartment(Department department) async {
    try {
      final response = await http.delete(Uri.parse('${appURL}department/${department.id}/'));

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete department: ${response.body}');
      }
    } catch (e) {
      print('error: $e');
    }
    return false;
  }
}
