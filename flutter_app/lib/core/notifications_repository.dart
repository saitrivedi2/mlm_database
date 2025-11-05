import 'package:dio/dio.dart';

import 'api_client.dart';
import 'models.dart';

class NotificationsRepository {
  final Dio _dio = ApiClient.I.client;

  Future<({List<NotificationItem> items, String? nextCursor})> list({int limit = 20, String? cursor, bool unreadOnly = false}) async {
    final res = await _dio.get('/api/notifications', queryParameters: {
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (unreadOnly) 'unread': 'true',
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final items = (res.data['items'] as List).map((e) => NotificationItem.fromJson(e)).toList();
      return (items: items, nextCursor: res.data['nextCursor'] as String?);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<int> markRead(List<String> ids) async {
    final res = await _dio.post('/api/notifications/read', data: {'ids': ids});
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return (res.data['count'] as num?)?.toInt() ?? 0;
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<void> deleteOne(String id) async {
    final res = await _dio.delete('/api/notifications/$id');
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res);
    }
  }

  Future<int> adminBroadcast({required String title, required String message, String type = 'ADMIN_BROADCAST'}) async {
    final res = await _dio.post('/api/admin/notifications/broadcast', data: {
      'title': title,
      'message': message,
      'type': type,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return (res.data['count'] as num?)?.toInt() ?? 0;
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }
}
