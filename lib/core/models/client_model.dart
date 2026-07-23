class ClientModel {
  final int id;
  final String nomCli;
  final String prenomCli;
  final String? telephone;
  final String? quartier;

  ClientModel({
    required this.id,
    required this.nomCli,
    required this.prenomCli,
    this.telephone,
    this.quartier,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json['id'],
        nomCli: json['nomCli'],
        prenomCli: json['prenomCli'],
        telephone: json['telephone'],
        quartier: json['quartier'],
      );

  String get nomComplet => '$prenomCli $nomCli';
}