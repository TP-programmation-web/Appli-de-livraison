import 'package:flutter/material.dart';
import '../models/livreur.dart';
import '../models/commande.dart';
import '../services/backend_service.dart';
import 'commande_detail_page.dart';

class CoursesPage extends StatefulWidget {
  final Livreur livreur;

  const CoursesPage({super.key, required this.livreur});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Commande> _commandes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCommandes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCommandes() async {
    setState(() => _isLoading = true);
    final commandes = await BackendService().getCommandesAssignees(widget.livreur.id);
    setState(() {
      _commandes = commandes;
      _isLoading = false;
    });
  }

  List<Commande> get _toutes => _commandes;
  List<Commande> get _enAttente =>
      _commandes.where((c) => c.statut == StatutCommande.enAttente).toList();
  List<Commande> get _enCours =>
      _commandes.where((c) => c.statut == StatutCommande.enCours).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mes courses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E5FFF),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E5FFF),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Toutes'),
            Tab(text: 'En attente'),
            Tab(text: 'En cours'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCommandesList(_toutes),
                _buildCommandesList(_enAttente),
                _buildCommandesList(_enCours),
              ],
            ),
    );
  }

  Widget _buildCommandesList(List<Commande> commandes) {
    if (commandes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              'Aucune commande',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '⚽ 🏀 🎾 🏈',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCommandes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: commandes.length,
        itemBuilder: (context, index) {
          return _buildCommandeCard(commandes[index]);
        },
      ),
    );
  }

  Widget _buildCommandeCard(Commande commande) {
    Color statusColor;
    Color borderColor;

    switch (commande.statut) {
      case StatutCommande.enCours:
        statusColor = const Color(0xFF1E5FFF);
        borderColor = const Color(0xFF1E5FFF);
        break;
      case StatutCommande.enAttente:
        statusColor = const Color(0xFFFFA726);
        borderColor = Colors.transparent;
        break;
      case StatutCommande.urgent:
        statusColor = Colors.red;
        borderColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
        borderColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommandeDetailPage(commande: commande),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: borderColor != Colors.transparent
              ? Border.all(color: borderColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: commande.statut == StatutCommande.enCours
                    ? const Color(0xFF1E5FFF).withOpacity(0.05)
                    : commande.priorite == Priorite.urgent
                        ? Colors.red.withOpacity(0.05)
                        : null,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5FFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      commande.id,
                      style: const TextStyle(
                        color: Color(0xFF1E5FFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (commande.priorite != Priorite.normale)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: commande.priorite == Priorite.urgent
                            ? Colors.red
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            commande.prioriteLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (commande.priorite != Priorite.normale) const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: statusColor, size: 10),
                        const SizedBox(width: 6),
                        Text(
                          commande.statut == StatutCommande.enCours
                              ? 'En cours'
                              : 'En attente',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 20,
                          color: Color(0xFF1E5FFF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commande.clientNom,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              commande.clientTelephone,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Color(0xFF1E5FFF),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            commande.adresseComplete,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        commande.heureLivraison ?? 'Pas d\'heure spécifiée',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Icon(Icons.inventory_2_outlined, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '${commande.articles.length} articles',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${commande.total.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E5FFF),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommandeDetailPage(commande: commande),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E5FFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text(
                          'Voir détails',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}