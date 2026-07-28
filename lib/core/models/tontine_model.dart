class TontineModel {
  final int numero;
  final double mise;
  final int nbreMise;
  final String dateCreation;
  final String? dateFin;
  final String? dateFinPrevue;
  final String type;   // "Normale", "Pret", "Achat"


  TontineModel({
    required this.numero,
    required this.mise,
    required this.nbreMise,
    required this.dateCreation,
    this.dateFin,
    this.dateFinPrevue,
    required this.type,
  });

  

  String get periode => '$dateCreation → ${dateFin ?? dateFinPrevue ?? "?"}';

  factory TontineModel.fromJson(Map<String, dynamic> json) => TontineModel(
        numero: json['numero'],
        mise: (json['mise'] as num).toDouble(),
        nbreMise: json['nbreMise'],
        dateCreation: json['dateCreation'],
        dateFin: json['dateFin'],
        dateFinPrevue: json['dateFinPrevue'],
        type: json['type'],

      );

  bool get estActive => dateFin == null;
}