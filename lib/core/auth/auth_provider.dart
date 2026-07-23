import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../models/auth_models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final _storage = const FlutterSecureStorage();

  String? _role;
  String? _nom;
  bool _isLoading = false;
  String? _error;

  String? get role => _role;
  String? get nom => _nom;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _role != null;
  int? _utilisateurId;
  int? get utilisateurId => _utilisateurId;

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    _role = await _storage.read(key: 'role');
    _nom = await _storage.read(key: 'nom');
    if (token != null) notifyListeners();
    final idString = await _storage.read(key: 'utilisateurId');
    _utilisateurId = idString != null ? int.parse(idString) : null;
  }

  Future<bool> login(String email, String motDePasse) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'motDePasse': motDePasse,
      });

      final loginResponse = LoginResponse.fromJson(response.data);

      await _storage.write(key: 'jwt_token', value: loginResponse.token);
      await _storage.write(key: 'role', value: loginResponse.role);
      await _storage.write(key: 'nom', value: loginResponse.nom);
      await _storage.write(key: 'utilisateurId', value: loginResponse.utilisateurId.toString());

      _role = loginResponse.role;
      _nom = loginResponse.nom;
      _utilisateurId = loginResponse.utilisateurId;
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        _error = 'Impossible de contacter le serveur (vérifie que l\'API tourne, ou un problème CORS).';
      } else if (e.response?.statusCode == 401) {
        _error = 'Email ou mot de passe incorrect.';
      } else {
        _error = 'Erreur inattendue : ${e.message}';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _role = null;
    _nom = null;
    notifyListeners();
  }
}