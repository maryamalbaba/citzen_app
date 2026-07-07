import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/pin_verevicationEntity.dart';
import 'package:citzenapp/feature/pinFeature/domin/repository/repo.dart';
import 'package:citzenapp/feature/pinFeature/domin/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';



class VerifyPinUseCase
    implements UseCase<PinVerificationResult, VerifyPinParams> {
  final PinRepository repository;

  VerifyPinUseCase(this.repository);

  @override
  Future<Either<Failure, PinVerificationResult>> call(
    VerifyPinParams params,
  ) {
    return repository.verifyPin(pin: params.pin);
  }
}

class VerifyPinParams extends Equatable {
  final String pin;

  const VerifyPinParams({required this.pin});

  @override
  List<Object?> get props => [pin];
}