class ResendOtpResponseModel {
  final String sessionId;

  ResendOtpResponseModel({required this.sessionId});

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      sessionId: json['data']['session_id'] ?? '',
    );
  }
}