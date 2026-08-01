class PretListModel {
  final int id;
  final int clientId;
  final double montant;
  final String type;
  final String date;

  PretListModel({required this.id, required this.clientId, required this.montant, required this.type, required this.date});

  factory PretListModel.fromJson(Map<String, dynamic> json) => PretListModel(
        id: json['id'],
        clientId: json['clientId'],
        montant: (json['montant'] as num).toDouble(),
        type: json['type'],
        date: json['date'],
      );
}