class LoginModel {

  final String message;
  final String sessionToken;

  LoginModel(this.message, this.sessionToken);

  LoginModel.fromJson(Map<String, dynamic> json)
    : message = json['message'],
      sessionToken = json['sessionToken'];

  Map<String, dynamic> toJson() => {
    'message' : message,
    'sessionToken' : sessionToken
  };
}