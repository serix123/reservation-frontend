import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'dart:convert';

import 'package:online_reservation/config/host.dart';


class ApiService {

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('${appURL}employee/get/'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Employee> employees = body.map((dynamic item) => Employee.fromJson(item)).toList();
        return employees;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}
