class PaginationModel {
  final int limit;
  final String? cursor;
  final String? nextCursor;
  final bool hasNext;
  final bool hasPrev;

  PaginationModel({
    required this.limit,
    this.cursor,
    this.nextCursor,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      limit: json['limit'] ?? 10,
      cursor: json['cursor'],
      nextCursor: json['next_cursor'],
      hasNext: json['has_next'] ?? false,
      hasPrev: json['has_prev'] ?? false,
    );
  }
}