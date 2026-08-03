class PenaliteResultModel {
  final bool penaliteAppliquee;
  final double? montantPenalite;
  final String? nouvelleEcheance;
  final String message;

  PenaliteResultModel({
    required this.penaliteAppliquee,
    this.montantPenalite,
    this.nouvelleEcheance,
    required this.message,
  });

  factory PenaliteResultModel.fromJson(Map<String, dynamic> json) => PenaliteResultModel(
        penaliteAppliquee: json['penaliteAppliquee'],
        montantPenalite: (json['montantPenalite'] as num?)?.toDouble(),
        nouvelleEcheance: json['nouvelleEcheance'],
        message: json['message'],
      );
}