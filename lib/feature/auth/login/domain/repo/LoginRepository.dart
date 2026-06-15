// login_repository_impl.dart
import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/auth/login/data/data_source/LoginRemoteDataSource.dart';
import 'package:citzenapp/feature/auth/login/data/models/LoginResponseModel.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseModel>> login({required String userName, required String password});
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponseModel>> login({required String userName, required String password}) async {
    try {
      final response = await remoteDataSource.login(userName: userName, password: password);

      if (response['success'] == true) {
        final data = LoginResponseModel.fromMap(response['data']);
        return Right(data);
      }else {
        return Left(ServerFailure(response['message'] ?? 'حدث خطأ ما'));
      }
    } 
    // 🔥 1. اصطياد خطأ الـ 401 المخصص واستخراج الرسالة العربية منه
    on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message)); // e.message تحتوي على: "اسم المستخدم أو كلمة المرور غير صحيحة"
    } 
    // 🔥 2. اصطياد أخطاء السيرفر الأخرى (مثل 404، 500)
    on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } 
    // 🔥 3. اصطياد أي خطأ برمجي آخر غير متوقع
    catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع، الرجاء المحاولة لاحقاً'));
    }
  }
}