import 'package:dio/dio.dart';

import '../services/secure_storage_service.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:39
 * Project Name: IntelliJ IDEA
 * File Name: auth_interceptor


 */

class AuthInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await SecureStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token expiration
      await SecureStorageService.deleteToken();
      // You can also add a stream controller to notify the app about authentication errors
    }
    super.onError(err, handler);
  }
}