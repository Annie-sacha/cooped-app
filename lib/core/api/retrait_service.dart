import 'api_client.dart';
import '../models/retrait_model.dart';
import '../models/retrait_en_attente_model.dart';

class RetraitService {
  final ApiClient _apiClient = ApiClient();

  Future<void> creer({required int clientId, required double montantTotal, String? motif}) async {
    await _apiClient.dio.post('/retraits', data: {
      'clientId': clientId,
      'montantTotal': montantTotal,
      'motif': motif,
    });
  }

  Future<List<RetraitModel>> getByClient(int clientId) async {
    final response = await _apiClient.dio.get('/retraits/client/$clientId');
    return (response.data as List).map((e) => RetraitModel.fromJson(e)).toList();
  }

  Future<List<RetraitEnAttenteModel>> getEnAttente() async {
    final response = await _apiClient.dio.get('/retraits/en-attente');
    return (response.data as List).map((e) => RetraitEnAttenteModel.fromJson(e)).toList();
  }

  Future<void> valider(int id, String motif) async =>
      _apiClient.dio.put('/retraits/$id/valider', data: {'motif': motif});

  Future<void> rejeter(int id, String motif) async =>
      _apiClient.dio.put('/retraits/$id/rejeter', data: {'motif': motif});
}