class TontineModel {
  final int numero;
  final double mise;
  final int nbreMise;
  final String dateCreation;
  final String? dateFin;

  TontineModel({
    required this.numero,
    required this.mise,
    required this.nbreMise,
    required this.dateCreation,
    this.dateFin,
  });

  String get periode {
    final debut = dateCreation;
    final fin = dateFin ?? '?';
    return '$debut → $fin';
  }

  factory TontineModel.fromJson(Map<String, dynamic> json) => TontineModel(
        numero: json['numero'],
        mise: (json['mise'] as num).toDouble(),
        nbreMise: json['nbreMise'],
        dateCreation: json['dateCreation'],
        dateFin: json['dateFin'],
      );

  bool get estActive => dateFin == null;
}