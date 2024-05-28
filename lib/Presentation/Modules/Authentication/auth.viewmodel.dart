import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/auth.service.dart';
import 'package:online_reservation/Data/Models/auth.model.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  static const Duration _refreshInterval = Duration(minutes: 5);
  Timer? _timer;

  void _startRefreshTimer() {
    _timer = Timer.periodic(_refreshInterval, (timer) {
      refreshAccessToken();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  AuthenticationViewModel() {
    init();
    _startRefreshTimer();
  }

  Future<void> init() async {
    _isLoading = false;
    _successMessage = '';
    _errorMessage = '';
    bool validToken = await validateToken();
    if (!validToken) {
      await refreshAccessToken();
    }
  }

  Future<bool> validateToken() async {
    var token = await _authService.getAccessToken();
    // Assume a simple validation check or prepare for a token validation API call
    return token != null && token.isNotEmpty;
  }

  void resetMessage() {
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    UserCredentials credentials = UserCredentials(email: email, password: password);
    bool loggedIn = await _authService.login(credentials);
    if (loggedIn) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<bool> register(String firstName, String lastName, String email, String password) async {
    RegistrationCredentials credentials = RegistrationCredentials(
      first_name: firstName,
      last_name: lastName,
      email: email,
      password: password,
      password2: password,
    );
    try {
      bool registered = await _authService.register(credentials);
      if (registered) {
        // _isLoggedIn = true;
        notifyListeners();
      } else {
        // _isLoggedIn = false;
      }
      return registered;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  Future<bool> registerByAdmin(RegistrationCredentials credentials) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
    try {
      bool registered = await _authService.register(credentials);
      if (registered) {
        _successMessage = 'Registration Success';
        notifyListeners();
      } else {
        _errorMessage = "Registration Fail";
      }
      return registered;
    } catch (e) {
      _errorMessage = "Registration error: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> registerByCSV(List<RegistrationCredentials> usersData) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
    try {
      for (final userData in usersData) {
        bool registered = await _authService.register(userData);
        if (registered) {
          _successMessage += '${userData.email}Registration Success\n ';
          notifyListeners();
        } else {
          _errorMessage = "Registration Fail";
          notifyListeners();
        }
        if (_errorMessage.isNotEmpty) {
          throw Exception("failed to register ${userData.email}");
        }
      }
    } catch (e) {
      _errorMessage = "Registration error: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> updateByAdmin(UserUpdateDetails updateDetails) async {
    _isLoading = true;
    _successMessage = '';
    _errorMessage = '';
    notifyListeners();
    try {
      bool registered = await _authService.update(updateDetails);
      if (registered) {
        _successMessage = "Update Success";
        notifyListeners();
      } else {
        _errorMessage = "Update Fail";
        notifyListeners();
      }
      if (_errorMessage.isNotEmpty) {
        throw Exception(_errorMessage);
      }
    } catch (e) {
      _errorMessage = "Registration error: $e";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAccessToken() async {
    bool refreshed = await _authService.refreshAccessToken();
    if (refreshed) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
      await logout();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
