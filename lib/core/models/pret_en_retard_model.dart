class PretEnRetardModel {
  final int pretId;
  final double montant;
  final String dateEcheance;
  final String type;

  PretEnRetardModel({required this.pretId, required this.montant, required this.dateEcheance, required this.type});

  factory PretEnRetardModel.fromJson(Map<String, dynamic> json) => PretEnRetardModel(
        pretId: json['pretId'],
        montant: (json['montant'] as num).toDouble(),
        dateEcheance: json['dateEcheance'],
        type: json['type'],
      );
}