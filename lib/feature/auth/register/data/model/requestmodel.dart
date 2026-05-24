class RegisterRequestModel {

  final String userName;

  final String email;

  final String phone_number;

  final String password;

  const RegisterRequestModel({
    required this.userName,
    required this.email,
    required this.phone_number,
    required this.password,
  });

  Map<String, dynamic> toMap() {

    return {
      "userName": userName,
      "email": email,
      "phone_number": phone_number,
      "password": password,
    };
  }
}