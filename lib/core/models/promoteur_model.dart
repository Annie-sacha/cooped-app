class PromoteurModel {
  final int id;
  final String nom;
  final String telephone;
  final String email;

  PromoteurModel({required this.id, required this.nom, required this.telephone, required this.email});

  factory PromoteurModel.fromJson(Map<String, dynamic> json) => PromoteurModel(
        id: json['id'],
        nom: json['nom'],
        telephone: json['telephone'],
        email: json['email'],
      );
}