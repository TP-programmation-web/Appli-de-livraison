class Livreur {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String? vehicule;
  final double note;
  final int totalLivraisons;

  Livreur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    this.vehicule,
    required this.note,
    required this.totalLivraisons,
  });

  String get nomComplet => '$prenom $nom';

  factory Livreur.fromJson(Map<String, dynamic> json) {
    return Livreur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      vehicule: json['vehicule'],
      note: json['note'].toDouble(),
      totalLivraisons: json['totalLivraisons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'vehicule': vehicule,
      'note': note,
      'totalLivraisons': totalLivraisons,
    };
  }
}