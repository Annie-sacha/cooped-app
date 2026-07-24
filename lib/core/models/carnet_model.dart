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