enum TypePret { mensuel, quinzaine }

class PretResultModel {
  final int pretId;
  final int tontineId;
  final double montantMise;
  final double frais;
  final double montantPrete;
  final String dateEcheance;

  PretResultModel({
    required this.pretId,
    required this.tontineId,
    required this.montantMise,
    required this.frais,
    required this.montantPrete,
    required this.dateEcheance,
  });

  factory PretResultModel.fromJson(Map<String, dynamic> json) => PretResultModel(
        pretId: json['pretId'],
        tontineId: json['tontineId'],
        montantMise: (json['montantMise'] as num).toDouble(),
        frais: (json['frais'] as num).toDouble(),
        montantPrete: (json['montantPrete'] as num).toDouble(),
        dateEcheance: json['dateEcheance'],
      );
}