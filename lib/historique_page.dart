import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/livreur.dart';
import '../models/commande.dart';
import '../services/backend_service.dart';

class HistoriquePage extends StatefulWidget {
  final Livreur livreur;

  const HistoriquePage({super.key, required this.livreur});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Commande> _historique = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHistorique();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistorique() async {
    setState(() => _isLoading = true);
    final historique = await BackendService().getHistorique(widget.livreur.id);
    setState(() {
      _historique = historique;
      _isLoading = false;
    });
  }

  List<Commande> get _toutes => _historique;
  List<Commande> get _livrees =>
      _historique.where((c) => c.statut == StatutCommande.livree).toList();
  List<Commande> get _echecs =>
      _historique.where((c) => c.statut == StatutCommande.echec).toList();
  List<Commande> get _retours =>
      _historique.where((c) => c.statut == StatutCommande.echec).toList();

  @override
  Widget build(BuildContext context) {
    final total = _historique.length;
    final livrees = _livrees.length;
    final successRate = total > 0 ? (livrees / total * 100).toInt() : 100;

    return Scaffold(
      backgroundColor: const Color(0xFF1E5FFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Historique',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          '$total',
                          'Total',
                          Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          '$livrees',
                          'Livrées',
                          Icons.check_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          '$successRate%',
                          'Succès',
                          Icons.star_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF1E5FFF),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFF1E5FFF),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      isScrollable: true,
                      tabs: const [
                        Tab(text: 'Tout'),
                        Tab(text: 'Livrées'),
                        Tab(text: 'Échecs'),
                        Tab(text: 'Retours'),
                      ],
                    ),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TabBarView(
                              controller: _tabController,
                              children: [
                                _buildHistoriqueList(_toutes),
                                _buildHistoriqueList(_livrees),
                                _buildHistoriqueList(_echecs),
                                _buildHistoriqueList(_retours),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoriqueList(List<Commande> commandes) {
    if (commandes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              'Aucun historique',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '⚽ 🏀 🎾',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      );
    }

    // Grouper par date
    final grouped = <String, List<Commande>>{};
    for (var commande in commandes) {
      final dateKey = DateFormat('yyyy-MM-dd').format(commande.dateCommande);
      grouped[dateKey] = [...(grouped[dateKey] ?? []), commande];
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final commandesJour = grouped[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE d MMMM', 'fr_FR').format(date),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            ...commandesJour.map((commande) => _buildHistoriqueCard(commande)),
          ],
        );
      },
    );
  }

  Widget _buildHistoriqueCard(Commande commande) {
    final isLivree = commande.statut == StatutCommande.livree;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLivree
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLivree ? Icons.check_circle : Icons.cancel,
              color: isLivree ? const Color(0xFF4CAF50) : Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5FFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        commande.id,
                        style: const TextStyle(
                          color: Color(0xFF1E5FFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLivree
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isLivree ? 'Livré' : 'Échec',
                        style: TextStyle(
                          color: isLivree ? const Color(0xFF4CAF50) : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  commande.clientNom,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${commande.ville} • ${commande.articles.length} articles',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${commande.total.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E5FFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}