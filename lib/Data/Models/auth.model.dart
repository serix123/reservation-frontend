import 'package:online_reservation/Data/Models/employee.model.dart';

class UserCredentials {

  String email;
  String password;
  UserCredentials({required this.email, required this.password});

  Map<String, String> toJson() => {
    'email': email,
    'password': password,
  };
}
class RegistrationCredentials {

  String first_name;
  String last_name;
  String email;
  String? password;
  String? password2;
  Employee? employee;
  RegistrationCredentials({
    required this.first_name,
    required this.last_name,
    required this.email,
    this.password,
    this.password2,
    this.employee,
  });

  Map<String, dynamic> toJson() => {
    'first_name': first_name,
    'last_name': last_name,
    'email': email,
    'password': password,
    'password2': password2,
    if(employee != null )
      'employee': <String, dynamic>{
        'immediate_head': employee?.immediateHead,
        'department': employee?.department,
      },
  };
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;

  TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }
}