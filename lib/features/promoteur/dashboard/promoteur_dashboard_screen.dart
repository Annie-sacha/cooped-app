import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/client_model.dart';
import '../../../core/theme/app_theme.dart';
import '../clients/select_client_screen.dart';
import '../tontines/create_tontine_screen.dart';
import '../tontines/client_tontines_screen.dart';
import '../operations/retrait_screen.dart';
import '../operations/pret_screen.dart';
import '../operations/achat_screen.dart';
import '../rapports/rapports_screen.dart';

class PromoteurDashboardScreen extends StatefulWidget {
  const PromoteurDashboardScreen({super.key});
  @override
  State<PromoteurDashboardScreen> createState() => _PromoteurDashboardScreenState();
}

class _PromoteurDashboardScreenState extends State<PromoteurDashboardScreen> {
  final _service = PromoteurService();
  List<ClientModel>? _clients;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final auth = context.read<AuthProvider>();
    final clients = await _service.getClients(auth.utilisateurId!);
    setState(() {
      _clients = clients;
      _loading = false;
    });
  }

  Future<ClientModel?> _choisirClient() {
    return Navigator.push<ClientModel>(
      context,
      MaterialPageRoute(builder: (_) => const SelectClientScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Bonjour, ${auth.nom ?? ''}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _charger,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: AppTheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatBox(label: 'Clients', value: '${_clients?.length ?? 0}'),
                          const _StatBox(label: 'Tontines actives', value: '—'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Actions rapides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _ActionTile(
                        icon: Icons.savings,
                        label: 'Créer une tontine',
                        color: AppTheme.secondary,
                        onTap: () async {
                          final client = await _choisirClient();
                          if (client != null && mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CreateTontineScreen(clientId: client.id)),
                            );
                          }
                        },
                      ),
                      _ActionTile(
                        icon: Icons.add_card,
                        label: 'Ajouter une cotisation',
                        color: AppTheme.secondary,
                        onTap: () async {
                          final client = await _choisirClient();
                          if (client != null && mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ClientTontinesScreen(client: client)),
                            );
                          }
                        },
                      ),
                      _ActionTile(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Effectuer un achat',
                        color: AppTheme.warning,
                        onTap: () async {
                          final client = await _choisirClient();
                          if (client != null && mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AchatScreen(client: client)),
                            );
                          }
                        },
                      ),
                      _ActionTile(
                        icon: Icons.money_off,
                        label: 'Demander un retrait',
                        color: AppTheme.danger,
                        onTap: () async {
                          final client = await _choisirClient();
                          if (client != null && mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RetraitScreen(client: client)),
                            );
                          }
                        },
                      ),
                      _ActionTile(
                        icon: Icons.handshake,
                        label: 'Demander un prêt',
                        color: AppTheme.primaryDark,
                        onTap: () async {
                          final client = await _choisirClient();
                          if (client != null && mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PretScreen(client: client)),
                            );
                          }
                        },
                      ),
                      _ActionTile(
                        icon: Icons.bar_chart,
                        label: 'Rapports',
                        color: AppTheme.primaryDark,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RapportsScreen())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  const _StatBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    this.color = AppTheme.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(icon, size: 22, color: color),
                ),
                const SizedBox(height: 6),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      );
}