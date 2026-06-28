import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/pagenationEntity.dart';


class PaginationModel2 extends PaginationEntity {
  const PaginationModel2({
    required super.page,
    required super.limit,
    required super.total,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrev,
  });

  factory PaginationModel2.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationModel2(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['total_pages'],
      hasNext: json['has_next'],
      hasPrev: json['has_prev'],
    );
  }
}