import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/pret_model.dart';
import '../models/pret_list_model.dart';
import '../models/pret_info_tontine_model.dart';

class PretService {
  final ApiClient _apiClient = ApiClient();

  Future<PretResultModel> creer({
    required int clientId,
    required double montantMise,
    required TypePret type,
  }) async {
    final response = await _apiClient.dio.post('/prets', data: {
      'clientId': clientId,
      'montantMise': montantMise,
      'type': type == TypePret.mensuel ? 'Mensuel' : 'Quinzaine',
    });
    return PretResultModel.fromJson(response.data);
  }

  Future<List<PretListModel>> getEnAttente() async {
    final response = await _apiClient.dio.get('/prets/en-attente');
    return (response.data as List).map((e) => PretListModel.fromJson(e)).toList();
  }

  Future<void> valider(int id, String motif) async =>
      _apiClient.dio.put('/prets/$id/valider', data: {'motif': motif});

  Future<void> rejeter(int id, String motif) async =>
      _apiClient.dio.put('/prets/$id/rejeter', data: {'motif': motif});

  Future<PretInfoTontineModel?> getInfoParTontine(int tontineId) async {
    try {
      final response = await _apiClient.dio.get('/prets/tontine/$tontineId');
      return PretInfoTontineModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}