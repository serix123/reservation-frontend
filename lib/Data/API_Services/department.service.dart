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
        List<Department> departments =
            body.map((dynamic item) => Department.fromJson(item)).toList();
        return departments;
      } else {
        throw Exception('Failed to load Employees');
      }
    } catch (e) {
      print('$e');
    }
    return [];
  }
}
