import 'api_client.dart';
import '../models/client_model.dart';

class PromoteurService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ClientModel>> getClients(int promoteurId) async {
    final response = await _apiClient.dio.get('/promoteurs/$promoteurId/clients');
    return (response.data as List).map((e) => ClientModel.fromJson(e)).toList();
  }
}