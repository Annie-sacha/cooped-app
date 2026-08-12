class LignePretSuiviModel {
  final String date;
  final String type;
  final double montant;
  final String statutValidation;
  final String statut;

  LignePretSuiviModel({
    required this.date,
    required this.type,
    required this.montant,
    required this.statutValidation,
    required this.statut,
  });

  factory LignePretSuiviModel.fromJson(Map<String, dynamic> json) => LignePretSuiviModel(
        date: json['date'],
        type: json['type'],
        montant: (json['montant'] as num).toDouble(),
        statutValidation: json['statutValidation'],
        statut: json['statut'],
      );
}