class LigneSuiviModel {
  final String date;
  final String designation;
  final double entree;
  final double sortie;
  final double solde;

  LigneSuiviModel({
    required this.date,
    required this.designation,
    required this.entree,
    required this.sortie,
    required this.solde,
  });

  factory LigneSuiviModel.fromJson(Map<String, dynamic> json) => LigneSuiviModel(
        date: json['date'],
        designation: json['designation'],
        entree: (json['entree'] as num).toDouble(),
        sortie: (json['sortie'] as num).toDouble(),
        solde: (json['solde'] as num).toDouble(),
      );
}