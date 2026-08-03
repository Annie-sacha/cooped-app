class FraisModel {
  final int id;
  final String date;
  final double montant;
  final String type;
  final int? pretId;

  FraisModel({required this.id, required this.date, required this.montant, required this.type, this.pretId});

  factory FraisModel.fromJson(Map<String, dynamic> json) => FraisModel(
        id: json['id'],
        date: json['date'],
        montant: (json['montant'] as num).toDouble(),
        type: json['type'],
        pretId: json['pretId'],
      );
}