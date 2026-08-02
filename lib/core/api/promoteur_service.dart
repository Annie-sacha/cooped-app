import 'api_client.dart';
import '../models/client_model.dart';
import '../models/promoteur_model.dart';

class PromoteurService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ClientModel>> getClients(int promoteurId) async {
    final response = await _apiClient.dio.get('/promoteurs/$promoteurId/clients');
    return (response.data as List).map((e) => ClientModel.fromJson(e)).toList();
  }

  Future<PromoteurModel> getById(int id) async {
    final response = await _apiClient.dio.get('/promoteurs/$id');
    return PromoteurModel.fromJson(response.data);
  }

  Future<List<PromoteurModel>> getAll() async {
    final response = await _apiClient.dio.get('/promoteurs');
    return (response.data as List).map((e) => PromoteurModel.fromJson(e)).toList();
  }

  Future<void> create({
    required String nom,
    required String telephone,
    required String email,
    required String motDePasse,
  }) async {
    await _apiClient.dio.post('/promoteurs', data: {
      'nom': nom,
      'telephone': telephone,
      'email': email,
      'motDePasse': motDePasse,
    });
  }

  Future<void> update({
    required int id,
    required String nom,
    required String telephone,
    required String email,
  }) async {
    await _apiClient.dio.put('/promoteurs/$id', data: {
      'nom': nom,
      'telephone': telephone,
      'email': email,
    });
  }

  Future<void> delete(int id) async {
    await _apiClient.dio.delete('/promoteurs/$id');
  }

  Future<void> reinitialiserMotDePasse(int id, String nouveauMotDePasse) async {
    await _apiClient.dio.put('/promoteurs/$id/mot-de-passe', data: {'nouveauMotDePasse': nouveauMotDePasse});
  }
}