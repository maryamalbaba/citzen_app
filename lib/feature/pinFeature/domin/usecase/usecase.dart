import 'package:citzenapp/core/error/faliure.dart';
import 'package:dartz/dartz.dart';

/// عقد موحّد لجميع الـ UseCases في المشروع.
/// [Type] هو نوع البيانات الناجحة، [Params] هو نوع المعطيات المُدخلة لليوز كيس.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// يُستخدم عندما لا يحتاج اليوز كيس أي معطيات.
class NoParams {
  const NoParams();
}
