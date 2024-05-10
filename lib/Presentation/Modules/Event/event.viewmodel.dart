import 'package:flutter/cupertino.dart';
import 'package:online_reservation/Data/API_Services/event.service.dart';
import 'package:online_reservation/Data/Models/event.model.dart';

class EventViewModel extends ChangeNotifier {
  final EventAPIService _apiService = EventAPIService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;
  List<Event> _allEvents = [];
  List<Event> get events => _allEvents;
  List<Event> _userEvents = [];
  List<Event> get userEvents => _userEvents;

  Future<void> fetchAllEvents() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      _allEvents = await _apiService.fetchAllEvents();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _allEvents = [];
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<void> fetchUserEvents() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      _userEvents = await _apiService.fetchUserEvents();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _userEvents = [];
    } finally {
      _isLoading = false;
      print('_isLoading: $_isLoading');
      notifyListeners();
    }
  }
  Future<bool> registerEvent(Event event) async {
    _errorMessage = '';
    _isRegistered = false;
    _isLoading = true;
    print('_eventLoad: $_isLoading');
    notifyListeners();
    try {
      _isRegistered = await _apiService.registerEvent(event);
      _errorMessage = '';
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isRegistered = false;
      return false;
    } finally {
      _isLoading = false;
      print('_eventLoad: $_isLoading');
      _isRegistered = true;
      notifyListeners();

    }
  }
}
