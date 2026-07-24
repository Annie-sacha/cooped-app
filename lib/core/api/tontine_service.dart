import 'api_client.dart';
import '../models/tontine_model.dart';
import '../models/carnet_model.dart';



class TontineService {
  final ApiClient _apiClient = ApiClient();

  Future<void> creer({required int clientId, required double mise, int nbreMise = 31}) async {
    await _apiClient.dio.post('/tontines', data: {
      'clientId': clientId,
      'mise': mise,
      'nbreMise': nbreMise,
    });
  }

  Future<Map<String, dynamic>> ajouterCotisation({
    required int tontineId,
    required double montant,
    int nbreMise = 1,
  }) async {
    final response = await _apiClient.dio.post('/tontines/$tontineId/cotisations', data: {
      'montant': montant,
      'nbreMise': nbreMise,
    });
    return response.data;
  }

  Future<CarnetModel> getCarnet(int tontineId) async {
    final response = await _apiClient.dio.get('/tontines/$tontineId/carnet');
    return CarnetModel.fromJson(response.data);
  }


  Future<List<TontineModel>> getByClient(int clientId) async {
    final response = await _apiClient.dio.get('/tontines/client/$clientId');
    return (response.data as List).map((e) => TontineModel.fromJson(e)).toList();
  }
  Future<void> supprimerCotisation(int cotisationId) async {
    await _apiClient.dio.delete('/tontines/cotisations/$cotisationId');
  }


}