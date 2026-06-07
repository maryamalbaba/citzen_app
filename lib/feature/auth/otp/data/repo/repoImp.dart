
import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';
import 'package:citzenapp/feature/auth/otp/data/source/remotedata.dart';
import 'package:citzenapp/feature/auth/otp/domain/repo/repootp.dart';
import 'package:citzenapp/feature/auth/register/data/model/user_model.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:dartz/dartz.dart';

class OtpStepRepositoryImpl implements OtpRepo {
  final remotOtpImpl remote;
 final TokenStorage tokenStorage;

  OtpStepRepositoryImpl(this.remote, this.tokenStorage, );

  @override
  Future<Either<Failure, UserEntity>> OtpStep({required OtpModel otp}) async{
   
try{
final response=await  remote.OtpStep(otp_model: otp);

 if (response['success'] != true) {
        return Left(
          ServerFailure(
            response['message'] ?? 'حدث خطأ غير معروف',
          ),
        );
      }

       /// TOKEN
      /// 1. استخراج التوكن والريفريش توكن من الاستجابة
      final accessToken = response['data']['token'];
      final refreshToken = response['data']['refreshToken'];

    /// 2. حفظ التوكنين معاً باستخدام الدالة الجديدة
      await tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

       /// response model
      final Responsedata = UserModel.fromMap(
        response['data']['user'],


      );
  return Right(
        Responsedata,
      );

} on UnauthorizedException catch (e) {
      return Left(
        UnauthorizedFailure(e.message),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    } catch (e) {
      print(
        'otp ERROR => $e',
      );

      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }
  
}
  
  


 
