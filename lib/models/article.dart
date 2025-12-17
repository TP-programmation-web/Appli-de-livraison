enum CategorieArticle { materiel, homme, femme, enfant }

class Article {
  final String id;
  final String nom;
  final CategorieArticle categorie;
  final int quantite;
  final double prix;
  final String photo; // URL de la photo

  Article({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.quantite,
    required this.prix,
    required this.photo,
  });

  String get categorieLabel {
    switch (categorie) {
      case CategorieArticle.materiel:
        return 'Matériel';
      case CategorieArticle.homme:
        return 'Homme';
      case CategorieArticle.femme:
        return 'Femme';
      case CategorieArticle.enfant:
        return 'Enfant';
    }
  }

  String get categorieIcon {
    switch (categorie) {
      case CategorieArticle.materiel:
        return '⚽';
      case CategorieArticle.homme:
        return '👔';
      case CategorieArticle.femme:
        return '👗';
      case CategorieArticle.enfant:
        return '👶';
    }
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      nom: json['nom'],
      categorie: CategorieArticle.values[json['categorie']],
      quantite: json['quantite'],
      prix: json['prix'].toDouble(),
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'categorie': categorie.index,
      'quantite': quantite,
      'prix': prix,
      'photo': photo,
    };
  }
}