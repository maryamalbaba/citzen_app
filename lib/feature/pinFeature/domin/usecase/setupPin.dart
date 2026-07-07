import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/messageentity.dart';
import 'package:citzenapp/feature/pinFeature/domin/repository/repo.dart';
import 'package:citzenapp/feature/pinFeature/domin/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class SetupPinUseCase implements UseCase<PinMessage, SetupPinParams> {
  final PinRepository repository;

  SetupPinUseCase(this.repository);

  @override
  Future<Either<Failure, PinMessage>> call(SetupPinParams params) {
    return repository.setupPin(
      pin: params.pin,
      confirmPin: params.confirmPin,
    );
  }
}

class SetupPinParams extends Equatable {
  final String pin;
  final String confirmPin;

  const SetupPinParams({required this.pin, required this.confirmPin});

  @override
  List<Object?> get props => [pin, confirmPin];
}