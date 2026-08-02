import 'api_client.dart';
import '../models/statistique_model.dart';

class StatistiqueService {
  final ApiClient _apiClient = ApiClient();

  Future<StatistiqueGlobaleModel> obtenir() async {
    final response = await _apiClient.dio.get('/statistiques');
    return StatistiqueGlobaleModel.fromJson(response.data);
  }
}