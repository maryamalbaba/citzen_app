class url {
  //Register
  static const String rgister = '/api/auth/register/citizen';

  //login
  static const String login = '/api/auth/login';

  //OtpVerifyRegister
  static const String otp = '/api/auth/verify-otp/register';

  //resendotp
  static const String resendOtp = '/api/auth/resend-otp';

  //reFreshToken
  static const String reFreshToken = '/api/auth/refresh';

  //logout
  static const String logout = '/api/auth/logout';

  //device token fcm
  static const String deviecFcmToken = '/api/auth/device-token';

  //getTypeProcess
  static const String getTypeProcess = '/api/typeProcess';

  //process_definitionsType
  static const String process_definitions = '/api/process_definitions/auth/';

  //stage_config
  static const String stage_config = '/api/stage_config/config/';

  //uploadFileInSameProcess
  static const String uploadFile = '/api/transaction/files/upload';

  //myTransactionsStatus
  static const String myTransactions = '/api/transaction/my';

  //getTemplatedoc
  static const String templateDocument = '/api/document-templates/';

//forgetpassword
//forgetpin

//بدنا ننتبه على قصة تاريخ الولادة

}

class PinEndpoints {
  PinEndpoints._();

  static const String setupPin = '/api/auth/setup-pin';
  static const String verifyAppPin = '/api/auth/verify-app-pin';
  static const String changePin = '/api/auth/change-pin';
}
