class CaseCarnetModel {
  final int position;
  final String? date;
  final bool remplie;
  final int? cotisationId;
  final bool suppressible;

  CaseCarnetModel({
    required this.position,
    this.date,
    required this.remplie,
    this.cotisationId,
    this.suppressible = false,
  });

  factory CaseCarnetModel.fromJson(Map<String, dynamic> json) => CaseCarnetModel(
        position: json['position'],
        date: json['date'],
        remplie: json['remplie'],
        cotisationId: json['cotisationId'],
        suppressible: json['suppressible'] ?? false,
      );
}

class CarnetModel {
  final int tontineId;
  final double mise;
  final int nbreMise;
  final bool cloturee;
  final List<CaseCarnetModel> cases;



  CarnetModel({
    required this.tontineId,
    required this.mise,
    required this.nbreMise,
    required this.cloturee,
    required this.cases,
  });

  factory CarnetModel.fromJson(Map<String, dynamic> json) => CarnetModel(
        tontineId: json['tontineId'],
        mise: (json['mise'] as num).toDouble(),
        nbreMise: json['nbreMise'],
        cloturee: json['cloturee'],
        cases: (json['cases'] as List).map((e) => CaseCarnetModel.fromJson(e)).toList(),
      );
}