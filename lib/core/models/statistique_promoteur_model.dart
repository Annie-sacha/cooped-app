class StatistiquePromoteurModel {
  final int totalClients;
  final int tontinesActives;
  final int tontinesCloturees;
  final double totalCollecte;
  final double totalRetire;
  final double totalPrete;

  StatistiquePromoteurModel({
    required this.totalClients,
    required this.tontinesActives,
    required this.tontinesCloturees,
    required this.totalCollecte,
    required this.totalRetire,
    required this.totalPrete,
  });

  factory StatistiquePromoteurModel.fromJson(Map<String, dynamic> json) => StatistiquePromoteurModel(
        totalClients: json['totalClients'],
        tontinesActives: json['tontinesActives'],
        tontinesCloturees: json['tontinesCloturees'],
        totalCollecte: (json['totalCollecte'] as num).toDouble(),
        totalRetire: (json['totalRetire'] as num).toDouble(),
        totalPrete: (json['totalPrete'] as num).toDouble(),
      );
}