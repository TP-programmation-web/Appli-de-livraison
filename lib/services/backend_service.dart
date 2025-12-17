import '../../models/livreur.dart';
import '../../models/commande.dart';
import '../../models/article.dart';

class BackendService {
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;
  BackendService._internal();

  // Base de données simulée
  final Map<String, Livreur> _livreurs = {
    'Clément Talla': Livreur(
      id: 'L001',
      nom: 'Talla',
      prenom: 'Clement',
      email: 'tallaclement@gmail.com',
      telephone: '+237 689087654',
      vehicule: 'Voiture',
      note: 4.8,
      totalLivraisons: 20,
    ),
  };

  final Map<String, String> _passwords = {
    'Clément Talla': 'Tallaclement',
  };

  final List<Commande> _commandes = [
    Commande(
      id: 'C001',
      clientNom: 'Essono Flora',
      clientTelephone: '+237 652439087',
      adresse: 'Carrefour Nsam',
      codePostal: '1890',
      ville: 'Yaoundé',
      articles: [
        Article(
          id: 'ART001',
          nom: 'Ballon Football Pro',
          categorie: CategorieArticle.materiel,
          quantite: 2,
          prix: 6000,
        ),
        Article(
          id: 'ART002',
          nom: 'Chaussures Running Nike',
          categorie: CategorieArticle.homme,
          quantite: 1,
          prix: 10000,
        ),
      ],
      statut: StatutCommande.enAttente,
      priorite: Priorite.prioritaire,
      dateCommande: DateTime.now(),
      heureLivraison: '14:00',
      total: 16000,
    ),
    Commande(
      id: 'C002',
      clientNom: 'Owona Matteo',
      clientTelephone: '+237 699087653',
      adresse: 'Melen Polytechnique',
      codePostal: '1236',
      ville: 'Yaounde',
      articles: [
        Article(
          id: 'ART003',
          nom: 'Ballon Football Pro',
          categorie: CategorieArticle.materiel,
          quantite: 1,
          prix: 6000,
        ),
        Article(
          id: 'ART004',
          nom: 'Chaussures Foot Puma',
          categorie: CategorieArticle.homme,
          quantite: 1,
          prix: 15000,
        ),
      ],
      statut: StatutCommande.enCours,
      priorite: Priorite.urgent,
      dateCommande: DateTime.now(),
      heureLivraison: '15:30',
      total: 21000,
    ),
    Commande(
      id: 'AS-2024-003',
      clientNom: 'Sophie Petit',
      clientTelephone: '+33 6 55 66 77 88',
      adresse: '8 Rue du Commerce',
      codePostal: '69002',
      ville: 'Lyon',
      articles: [
        Article(
          id: 'ART005',
          nom: 'Raquette Tennis Wilson',
          categorie: CategorieArticle.materiel,
          quantite: 1,
          prix: 79.99,
        ),
        Article(
          id: 'ART006',
          nom: 'Tenue Tennis Femme',
          categorie: CategorieArticle.femme,
          quantite: 2,
          prix: 22.50,
        ),
      ],
      statut: StatutCommande.enAttente,
      priorite: Priorite.normale,
      dateCommande: DateTime.now(),
      heureLivraison: '16:00',
      total: 124.99,
    ),
  ];

  final List<Commande> _historique = [
    Commande(
      id: 'AS-2024-004',
      clientNom: 'Lucas Moreau',
      clientTelephone: '+33 6 98 76 54 32',
      adresse: 'Place Vendôme',
      codePostal: '75001',
      ville: 'Paris',
      articles: [
        Article(
          id: 'ART007',
          nom: 'Kit Basketball',
          categorie: CategorieArticle.materiel,
          quantite: 1,
          prix: 179.00,
        ),
      ],
      statut: StatutCommande.livree,
      priorite: Priorite.normale,
      dateCommande: DateTime(2025, 1, 15),
      heureLivraison: '14:30',
      total: 179.00,
    ),
    Commande(
      id: 'AS-2024-005',
      clientNom: 'Emma Durand',
      clientTelephone: '+33 6 87 65 43 21',
      adresse: 'Rue de Rivoli',
      codePostal: '75004',
      ville: 'Paris',
      articles: [
        Article(
          id: 'ART008',
          nom: 'Vélo VTT Pro',
          categorie: CategorieArticle.materiel,
          quantite: 1,
          prix: 89.99,
        ),
      ],
      statut: StatutCommande.livree,
      priorite: Priorite.normale,
      dateCommande: DateTime(2025, 1, 15),
      heureLivraison: '16:00',
      total: 89.99,
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
    final gains = commandes.fold(0.0, (sum, c) => sum + c.total) / 2; // Commission 50%
    
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