import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/department.service.dart';
import 'package:online_reservation/Data/API_Services/facility.service.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';


class   DepartmentViewModel extends ChangeNotifier {
  final DepartmentAPIService _apiService = DepartmentAPIService();

  List<Department> _departments = [];
  List<Department> get departments => _departments;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DepartmentViewModel() {
    init();
  }

  Future<void> init() async {
    await fetchDepartment();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchDepartment() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      _departments = await _apiService.fetchDepartment();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _departments = [];
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
}