import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/facility.service.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';

class FacilityViewModel extends ChangeNotifier {
  final FacilityAPIService _apiService = FacilityAPIService();

  List<Facility> _facilities = [];
  List<Facility> get facilities => _facilities;

  Facility? _facility;
  Facility? get facility => _facility;

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

  String _successMessage = '';
  String get successMessage => _successMessage;

  void resetMessage() {
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
  }

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

  Future<void> updateFacility(Facility facility) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      _facility = await _apiService.updateFacility(facility);
      _successMessage = "Facility has been updated";
      if (_facility == null) {
        _successMessage = '';
        _errorMessage = "Facility update has failed";
      }
    } catch (e) {
      _errorMessage = "Facility update has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> createFacility(Facility facility) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      _facility = await _apiService.createFacility(facility);
      _successMessage = "Facility has been created";
      if (_facility == null) {
        _successMessage = '';
        _errorMessage = "Facility create has failed";
      }
    } catch (e) {
      _errorMessage = "Facility create has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> deleteFacility(Facility facility) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    print('_profileLoad: $_isLoading');
    notifyListeners();

    try {
      bool response = await _apiService.deleteFacility(facility);
      _successMessage = "Facility has been deleted";
      if (!response) {
        _successMessage = '';
        _errorMessage = "Facility delete has failed";
      }
    } catch (e) {
      _errorMessage = "Facility delete has failed";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      print('_profileLoad: $_isLoading');
      notifyListeners();
    }
  }
}
