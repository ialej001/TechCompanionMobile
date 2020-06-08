class LoginResponse {
  final String token;

  LoginResponse({this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return new LoginResponse(token: json["token"]);
  }
}
