import 'package:equatable/equatable.dart';

/// كيان عام يمثل استجابة عمليات: إنشاء PIN و تغيير PIN
/// (كلاهما يرجعان فقط رسالة نجاح من الباك اند).
class PinMessage extends Equatable {
  final String message;

  const PinMessage({required this.message});

  @override
  List<Object?> get props => [message];
}
