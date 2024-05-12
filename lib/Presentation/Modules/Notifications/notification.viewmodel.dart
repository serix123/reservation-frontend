

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/notification.service.dart';
import 'package:online_reservation/Data/Models/notification.model.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationAPIService _apiService = NotificationAPIService();
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Notifications> _notifications = [];
  List<Notifications> get notifications => _notifications;

  static const Duration _refreshInterval = Duration(minutes: 5);
  Timer? _timer;
  void _startRefreshTimer() {
    _timer = Timer.periodic(_refreshInterval, (timer) {
      fetchNotifications();
    });
  }

  NotificationViewModel() {
    init();
    _startRefreshTimer();
  }

  Future<void> init() async {

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<List<Notifications>> fetchNotifications() async {
    _isLoading = true;
    print('_isLoading: $_isLoading');
    notifyListeners();

    try {
      _notifications = await _apiService.fetchNotification();
      _errorMessage = '';
      return _notifications;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return [];
  }
}