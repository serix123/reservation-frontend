import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/employee.service.dart';
import 'package:online_reservation/Data/API_Services/facility.service.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';


class FacilityViewModel extends ChangeNotifier {
  final FacilityAPIService _apiService = FacilityAPIService();

  List<Facility> _facilities = [];
  List<Facility> get facilities => _facilities;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  FacilityViewModel() {
    init();
  }

  Future<void> init() async {
    await fetchFacilities();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchFacilities() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      _facilities = await _apiService.fetchFacilities();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _facilities = [];
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
}