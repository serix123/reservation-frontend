import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/employee.service.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';


class EmployeeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      _employees = await _apiService.fetchEmployees();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _employees = [];
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
}
