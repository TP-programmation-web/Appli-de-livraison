import 'package:flutter/material.dart';
import 'package:appli_livraison/models/delivery_model.dart';
import 'package:appli_livraison/screens/delivery_detail_page.dart' hide Delivery, DeliveryItem;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Données de démonstration avec toutes les informations nécessaires
  final List<Delivery> allDeliveries = [
    Delivery(
      id: '1',
      orderNumber: 'AS-2024-001',
      customerName: 'Marie Martin',
      address: 'Bastos, Rue 1.234, Yaoundé',
      phone: '+237 6 70 00 11 22',
      amount: 45000,
      status: 'pending',
      items: [
        DeliveryItem(name: 'Ballon de football Nike', category: 'Homme', quantity: 1),
        DeliveryItem(name: 'Chaussures de sport Adidas', category: 'Homme', quantity: 1),
      ],
      distance: '2.5 km',
      priority: 'high',
      estimatedTime: '15 min',
      accessCode: '1234, 3ème étage gauche',
    ),
    Delivery(
      id: '2',
      orderNumber: 'AS-2024-002',
      customerName: 'Jean Dupont',
      address: 'Odza, Face école publique, Yaoundé',
      phone: '+237 6 50 33 44 55',
      amount: 78500,
      status: 'in_progress',
      items: [
        DeliveryItem(name: 'Tapis de yoga', category: 'Femme', quantity: 1),
        DeliveryItem(name: 'Haltères 5kg', category: 'Matériel', quantity: 2),
        DeliveryItem(name: 'Tenue de sport femme', category: 'Femme', quantity: 1),
      ],
      distance: '4.1 km',
      priority: 'normal',
      estimatedTime: '25 min',
    ),
    Delivery(
      id: '3',
      orderNumber: 'AS-2024-003',
      customerName: 'Sophie Nkolo',
      address: 'Mvan, Carrefour Pharmacie, Yaoundé',
      phone: '+237 6 55 22 33 44',
      amount: 32000,
      status: 'pending',
      items: [
        DeliveryItem(name: 'Raquette de tennis Wilson', category: 'Matériel', quantity: 1),
        DeliveryItem(name: 'Balles de tennis', category: 'Matériel', quantity: 3),
      ],
      distance: '3.2 km',
      priority: 'normal',
      estimatedTime: '20 min',
      accessCode: '5678',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount = allDeliveries.where((d) => d.status == 'delivered').length;
    final totalCount = allDeliveries.length;
    final pendingCount = allDeliveries.where((d) => d.status == 'pending').length;
    final totalEarnings = 45500;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // AppBar avec gradient bleu
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E40AF),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E40AF),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Aujourd\'hui',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$completedCount/$totalCount livraisons',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Aucune nouvelle notification'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),

          // Contenu
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              
              // Cartes de statistiques
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Assignées',
                        totalCount.toString(),
                        Icons.inventory_2_outlined,
                        const Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Complétées',
                        completedCount.toString(),
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'En attente',
                        pendingCount.toString(),
                        Icons.schedule_outlined,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Gains',
                        '${_formatPrice(totalEarnings)} FCFA',
                        Icons.payments_outlined,
                        const Color(0xFF1E40AF),
                        subtitle: 'Aujourd\'hui',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Section Livraisons en cours
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Livraisons en cours',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigation vers page "Toutes les livraisons"
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Liste des livraisons avec navigation
              _buildDeliveryList(),
              
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: allDeliveries.length,
      itemBuilder: (context, index) {
        final delivery = allDeliveries[index];
        
        Color statusColor;
        String statusText;
        
        switch (delivery.status) {
          case 'pending':
            statusColor = Colors.orange;
            statusText = 'En attente';
            break;
          case 'in_progress':
            statusColor = Colors.blue;
            statusText = 'En cours';
            break;
          case 'delivered':
            statusColor = Colors.green;
            statusText = 'Livré';
            break;
          default:
            statusColor = Colors.red;
            statusText = 'Échec';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // 🚀 NAVIGATION VERS LA PAGE DE DÉTAILS
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryDetailPage(delivery: delivery),
                  ),
                ).then((_) {
                  // Rafraîchir la page quand on revient
                  setState(() {});
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          delivery.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          delivery.customerName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            delivery.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${delivery.items.length} articles',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${_formatPrice(delivery.amount)} FCFA',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}