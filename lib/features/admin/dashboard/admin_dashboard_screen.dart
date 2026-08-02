import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/retrait_service.dart';
import '../../../core/api/pret_service.dart';
import '../../../core/api/client_service.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/theme/app_theme.dart';
import '../clients/add_client_admin_screen.dart';
import '../promoteurs/add_promoteur_screen.dart';
import '../validations/validations_screen.dart';
import '../statistiques/statistiques_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _retraitService = RetraitService();
  final _pretService = PretService();
  final _clientService = ClientService();
  final _promoteurService = PromoteurService();

  int _retraitsEnAttente = 0;
  int _pretsEnAttente = 0;
  int _totalClients = 0;
  int _totalPromoteurs = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final retraits = await _retraitService.getEnAttente();
    final prets = await _pretService.getEnAttente();
    final clients = await _clientService.getAll();
    final promoteurs = await _promoteurService.getAll();
    setState(() {
      _retraitsEnAttente = retraits.length;
      _pretsEnAttente = prets.length;
      _totalClients = clients.length;
      _totalPromoteurs = promoteurs.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _charger,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: AppTheme.gradientPrimary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              (auth.nom?.isNotEmpty ?? false) ? auth.nom![0] : 'M',
                              style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Bienvenue,', style: TextStyle(color: Colors.white70)),
                                Text('Monsieur AMADOTEY-AGBETO'
                                  //auth.nom ?? '',
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text('Vue d\'ensemble', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _StatCard(label: 'Clients', value: '$_totalClients', icon: Icons.people, color: AppTheme.primary),
                        _StatCard(label: 'Promoteurs', value: '$_totalPromoteurs', icon: Icons.badge, color: AppTheme.secondary),
                        _StatCard(label: 'Retraits en attente', value: '$_retraitsEnAttente', icon: Icons.money_off, color: AppTheme.danger),
                        _StatCard(label: 'Prêts en attente', value: '$_pretsEnAttente', icon: Icons.handshake, color: AppTheme.warning),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text('Actions rapides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _ActionCard(
                          icon: Icons.person_add,
                          label: 'Ajouter un client',
                          color: AppTheme.primary,
                          onTap: () async {
                            final cree = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddClientAdminScreen()));
                            if (cree == true) _charger();
                          },
                        ),
                        _ActionCard(
                          icon: Icons.badge_outlined,
                          label: 'Ajouter un promoteur',
                          color: AppTheme.secondary,
                          onTap: () async {
                            final cree = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPromoteurScreen()));
                            if (cree == true) _charger();
                          },
                        ),
                        _ActionCard(
                          icon: Icons.fact_check_outlined,
                          label: 'Voir les validations',
                          color: AppTheme.warning,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ValidationsScreen())),
                        ),
                        _ActionCard(
                          icon: Icons.bar_chart,
                          label: 'Statistiques',
                          color: AppTheme.primaryDark,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatistiquesScreen())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}