import 'api_client.dart';
import '../models/achat_model.dart';

class AchatService {
  final ApiClient _apiClient = ApiClient();


  Future<void> creer({
    required int clientId,
    required double montant,
    required String article,
    bool ouvrirTontine = false,
    double? miseTontine,
    int? nbreMiseTontine,
  }) async {
    await _apiClient.dio.post('/achats', data: {
      'clientId': clientId,
      'montant': montant,
      'article': article,
      'ouvrirTontine': ouvrirTontine,
      'miseTontine': miseTontine,
      'nbreMiseTontine': nbreMiseTontine,
    });
  }

  Future<List<AchatModel>> getByClient(int clientId) async {
    final response = await _apiClient.dio.get('/achats/client/$clientId');
    return (response.data as List).map((e) => AchatModel.fromJson(e)).toList();
  }
}