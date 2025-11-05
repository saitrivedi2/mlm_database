import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_client.dart';
import 'models.dart';

class PaymentsRepository {
  final Dio _dio = ApiClient.I.client;

  Future<List<PlanItem>> getPlans() async {
    final res = await _dio.get('/payments/plans');
    if (res.statusCode == 200 && res.data is Map && res.data['ok'] == true) {
      final items = (res.data['plans'] as List? ?? res.data['items'] as List? ?? [])
          .map((e) => PlanItem.fromJson(e))
          .toList();
      return items;
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<Map<String, dynamic>> createTokenPurchaseOrder({required String planId}) async {
    final res = await _dio.post('/payments/token/purchase', data: {'planId': planId});
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return Map<String, dynamic>.from(res.data);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<List<TokenPurchaseItem>> listTokenPurchases() async {
    final res = await _dio.get('/payments/token/purchases');
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final list = (res.data['items'] as List).map((e) => TokenPurchaseItem.fromJson(e)).toList();
      return list;
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<Uint8List> downloadInvoice(String purchaseId) async {
    final res = await _dio.get(
      '/payments/token/purchases/$purchaseId/invoice',
      options: Options(responseType: ResponseType.bytes),
    );
    if (res.statusCode == 200) {
      return Uint8List.fromList((res.data as List<int>));
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<Map<String, dynamic>> addFundsOrder({required double amount, String currency = 'INR'}) async {
    final res = await _dio.post('/payments/add-funds/order', data: {
      'amount': amount,
      'currency': currency,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return Map<String, dynamic>.from(res.data);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<Map<String, dynamic>> withdraw({required double amount, required String method, required Map<String, dynamic> details, required String pin}) async {
    final res = await _dio.post('/payments/withdraw', data: {
      'amount': amount,
      'method': method, // 'UPI' or 'BANK'
      'details': details,
      'pin': pin,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return Map<String, dynamic>.from(res.data);
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<List<TransactionItem>> paymentTransactions() async {
    final res = await _dio.get('/payments/transactions');
    if (res.statusCode == 200 && res.data['ok'] == true) {
      return (res.data['items'] as List).map((e) => TransactionItem.fromJson(e)).toList();
    }
    throw DioException(requestOptions: res.requestOptions, response: res);
  }

  Future<void> adminApproveWithdrawal(String id) async {
    final res = await _dio.post('/payments/withdrawals/$id/approve');
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res);
    }
  }

  Future<void> adminRejectWithdrawal(String id) async {
    final res = await _dio.post('/payments/withdrawals/$id/reject');
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res);
    }
  }

  // Helpers
  Future<void> openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
