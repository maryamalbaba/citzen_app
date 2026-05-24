class ResultModel<T> {

  final bool success;

  final String? message;

  final T? data;

  const ResultModel({
    required this.success,
    this.message,
    this.data,
  });
}