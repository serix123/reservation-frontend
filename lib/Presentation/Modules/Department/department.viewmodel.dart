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

  Department? _department;
  Department? get department => _department;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  DepartmentViewModel() {
    // init();
  }

  Future<void> init() async {
    await fetchDepartment();
  }

  void resetMessage() {
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
  }

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

  Future<void> updateDepartment(Department department) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      _department = await _apiService.updateDepartment(department);
      _successMessage = "Department has been updated";
      if(_department == null){
        _successMessage='';
        _errorMessage = "Department update has failed";
      }
    } catch (e) {
      _errorMessage = "Department update has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> createDepartment(Department department) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      _department = await _apiService.createDepartment(department);
      _successMessage = "Department has been created";
      if(_department == null){
        _successMessage='';
        _errorMessage = "Department create has failed";
      }
    } catch (e) {
      _errorMessage = "Department create has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> deleteDepartment(Department department) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      bool response = await _apiService.deleteDepartment(department);
      _successMessage = "Department has been deleted";
      if(!response){
        _successMessage='';
        _errorMessage = "Department delete has failed";
      }
    } catch (e) {
      _errorMessage = "Department delete has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }
}