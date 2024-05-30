import 'package:flutter/cupertino.dart';
import 'package:online_reservation/Data/API_Services/event.service.dart';
import 'package:online_reservation/Data/Models/event.model.dart';

class EventViewModel extends ChangeNotifier {
  final EventAPIService _apiService = EventAPIService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;
  List<Event> _allEvents = [];
  List<Event> get events => _allEvents;
  List<Event> get scheduledEvents => _allEvents.where((event) => event.status == "confirmed").toList();
  List<Event> _userEvents = [];
  List<Event> get userEvents => _userEvents;
  Event? _event;
  Event? get userEvent => _event;

  void resetMessage() {
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
  }

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

  Future<void> fetchEvent(String slipNo) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _event = await _apiService.fetchEvent(slipNo);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _userEvents = [];
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelEvent(String slipNo) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    _isRegistered = false;
    notifyListeners();
    bool success = false;
    try {
      success = await _apiService.cancelEvent(slipNo);
      if (success) {
        _successMessage = "Event has been cancelled";
      }else{
        _errorMessage = "Event cancellation has failed";
      }
    } catch (e) {
      _errorMessage = "Event cancellation has failed: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(int id) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    _isRegistered = false;
    notifyListeners();
    bool success = false;
    try {
      success = await _apiService.deleteEvent(id);
      if (success) {
        _successMessage = "Event has been deleted";
      }else{
        _errorMessage = "Event delete has failed";
      }
    } catch (e) {
      _errorMessage = "Event delete has failed: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerEvent(Event event) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    _isRegistered = false;
    print('_eventLoad: $_isLoading');
    notifyListeners();
    try {
      _isRegistered = await _apiService.registerEvent(event);
      if (_isRegistered) {
        _successMessage = "Event has been Registered";
      }else{
        _errorMessage = "Event registration has failed";
      }
    } catch (e) {
      _errorMessage = "Event registration has failed: ${e.toString()}";
      _isRegistered = false;
    } finally {
      _isLoading = false;
      print('_eventLoad: $_isLoading');
      notifyListeners();
    }
  }

  Future<void> updateEvent(Event event) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    _isRegistered = false;
    print('_eventLoad: $_isLoading');
    notifyListeners();
    try {
      _isRegistered = await _apiService.updateEvent(event);
      if (_isRegistered) {
        _successMessage = "Event has been updated";
      }else{
        _errorMessage = "Event registration has failed";
      }
    } catch (e) {
      _errorMessage = "Event update has failed: ${e.toString()}";
      _isRegistered = false;
    } finally {
      _isLoading = false;
      print('_eventLoad: $_isLoading');
      _isRegistered = true;
      notifyListeners();
    }
  }
}
