class StatPromoteurModel {
  final String nomPromoteur;
  final int nombreClients;
  final double totalCollecte;

  StatPromoteurModel({required this.nomPromoteur, required this.nombreClients, required this.totalCollecte});

  factory StatPromoteurModel.fromJson(Map<String, dynamic> json) => StatPromoteurModel(
        nomPromoteur: json['nomPromoteur'],
        nombreClients: json['nombreClients'],
        totalCollecte: (json['totalCollecte'] as num).toDouble(),
      );
}

class StatistiqueGlobaleModel {
  final int totalClients;
  final int totalPromoteurs;
  final double totalCotise;
  final double totalRetire;
  final double totalPrete;
  final double totalFraisPercus;
  final int tontinesActives;
  final int tontinesCloturees;
  final List<StatPromoteurModel> parPromoteur;
  final int retraitsValides;
  final int retraitsRefuses;
  final double fraisNormaleEtAchat;

  StatistiqueGlobaleModel({
    required this.totalClients,
    required this.totalPromoteurs,
    required this.totalCotise,
    required this.totalRetire,
    required this.totalPrete,
    required this.totalFraisPercus,
    required this.tontinesActives,
    required this.tontinesCloturees,
    required this.parPromoteur,
    required this.retraitsValides,
    required this.retraitsRefuses,
    required this.fraisNormaleEtAchat,
  });

  factory StatistiqueGlobaleModel.fromJson(Map<String, dynamic> json) => StatistiqueGlobaleModel(
        totalClients: json['totalClients'],
        totalPromoteurs: json['totalPromoteurs'],
        totalCotise: (json['totalCotise'] as num).toDouble(),
        totalRetire: (json['totalRetire'] as num).toDouble(),
        totalPrete: (json['totalPrete'] as num).toDouble(),
        totalFraisPercus: (json['totalFraisPercus'] as num).toDouble(),
        tontinesActives: json['tontinesActives'],
        tontinesCloturees: json['tontinesCloturees'],
        parPromoteur: (json['parPromoteur'] as List).map((e) => StatPromoteurModel.fromJson(e)).toList(),
        retraitsValides: (json['retraitsValides']),
        retraitsRefuses: (json['retraitsRefuses']),
        fraisNormaleEtAchat: (json['fraisNormaleEtAchat']),
      );
}