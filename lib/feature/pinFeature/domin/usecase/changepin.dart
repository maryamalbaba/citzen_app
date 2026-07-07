import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/messageentity.dart';
import 'package:citzenapp/feature/pinFeature/domin/repository/repo.dart';
import 'package:citzenapp/feature/pinFeature/domin/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';



class ChangePinUseCase implements UseCase<PinMessage, ChangePinParams> {
  final PinRepository repository;

  ChangePinUseCase(this.repository);

  @override
  Future<Either<Failure, PinMessage>> call(ChangePinParams params) {
    return repository.changePin(
      oldPin: params.oldPin,
      newPin: params.newPin,
      confirmNewPin: params.confirmNewPin,
    );
  }
}

class ChangePinParams extends Equatable {
  final String oldPin;
  final String newPin;
  final String confirmNewPin;

  const ChangePinParams({
    required this.oldPin,
    required this.newPin,
    required this.confirmNewPin,
  });

  @override
  List<Object?> get props => [oldPin, newPin, confirmNewPin];
}