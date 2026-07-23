class LoginResponse {
  final String token;
  final int utilisateurId;
  final String nom;
  final String role;   // "Administrateur" ou "Promoteur"
  final DateTime expirationToken;

  LoginResponse({
    required this.token,
    required this.utilisateurId,
    required this.nom,
    required this.role,
    required this.expirationToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      token: json['token'],
      utilisateurId: json['utilisateurId'],
      nom: json['nom'],
      role: json['role'],   
      expirationToken: DateTime.parse(json['expirationToken']),
    );
}