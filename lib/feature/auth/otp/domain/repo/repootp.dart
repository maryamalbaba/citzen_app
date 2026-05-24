import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';
import 'package:citzenapp/feature/auth/otp/domain/entity/entityOtp.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:dartz/dartz.dart';

abstract class OtpRepo {
 

  Future<Either<Failure, UserEntity>> OtpStep({required OtpModel otp}) ;}