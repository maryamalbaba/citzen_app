import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';
import 'package:citzenapp/feature/auth/register/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> registerCitizen({
  required RegisterRequestModel user
  });
}

/* لم نرجع:

 UserModel
 بل:

 Map<String, dynamic>
ليش؟
  يحتوي response  لأن  :

 token
 user model
 role_code

 وليس فقط user model */