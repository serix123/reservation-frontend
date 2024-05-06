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
  String password;
  String password2;
  RegistrationCredentials({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.password2,
  });

  Map<String, String> toJson() => {
    'first_name': first_name,
    'last_name': last_name,
    'email': email,
    'password': password,
    'password2': password2,
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