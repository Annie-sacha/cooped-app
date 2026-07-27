import 'api_client.dart';
import '../models/pret_model.dart';

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
}