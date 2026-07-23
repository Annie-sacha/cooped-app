import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:5123/api';
  // ⚠️ Pour tester sur un téléphone physique ou un émulateur Android,
  // remplace 'localhost' par l'adresse IP locale de ton ordinateur (ex: 192.168.1.X)

  final Dio dio;
  final _storage = const FlutterSecureStorage();

  ApiClient() : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // TODO : rediriger vers le login si le token a expiré
        }
        handler.next(error);
      },
    ));
  }
}