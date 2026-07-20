import 'package:citzenapp/feature/notification/data/source/notifications_remote_datasource.dart';
import 'package:citzenapp/feature/notification/domain/repo/notifications_repository.dart';


import '../models/notifications_response_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<NotificationsResponseModel> getNotifications({
    String? cursor,
    int limit = 10,
    bool? unread,
  }) async {
    return await remoteDataSource.getNotifications(
      cursor: cursor,
      limit: limit,
      unread: unread,
    );
  }
}