class RetraitModel {
  final int id;
  final String date;
  final double montantTotal;
  final String? motif;

  RetraitModel({required this.id, required this.date, required this.montantTotal, this.motif});

  factory RetraitModel.fromJson(Map<String, dynamic> json) => RetraitModel(
        id: json['id'],
        date: json['date'],
        montantTotal: (json['montantTotal'] as num).toDouble(),
        motif: json['motif'],
      );
}