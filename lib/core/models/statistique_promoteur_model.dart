class StatistiquePromoteurModel {
  final int totalClients;
  final int tontinesActives;
  final int tontinesCloturees;
  final double totalCollecte;
  final double totalRetire;
  final double totalPrete;
  final int pretsValides;
  final int pretsRefuses;
  final int retraitsValides;
  final int retraitsRefuses;

  StatistiquePromoteurModel({
    required this.totalClients,
    required this.tontinesActives,
    required this.tontinesCloturees,
    required this.totalCollecte,
    required this.totalRetire,
    required this.totalPrete,
    required this.pretsValides, 
    required this.pretsRefuses, 
    required this.retraitsValides, 
    required this.retraitsRefuses,

  });

  factory StatistiquePromoteurModel.fromJson(Map<String, dynamic> json) => StatistiquePromoteurModel(
        totalClients: json['totalClients'],
        tontinesActives: json['tontinesActives'],
        tontinesCloturees: json['tontinesCloturees'],
        totalCollecte: (json['totalCollecte'] as num).toDouble(),
        totalRetire: (json['totalRetire'] as num).toDouble(),
        totalPrete: (json['totalPrete'] as num).toDouble(),
        pretsValides: json['pretsValides'], 
        pretsRefuses: json['pretsRefuses'],
        retraitsValides: json['retraitsValides'], 
        retraitsRefuses: json['retraitsRefuses'],
      );
}