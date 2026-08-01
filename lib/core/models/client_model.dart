class ClientModel {
  final int id;
  final String nomCli;
  final String prenomCli;
  final String? telephone;
  final String? quartier;
  final int promoteurId;
  final double? montantDepotRequis;

  ClientModel({
    required this.id,
    required this.nomCli,
    required this.prenomCli,
    this.telephone,
    this.quartier,
    required this.promoteurId,
    this.montantDepotRequis,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json['id'],
        nomCli: json['nomCli'],
        prenomCli: json['prenomCli'],
        telephone: json['telephone'],
        quartier: json['quartier'],
        promoteurId: json['promoteurId'],
        montantDepotRequis: (json['montantDepotRequis'] as num?)?.toDouble(),
      );

  String get nomComplet => '$prenomCli $nomCli'.trim();

  String get initiale {
    if (prenomCli.isNotEmpty) return prenomCli[0];
    if (nomCli.isNotEmpty) return nomCli[0];
    return '?';
  }
}