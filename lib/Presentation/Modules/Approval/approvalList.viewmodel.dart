
import 'package:flutter/cupertino.dart';
import 'package:online_reservation/Data/API_Services/approval.service.dart';
import 'package:online_reservation/Data/Models/approval.model.dart';


class ApprovalViewModel extends ChangeNotifier{
  final ApprovalAPIService _apiService = ApprovalAPIService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Approval> _userApproval = [];
  List<Approval> get userApproval => _userApproval;

  Future<void> fetchApprovals() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      List<Approval>? approval = await _apiService.fetchApproval();
      _userApproval = approval ?? [];
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> approveByHead(String slip) async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      bool success = await _apiService.approveByHead(slip);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> approveByPIC(String slip) async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      bool success = await _apiService.approveByPIC(slip);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> approveAdmin(String slip) async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      bool success = await _apiService.approveByAdmin(slip);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> rejectByHead(String slip) async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      bool success = await _apiService.rejectByHead(slip);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> rejectByPIC(String slip) async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      bool success = await _apiService.rejectByPIC(slip);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> rejectAdmin(String slip) async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      bool success = await _apiService.rejectByAdmin(slip);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
}