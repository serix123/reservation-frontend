
import 'package:flutter/material.dart';
import 'package:online_reservation/Data/API_Services/auth.service.dart';
import 'package:online_reservation/Data/Models/auth.model.dart';


class AuthenticationViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthenticationViewModel() {
    init();
  }

  Future<void> init() async {
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

  Future<void> login(String email, String password) async {
    UserCredentials credentials = UserCredentials(email: email,password: password);
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
