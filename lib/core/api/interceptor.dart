import 'package:dio/dio.dart';
import '../auth/token_provider.dart';

class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider = TokenProvider();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _tokenProvider.getIdToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // ignore errors; request proceeds without auth
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Could map errors to typed exceptions here
    return handler.next(err);
  }
}
