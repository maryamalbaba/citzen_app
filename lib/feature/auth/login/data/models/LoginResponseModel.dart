// login_response_model.dart
class LoginResponseModel {
  final String sessionId;
  final String message;

  LoginResponseModel({required this.sessionId, required this.message});

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      sessionId: map['session_id'] ?? '',
      message: map['message'] ?? '',
    );
  }
}