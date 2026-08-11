class RetraitEnAttenteModel {
  final int id;
  final int clientId;
  final String clientNom;
  final double montantTotal;
  final String? motif;
  final String date;
  final double solde;

  RetraitEnAttenteModel({
    required this.id,
    required this.clientId,
    required this.clientNom,
    required this.montantTotal,
    this.motif,
    required this.date,
    required this.solde,
  });

  factory RetraitEnAttenteModel.fromJson(Map<String, dynamic> json) => RetraitEnAttenteModel(
        id: json['id'],
        clientId: json['clientId'],
        clientNom: json['clientNom'],
        montantTotal: (json['montantTotal'] as num).toDouble(),
        motif: json['motif'],
        date: json['date'],
        solde: (json['solde'] as num).toDouble(),
      );
}