import 'api_client.dart';
import '../models/ligne_suivi_model.dart';
import '../models/ligne_pret_suivi_model.dart';


class SuiviService {
  final ApiClient _apiClient = ApiClient();

  Future<List<LigneSuiviModel>> getSuivi(int clientId) async {
    final response = await _apiClient.dio.get('/clients/$clientId/suivi');
    return (response.data as List).map((e) => LigneSuiviModel.fromJson(e)).toList();
  }

  Future<List<LigneSuiviModel>> getSuiviAchat(int clientId) async {
    final response = await _apiClient.dio.get('/clients/$clientId/suivi-achat');
    return (response.data as List).map((e) => LigneSuiviModel.fromJson(e)).toList();
  }

  Future<List<LignePretSuiviModel>> getSuiviPret(int clientId) async {
    final response = await _apiClient.dio.get('/clients/$clientId/suivi-pret');
    return (response.data as List).map((e) => LignePretSuiviModel.fromJson(e)).toList();
  }
}



