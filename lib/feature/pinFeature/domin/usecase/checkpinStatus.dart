
import 'package:citzenapp/feature/pinFeature/domin/repository/repo.dart';

/// يوز كيس بسيط لا يتعامل مع الشبكة إطلاقاً، فقط يقرأ حالة محلية.
/// لذلك لا نلفّه بـ Either<Failure, ..> فلا يوجد سيناريو فشل شبكة هنا.
class CheckPinStatusUseCase {
  final PinRepository repository;

  CheckPinStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.hasPinCreated();
  }
}