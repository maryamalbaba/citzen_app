import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/processes/data/models/auth_process_model.dart';
import 'package:citzenapp/feature/processes/domain/repo/auth_process_repository.dart';
import 'package:dartz/dartz.dart';


class GetAuthProcessesUseCase {
  final AuthProcessRepository repository;

  GetAuthProcessesUseCase(this.repository);

  Future<Either<Failure, ProcessAuthResponse>> call(AuthProcessParams params) async {
    return await repository.getAuthProcesses(
      id: params.id,
      page: params.page,
      limit: params.limit,
    );
  }
}

// كلاس لتمرير المعاملات بشكل منظم للـ Use Case
class AuthProcessParams {
  final num id;
  final int page;
  final int limit;

  AuthProcessParams({
    required this.id,
    required this.page,
    this.limit = 10, // قيمة افتراضية لحجم الصفحة
  });
}