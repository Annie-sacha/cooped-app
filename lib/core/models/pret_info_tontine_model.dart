class PretInfoTontineModel {
  final int pretId;
  final String type;
  final String phase;
  final double montantPrete;
  final double frais;
  final String statutValidation;

  PretInfoTontineModel({
    required this.pretId,
    required this.type,
    required this.phase,
    required this.montantPrete,
    required this.frais,
    required this.statutValidation,
  });

  factory PretInfoTontineModel.fromJson(Map<String, dynamic> json) => PretInfoTontineModel(
        pretId: json['pretId'],
        type: json['type'],
        phase: json['phase'],
        montantPrete: (json['montantPrete'] as num).toDouble(),
        frais: (json['frais'] as num).toDouble(),
        statutValidation: json['statutValidation'],
      );
}