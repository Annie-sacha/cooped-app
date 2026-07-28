class AchatModel {
  final int id;
  final String date;
  final double montant;
  final String article;

  AchatModel({required this.id, required this.date, required this.montant, required this.article});

  factory AchatModel.fromJson(Map<String, dynamic> json) => AchatModel(
        id: json['id'],
        date: json['date'],
        montant: (json['montant'] as num).toDouble(),
        article: json['article'],
      );
}