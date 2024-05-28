import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/employee.service.dart';
import 'package:online_reservation/Data/Models/approval.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';

class EmployeeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;
  List<Approval> _approvals = [];
  List<Approval> get approvals => _approvals;
  List<Approval> _immediate_head_approvals = [];
  List<Approval> get immediate_head_approvals => _immediate_head_approvals;
  List<Approval> _person_in_charge_approvals = [];
  List<Approval> get person_in_charge_approvals => _person_in_charge_approvals;

  // Employee _profile = Employee(id: 1, firstName: "firstName", lastName: "lastName", isAdmin: false);
  Employee? _profile; // Now it's nullable and won't throw LateInitializationError
  Employee? get profile => _profile;

  Employee? _updatedEmployee; // Now it's nullable and won't throw LateInitializationError
  Employee? get updatedEmployee => _updatedEmployee;

  EmployeeViewModel() {
    // init();
  }

  Future<void> init() async {
    await fetchEmployees();
    await fetchProfile();
  }
  void resetMessage() {
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  Future<void> fetchEmployees() async {
    // _successMessage = '';
    // _errorMessage = '';
    _isLoading = true;
    print('_empLoad: $_isLoading');
    notifyListeners();

    try {
      _employees = await _apiService.fetchEmployees();

      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _employees = [];
    } finally {
      _isLoading = false;
      print('_empLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    _successMessage = '';
    _errorMessage = '';
    _isLoading = true;
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      _profile = await _apiService.fetchProfile();
      _approvals = _profile?.approvals ?? [];
      _immediate_head_approvals = _profile?.immediate_head_approvals ?? [];
      _person_in_charge_approvals = _profile?.person_in_charge_approvals ?? [];
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      print(_errorMessage);
      _profile = Employee(id: 1, firstName: "firstName", lastName: "lastName");
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      _updatedEmployee = await _apiService.updateEmployee(employee);
      _successMessage = "Employee has been updated";
      if(_updatedEmployee == null){
        _successMessage='';
        _errorMessage = "Employee update has failed";
      }
    } catch (e) {
      _errorMessage = "Employee update has failed";
      print(_errorMessage);
      _profile = Employee(id: 1, firstName: "firstName", lastName: "lastName");
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(Employee employee) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      bool response = await _apiService.deleteEmployee(employee);
      _successMessage = "Employee has been deleted";
      if(!response){
        _successMessage='';
        _errorMessage = "Employee delete has failed";
      }
    } catch (e) {
      _errorMessage = "Employee delete has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
