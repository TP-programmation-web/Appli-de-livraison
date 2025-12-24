import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/livreur.dart';
import '../models/commande.dart';
import '../models/article.dart';

class ApiService {
  // Configuration de l'URL de base selon l'environnement
  // Pour émulateur Android
  //static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // Pour iOS Simulator
  // static const String baseUrl = 'http://localhost:8080/api';
  
  // Pour appareil physique (remplacez par votre IP)
  static const String baseUrl = 'http://192.168.43.236:8080/api';
  
  // Pour production
  // static const String baseUrl = 'https://votre-serveur.com/api';

  // Clés pour SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _livreurIdKey = 'livreur_id';

  // Sauvegarder le token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Récupérer le token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Sauvegarder l'ID du livreur
  Future<void> _saveLivreurId(String livreurId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_livreurIdKey, livreurId);
  }

  // Récupérer l'ID du livreur
  Future<String?> _getLivreurId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_livreurIdKey);
  }

  // Supprimer le token (déconnexion)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_livreurIdKey);
  }

  // Headers avec authentification
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Gestion des erreurs
  void _handleError(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Non autorisé - Veuillez vous reconnecter');
    } else if (response.statusCode == 404) {
      throw Exception('Ressource non trouvée');
    } else if (response.statusCode >= 500) {
      throw Exception('Erreur serveur - Réessayez plus tard');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur inconnue');
    }
  }

  // ============================================
  // AUTHENTIFICATION
  // ============================================

  /// Connexion du livreur
  Future<Livreur?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Sauvegarder le token et l'ID
        await _saveToken(data['token']);
        await _saveLivreurId(data['livreur']['id']);
        
        // Créer l'objet Livreur
        return Livreur(
          id: data['livreur']['id'],
          nom: data['livreur']['nom'],
          prenom: data['livreur']['prenom'],
          email: data['livreur']['email'],
          telephone: data['livreur']['telephone'],
          vehicule: data['livreur']['vehicule'],
          note: (data['livreur']['note'] ?? 5.0).toDouble(),
          totalLivraisons: data['livreur']['totalLivraisons'] ?? 0,
        );
      } else {
        _handleError(response);
        return null;
      }
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // ============================================
  // COMMANDES
  // ============================================

  /// Récupérer les commandes assignées (EN_ATTENTE et EN_COURS)
  Future<List<Commande>> getCommandesAssignees(String livreurId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/commandes/assignees/$livreurId'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _parseCommande(json)).toList();
      } else {
        _handleError(response);
        return [];
      }
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Récupérer l'historique (LIVREE et ECHEC)
  Future<List<Commande>> getHistorique(String livreurId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/commandes/historique/$livreurId'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _parseCommande(json)).toList();
      } else {
        _handleError(response);
        return [];
      }
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Démarrer une livraison
  Future<bool> demarrerLivraison(String commandeId) async {
    try {
      final livreurId = await _getLivreurId();
      if (livreurId == null) throw Exception('Livreur non authentifié');

      final response = await http.post(
        Uri.parse('$baseUrl/commandes/$commandeId/demarrer/$livreurId'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Terminer une livraison avec succès (avec photo)
  Future<bool> terminerLivraisonSucces(
    String commandeId,
    File photo,
  ) async {
    try {
      final livreurId = await _getLivreurId();
      if (livreurId == null) throw Exception('Livreur non authentifié');

      final token = await _getToken();
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/commandes/$commandeId/terminer-succes/$livreurId'),
      );

      // Ajouter le header Authorization
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Ajouter la photo
      request.files.add(
        await http.MultipartFile.fromPath('photo', photo.path),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      
      return streamedResponse.statusCode == 200;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Terminer une livraison avec échec (avec raison)
  Future<bool> terminerLivraisonEchec(
    String commandeId,
    String raisonEchec,
  ) async {
    try {
      final livreurId = await _getLivreurId();
      if (livreurId == null) throw Exception('Livreur non authentifié');

      final encodedRaison = Uri.encodeComponent(raisonEchec);
      
      final response = await http.post(
        Uri.parse(
          '$baseUrl/commandes/$commandeId/terminer-echec/$livreurId?raisonEchec=$encodedRaison',
        ),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Récupérer les statistiques du livreur
  Future<Map<String, dynamic>> getStatistiques(String livreurId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/commandes/statistiques/$livreurId'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        _handleError(response);
        return {};
      }
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // ============================================
  // LIVREUR
  // ============================================

  /// Récupérer les informations du livreur
  Future<Livreur?> getLivreur(String livreurId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/livreurs/$livreurId'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Livreur(
          id: data['id'],
          nom: data['nom'],
          prenom: data['prenom'],
          email: data['email'],
          telephone: data['telephone'],
          vehicule: data['vehicule'],
          note: (data['note'] ?? 5.0).toDouble(),
          totalLivraisons: data['totalLivraisons'] ?? 0,
        );
      } else {
        _handleError(response);
        return null;
      }
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Mettre à jour les informations du livreur
  Future<bool> updateLivreur(
    String livreurId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/livreurs/$livreurId'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('Pas de connexion Internet');
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // ============================================
  // HELPERS
  // ============================================

  /// Parser une commande depuis JSON
  Commande _parseCommande(Map<String, dynamic> json) {
    return Commande(
      id: json['id'],
      clientNom: json['clientNom'],
      clientTelephone: json['clientTelephone'],
      adresse: json['adresse'],
      codePostal: json['codePostal'] ?? '',
      ville: json['ville'],
      statut: _parseStatut(json['statut']),
      dateCommande: DateTime.parse(json['dateCommande']),
      heureLivraison: json['heureLivraison'],
      total: (json['total'] ?? 0.0).toDouble(),
      articles: (json['articles'] as List)
          .map((a) => _parseArticle(a))
          .toList(),
    );
  }

  /// Parser un article depuis JSON
  Article _parseArticle(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      nom: json['nom'],
      categorie: _parseCategorie(json['categorie']),
      quantite: json['quantite'],
      prix: (json['prix'] ?? 0.0).toDouble(),
      photo: json['photo'] ?? '',
    );
  }

  /// Parser le statut de commande
  StatutCommande _parseStatut(String statut) {
    switch (statut) {
      case 'EN_ATTENTE':
        return StatutCommande.enAttente;
      case 'EN_COURS':
        return StatutCommande.enCours;
      case 'LIVREE':
        return StatutCommande.livree;
      case 'ECHEC':
        return StatutCommande.echec;
      default:
        return StatutCommande.enAttente;
    }
  }

  /// Parser la catégorie d'article
  CategorieArticle _parseCategorie(String categorie) {
    switch (categorie) {
      case 'HOMME':
        return CategorieArticle.homme;
      case 'FEMME':
        return CategorieArticle.femme;
      case 'ENFANT':
        return CategorieArticle.enfant;
      case 'MATERIEL':
        return CategorieArticle.materiel;
      default:
        return CategorieArticle.materiel;
    }
  }
}