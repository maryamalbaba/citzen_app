import 'dart:convert';

class ProcessAuthResponse {
  final bool success;
  final int statusCode;
  final String message;
  final AuthProcessData data;

  ProcessAuthResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProcessAuthResponse.fromJson(Map<String, dynamic> json) {
    return ProcessAuthResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: AuthProcessData.fromJson(json['data'] ?? {}),
    );
  }
}

class AuthProcessData {
  final List<AuthProcessModel> items;
  final PaginationModel pagination;

  AuthProcessData({
    required this.items,
    required this.pagination,
  });

  factory AuthProcessData.fromJson(Map<String, dynamic> json) {
    return AuthProcessData(
      items: (json['items'] as List?)
              ?.map((item) => AuthProcessModel.fromJson(item))
              .toList() ?? [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class AuthProcessModel {
  final int processId;
  final String name;
  final String code;
  final int priority;
  final Map<String, dynamic> authStage; // يمكنكِ تفصيلها لاحقاً إذا لزم الأمر

  AuthProcessModel({
    required this.processId,
    required this.name,
    required this.code,
    required this.priority,
    required this.authStage,
  });

  factory AuthProcessModel.fromJson(Map<String, dynamic> json) {
    return AuthProcessModel(
      processId: json['process_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      priority: json['priority'] ?? 0,
      authStage: json['auth_stage'] ?? {},
    );
  }
}

class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      hasNext: json['has_next'] ?? false,
      hasPrev: json['has_prev'] ?? false,
    );
  }
}