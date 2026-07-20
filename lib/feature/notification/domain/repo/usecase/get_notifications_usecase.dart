
import 'package:citzenapp/feature/notification/data/models/notifications_response_model.dart';
import 'package:citzenapp/feature/notification/domain/repo/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<NotificationsResponseModel> call({
    String? cursor,
    int limit = 10,
    bool? unread,
  }) async {
    return await repository.getNotifications(
      cursor: cursor,
      limit: limit,
      unread: unread,
    );
  }
}