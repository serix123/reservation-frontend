import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/auth.model.dart';
import 'package:online_reservation/config/host.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<bool> login(UserCredentials credentials) async {
    try {
      final response = await http.post(
        Uri.parse('${authURL}token/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(credentials.toJson()),
      );
      if (response.statusCode == 200) {
        var token = TokenResponse.fromJson(jsonDecode(response.body));
        await storage.write(key: "access", value: token.accessToken);
        await storage.write(key: "refresh", value: token.refreshToken);
        return true;
        // return TokenResponse.fromJson(response.body);
      } else {
        print('Failed to authenticate: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception when calling authenticate: $e');
      return false;
    }
  }

  Future<bool> register(RegistrationCredentials credentials) async {
    try {
      final response = await http.post(
        Uri.parse('$authURL/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'firstName': credentials.first_name,
          'lastName': credentials.last_name,
          'email': credentials.email,
          'password': credentials.password,
          'password2': credentials.password2,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a token upon successful registration
        // final data = jsonDecode(response.body);
        // await storage.write(key: 'token', value: data['token']);
        return true;
      } else {
        // Handle different status codes appropriately
        print('Failed to register: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception when calling API: $e');
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: "access");
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: "refresh");
  }

  Future<bool> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      var response = await http.post(
        Uri.parse('${authURL}token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );
      if (response.statusCode == 200) {
        var token = TokenResponse.fromJson(jsonDecode(response.body));
        await storage.write(key: "access", value: token.accessToken);
        await storage.write(key: "refresh", value: token.refreshToken);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: "accessToken");
    await storage.delete(key: "refreshToken");
  }
}
