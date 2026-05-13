import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {

  // Private Constructor
  Env._();
//يحوي قيم ستاتك ما بدي انشأ اوبجكت منه 
  static String get baseUrl =>
      dotenv.get('BASE_URL');

  static String get appName =>
      dotenv.get('APP_NAME');

  static bool get debug =>
      dotenv.get('DEBUG') == 'true';
}

/*

 get ليه استخدمنا  
بدل:
static String baseUrl = ...

لأن:
dotenv.load()

 runtime يعمل 
 getterواستخدام :

أحدث
أنظف
lazy loading
يمنع مشاكل initialization

لماذا:
Env._();
؟

: object هذا لمنع إنشاء:
Env env = Env();

 utilityلأن الكلاس  فقط.


*/