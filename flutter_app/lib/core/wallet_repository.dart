import 'package:dio/dio.dart';
import 'api_client.dart';
import 'models.dart';

class WalletRepository {
  final Dio _dio = ApiClient.I.client;

  Future<WalletData> getWallet() async {
    final res = await _dio.get('/wallet');
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return WalletData.fromJson(res.data['wallet']);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<WalletData> transferReferralToMain({required double amount, required String pin}) async {
    final res = await _dio.post('/wallet/transfer', data: {
      'amount': amount,
      'pin': pin,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return WalletData.fromJson(res.data['wallet']);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<({List<TransactionItem> items, String? nextCursor})> listTransactions({int limit = 20, String? cursor}) async {
    final res = await _dio.get('/wallet/transactions', queryParameters: {
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final list = (res.data['items'] as List).map((e) => TransactionItem.fromJson(e)).toList();
      return (items: list, nextCursor: res.data['nextCursor'] as String?);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }
}
