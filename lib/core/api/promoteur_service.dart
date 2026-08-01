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
}