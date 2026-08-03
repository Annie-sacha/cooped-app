import 'api_client.dart';
import '../models/frais_model.dart';

class FraisService {
  final ApiClient _apiClient = ApiClient();

  Future<List<FraisModel>> getByClient(int clientId) async {
    final response = await _apiClient.dio.get('/frais/client/$clientId');
    return (response.data as List).map((e) => FraisModel.fromJson(e)).toList();
  }
}