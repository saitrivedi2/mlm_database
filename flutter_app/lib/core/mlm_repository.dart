import 'package:dio/dio.dart';

import 'api_client.dart';
import 'models.dart';

class MlmRepository {
  final Dio _dio = ApiClient.I.client;

  Future<Map<String, dynamic>> getTree({int depth = 3, String? userId}) async {
    final res = await _dio.get('/mlm/tree', queryParameters: {
      'depth': depth,
      if (userId != null) 'userId': userId,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return Map<String, dynamic>.from(res.data);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<List<DownlineMember>> listDownline({int depth = 8, String? userId, String mode = 'all'}) async {
    final res = await _dio.get('/mlm/downline', queryParameters: {
      'depth': depth,
      if (userId != null) 'userId': userId,
      'mode': mode,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return (res.data['members'] as List).map((e) => DownlineMember.fromJson(e)).toList();
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<({List<CommissionEntry> items, List<Map<String, dynamic>> summary})> commissionReport({int? level, int limit = 100, DateTime? from, DateTime? to}) async {
    final res = await _dio.get('/mlm/commissions', queryParameters: {
      if (level != null) 'level': level,
      'limit': limit,
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final items = (res.data['items'] as List).map((e) => CommissionEntry.fromJson(e)).toList();
      final summary = (res.data['summary'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
      return (items: items, summary: summary);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }
}
