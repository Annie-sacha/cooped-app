class PenaliteModel {
  final int id;
  final String date;
  final double montant;
  final int pretId;

  PenaliteModel({required this.id, required this.date, required this.montant, required this.pretId});

  factory PenaliteModel.fromJson(Map<String, dynamic> json) => PenaliteModel(
        id: json['id'],
        date: json['date'],
        montant: (json['montant'] as num).toDouble(),
        pretId: json['pretId'],
      );
}