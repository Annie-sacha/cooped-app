import 'api_client.dart';
import '../models/client_model.dart';
import '../models/penalite_result_model.dart';


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


  Future<List<ClientModel>> getAll() async {
    final response = await _apiClient.dio.get('/clients');
    return (response.data as List).map((e) => ClientModel.fromJson(e)).toList();
  }

  Future<void> update({
    required int id,
    required String nomCli,
    required String prenomCli,
    String? telephone,
    String? quartier,
  }) async {
    await _apiClient.dio.put('/clients/$id', data: {
      'nomCli': nomCli,
      'prenomCli': prenomCli,
      'telephone': telephone,
      'quartier': quartier,
    });
  }

  Future<void> delete(int id) async {
    await _apiClient.dio.delete('/clients/$id');
  }

  Future<void> definirDepotRequis(int id, double? montant) async {
    await _apiClient.dio.put('/clients/$id/depot-requis', data: {'montant': montant});
  }


  Future<List<PenaliteResultModel>> verifierPenalites(int clientId) async {
    final response = await _apiClient.dio.get('/clients/$clientId/verifier-penalites');
    return (response.data as List).map((e) => PenaliteResultModel.fromJson(e)).toList();
  }
  
}