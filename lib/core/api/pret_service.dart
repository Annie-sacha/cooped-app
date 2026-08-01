import 'api_client.dart';
import '../models/pret_model.dart';
import '../models/pret_list_model.dart';


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

  Future<void> valider(int id) async => _apiClient.dio.put('/prets/$id/valider');
  Future<void> rejeter(int id) async => _apiClient.dio.put('/prets/$id/rejeter');



}