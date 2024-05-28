import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/equipment.service.dart';
import 'package:online_reservation/Data/Models/equipment.model.dart';


class EquipmentViewModel extends ChangeNotifier {
  final EquipmentAPIService _apiService = EquipmentAPIService();

  List<Equipment> _equipments = [];
  List<Equipment> get equipments => _equipments;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  EquipmentViewModel() {
    init();
  }

  Future<void> init() async {
    await fetchEquipment();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  Future<void> fetchEquipment() async {
    _isLoading = true;
    print('_eventLoad: $_isLoading');
    notifyListeners();

    try {
      _equipments = await _apiService.fetchEquipments();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _equipments = [];
    } finally {
      _isLoading = false;
      print('_eventLoad: $_isLoading');
      notifyListeners();
    }
  }
  
}