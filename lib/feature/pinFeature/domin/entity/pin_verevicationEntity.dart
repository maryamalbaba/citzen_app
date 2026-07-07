import 'package:equatable/equatable.dart';

/// كيان يمثل نتيجة التحقق من رمز PIN (فتح قفل التطبيق).
class PinVerificationResult extends Equatable {
  final bool unlocked;
  final String message;

  const PinVerificationResult({
    required this.unlocked,
    required this.message,
  });

  @override
  List<Object?> get props => [unlocked, message];
}
