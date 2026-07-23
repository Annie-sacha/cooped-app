import 'api_client.dart';
import '../models/client_model.dart';

class ClientService {
  final ApiClient _apiClient = ApiClient();

  Future<ClientModel> getById(int id) async {
    final response = await _apiClient.dio.get('/clients/$id');
    return ClientModel.fromJson(response.data);
  }

  Future<void> create({
    required String nomCli,
    required String prenomCli,
    String? telephone,
    String? quartier,
    required int promoteurId,
  }) async {
    await _apiClient.dio.post('/clients', data: {
      'nomCli': nomCli,
      'prenomCli': prenomCli,
      'telephone': telephone,
      'quartier': quartier,
      'promoteurId': promoteurId,
    });
  }
}