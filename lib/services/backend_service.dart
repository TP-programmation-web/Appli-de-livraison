import '../models/livreur.dart';
import '../models/commande.dart';
import '../models/article.dart';

class BackendService {
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;
  BackendService._internal();

  // Base de données simulée - Contexte Camerounais
  final Map<String, Livreur> _livreurs = {
    'jeanpaul.mvondo@allsports.cm': Livreur(
      id: 'L001',
      nom: 'Mvondo',
      prenom: 'Jean-Paul',
      email: 'jeanpaul.mvondo@allsports.cm',
      telephone: '+237 6 77 88 99 00',
      vehicule: 'Moto',
      note: 4.8,
      totalLivraisons: 342,
    ),
  };

  final Map<String, String> _passwords = {
    'jeanpaul.mvondo@allsports.cm': 'password123',
  };

  final List<Commande> _commandes = [
    Commande(
      id: 'CMD-YDE-001',
      clientNom: 'Marie Ngo Biyong',
      clientTelephone: '+237 6 55 44 33 22',
      adresse: 'Avenue Kennedy, Quartier Bastos',
      codePostal: '',
      ville: 'Yaoundé',
      articles: [
        Article(
          id: 'ART001',
          nom: 'Maillot des Lions Indomptables',
          categorie: CategorieArticle.homme,
          quantite: 2,
          prix: 25000,
          photo: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?w=800&q=80',
        ),
        Article(
          id: 'ART002',
          nom: 'Ballon de Football Nike',
          categorie: CategorieArticle.materiel,
          quantite: 1,
          prix: 15000,
          photo: 'https://images.unsplash.com/photo-1614632537423-1e6c2e7e0aab?w=800&q=80',
        ),
      ],
      statut: StatutCommande.enAttente,
      priorite: Priorite.prioritaire,
      dateCommande: DateTime.now(),
      heureLivraison: '14:00',
      total: 65000,
    ),
    Commande(
      id: 'CMD-DLA-002',
      clientNom: 'Paul Ekambi Tchami',
      clientTelephone: '+237 6 99 88 77 66',
      adresse: 'Rue de la Réunification, Akwa',
      codePostal: '',
      ville: 'Douala',
      articles: [
        Article(
          id: 'ART003',
          nom: 'Chaussures de Football Adidas',
          categorie: CategorieArticle.homme,
          quantite: 1,
          prix: 45000,
          photo: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800&q=80',
        ),
        Article(
          id: 'ART004',
          nom: 'Short de Sport Nike',
          categorie: CategorieArticle.homme,
          quantite: 2,
          prix: 8000,
          photo: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&q=80',
        ),
      ],
      statut: StatutCommande.enCours,
      priorite: Priorite.urgent,
      dateCommande: DateTime.now(),
      heureLivraison: '15:30',
      total: 61000,
    ),
    Commande(
      id: 'CMD-YDE-003',
      clientNom: 'Sophie Mballa Etoundi',
      clientTelephone: '+237 6 70 60 50 40',
      adresse: 'Carrefour Nlongkak, Derrière Total',
      codePostal: '',
      ville: 'Yaoundé',
      articles: [
        Article(
          id: 'ART005',
          nom: 'Ensemble de Sport Femme',
          categorie: CategorieArticle.femme,
          quantite: 1,
          prix: 18000,
          photo: 'https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=800&q=80',
        ),
        Article(
          id: 'ART006',
          nom: 'Basket Nike Air',
          categorie: CategorieArticle.femme,
          quantite: 1,
          prix: 38000,
          photo: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
        ),
      ],
      statut: StatutCommande.enAttente,
      priorite: Priorite.normale,
      dateCommande: DateTime.now(),
      heureLivraison: '16:00',
      total: 56000,
    ),
  ];

  final List<Commande> _historique = [
    Commande(
      id: 'CMD-YDE-004',
      clientNom: 'Michel Onana Bekolo',
      clientTelephone: '+237 6 88 77 66 55',
      adresse: 'Melen, Face Pharmacie du Carrefour',
      codePostal: '',
      ville: 'Yaoundé',
      articles: [
        Article(
          id: 'ART007',
          nom: 'Survêtement Complet Puma',
          categorie: CategorieArticle.homme,
          quantite: 1,
          prix: 35000,
          photo: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&q=80',
        ),
      ],
      statut: StatutCommande.livree,
      priorite: Priorite.normale,
      dateCommande: DateTime(2025, 1, 15),
      heureLivraison: '14:30',
      total: 35000,
    ),
    Commande(
      id: 'CMD-DLA-005',
      clientNom: 'Élise Ndongo Mbarga',
      clientTelephone: '+237 6 55 44 33 22',
      adresse: 'Bonapriso, Rue Joss',
      codePostal: '',
      ville: 'Douala',
      articles: [
        Article(
          id: 'ART008',
          nom: 'Sac de Sport Adidas',
          categorie: CategorieArticle.materiel,
          quantite: 1,
          prix: 22000,
          photo: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&q=80',
        ),
        Article(
          id: 'ART009',
          nom: 'Gourde Isotherme 1L',
          categorie: CategorieArticle.materiel,
          quantite: 2,
          prix: 5000,
          photo: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80',
        ),
      ],
      statut: StatutCommande.livree,
      priorite: Priorite.normale,
      dateCommande: DateTime(2025, 1, 15),
      heureLivraison: '16:00',
      total: 32000,
    ),
  ];

  // Authentification
  Future<Livreur?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_passwords[email] == password) {
      return _livreurs[email];
    }
    return null;
  }

  // Récupérer les commandes assignées
  Future<List<Commande>> getCommandesAssignees(String livreurId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _commandes;
  }

  // Récupérer l'historique
  Future<List<Commande>> getHistorique(String livreurId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _historique;
  }

  // Mettre à jour le statut d'une commande
  Future<bool> updateStatutCommande(String commandeId, StatutCommande nouveauStatut) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _commandes.indexWhere((c) => c.id == commandeId);
    if (index != -1) {
      // Simuler la mise à jour
      return true;
    }
    return false;
  }

  // Récupérer les statistiques du livreur
  Future<Map<String, dynamic>> getStatistiques(String livreurId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final commandes = await getCommandesAssignees(livreurId);
    final historique = await getHistorique(livreurId);
    
    final assignees = commandes.length;
    final completees = commandes.where((c) => c.statut == StatutCommande.livree).length;
    final enAttente = commandes.where((c) => c.statut == StatutCommande.enAttente).length;
    final gains = commandes.fold(0.0, (sum, c) => sum + c.total) * 0.15; // Commission 15%
    
    return {
      'assignees': assignees,
      'completees': completees,
      'enAttente': enAttente,
      'gains': gains,
      'totalLivraisons': historique.length,
      'successRate': historique.isEmpty ? 100 : (historique.where((c) => c.statut == StatutCommande.livree).length / historique.length * 100),
    };
  }
}