import 'package:dio/dio.dart';
import 'api_client.dart';
import 'models.dart';

class AuthRepository {
  final Dio _dio = ApiClient.I.client;

  Future<(ApiUser user, String token)> login({required String identifier, String? password, String? code}) async {
    final res = await _dio.post('/auth/login', data: {
      'identifier': identifier,
      if (password != null) 'password': password,
      if (code != null) 'code': code,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final token = res.data['token'] as String? ?? '';
      await ApiClient.I.saveToken(token);
      return (ApiUser.fromJson(res.data['user']), token);
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
  }

  Future<void> loginRequestOtp(String identifier) async {
    final res = await _dio.post('/auth/login/request-otp', data: {'identifier': identifier});
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<(ApiUser user, String token)> verifyOtp({required String type, required String identifier, required String code, String? referralCode}) async {
    final res = await _dio.post('/auth/verify-otp', data: {
      'type': type,
      'identifier': identifier,
      'code': code,
      if (referralCode != null) 'referralCode': referralCode,
    });
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final token = res.data['token'] as String? ?? '';
      await ApiClient.I.saveToken(token);
      return (ApiUser.fromJson(res.data['user']), token);
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
  }

  Future<void> requestOtp({required String type, required String identifier}) async {
    final res = await _dio.post('/auth/request-otp', data: {'type': type, 'identifier': identifier});
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<Map<String, dynamic>> signup({required String username, String? email, required String phone, String? password, String? referralCode}) async {
    final res = await _dio.post('/auth/signup', data: {
      'username': username,
      if (email != null) 'email': email,
      'phone': phone,
      if (password != null) 'password': password,
      if (referralCode != null) 'referralCode': referralCode,
    });
    if (res.statusCode == 201 && res.data['ok'] == true) {
      return Map<String, dynamic>.from(res.data);
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
  }

  Future<Map<String, dynamic>> verifyPhoneOtp({required String phone, required String code}) async {
    final res = await _dio.post('/auth/verify-phone-otp', data: {'phone': phone, 'code': code});
    if (res.statusCode == 200 && res.data['ok'] == true) {
      final token = res.data['token'] as String? ?? '';
      await ApiClient.I.saveToken(token);
      return Map<String, dynamic>.from(res.data);
    }
    throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
  }

  Future<void> setTransactionPin(String pin) async {
    final res = await _dio.post('/auth/set-pin', data: {'pin': pin});
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<void> forgotPasswordRequestOtp(String identifier) async {
    final res = await _dio.post('/auth/forgot-password/request-otp', data: {'identifier': identifier});
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<void> resetPassword({required String identifier, required String code, required String newPassword, String type = 'EMAIL'}) async {
    final res = await _dio.post('/auth/forgot-password/reset', data: {
      'identifier': identifier,
      'code': code,
      'newPassword': newPassword,
      'type': type,
    });
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<void> forgotPinRequestOtp(String identifier) async {
    final res = await _dio.post('/auth/forgot-pin/request-otp', data: {'identifier': identifier});
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<void> resetPin({required String identifier, required String code, required String newPin}) async {
    final res = await _dio.post('/auth/forgot-pin/reset', data: {
      'identifier': identifier,
      'code': code,
      'newPin': newPin,
    });
    if (res.statusCode != 200 || res.data['ok'] != true) {
      throw DioException(requestOptions: res.requestOptions, response: res, error: res.data);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await ApiClient.I.clearToken();
    }
  }
}
