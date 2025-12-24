import 'article.dart';

enum StatutCommande { enAttente, enCours, livree, echec }

class Commande {
  final String id;
  final String clientNom;
  final String clientTelephone;
  final String adresse;
  final String codePostal;
  final String ville;
  final List<Article> articles;
  final StatutCommande statut;
  final DateTime dateCommande;
  final String? heureLivraison;
  final double total;

  Commande({
    required this.id,
    required this.clientNom,
    required this.clientTelephone,
    required this.adresse,
    required this.codePostal,
    required this.ville,
    required this.articles,
    required this.statut,
    required this.dateCommande,
    this.heureLivraison,
    required this.total,
  });

  String get adresseComplete {
    if (codePostal.isEmpty) {
      return '$adresse, $ville';
    }
    return '$adresse, $codePostal $ville';
  }

  String get statutLabel {
    switch (statut) {
      case StatutCommande.enAttente:
        return 'En attente';
      case StatutCommande.enCours:
        return 'En cours';
      case StatutCommande.livree:
        return 'Livrée';
      case StatutCommande.echec:
        return 'Échec';
    }
  }

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      id: json['id'],
      clientNom: json['clientNom'],
      clientTelephone: json['clientTelephone'],
      adresse: json['adresse'],
      codePostal: json['codePostal'],
      ville: json['ville'],
      articles: (json['articles'] as List)
          .map((a) => Article.fromJson(a))
          .toList(),
      statut: StatutCommande.values[json['statut']],
      dateCommande: DateTime.parse(json['dateCommande']),
      heureLivraison: json['heureLivraison'],
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientNom': clientNom,
      'clientTelephone': clientTelephone,
      'adresse': adresse,
      'codePostal': codePostal,
      'ville': ville,
      'articles': articles.map((a) => a.toJson()).toList(),
      'statut': statut.index,
      'dateCommande': dateCommande.toIso8601String(),
      'heureLivraison': heureLivraison,
      'total': total,
    };
  }
}