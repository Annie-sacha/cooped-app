import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/client_model.dart';
import '../clients/select_client_screen.dart';
import '../tontines/create_tontine_screen.dart';
import '../operations/retrait_screen.dart';
import '../operations/pret_screen.dart';
import '../operations/achat_screen.dart';



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
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatBox(label: 'Clients', value: '${_clients?.length ?? 0}'),
                          _StatBox(label: 'Tontines actives', value: '—'),
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
                        onTap: () async {
                          final clientId = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(builder: (_) => const SelectClientScreen()),
                          );
                          if (clientId != null && context.mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CreateTontineScreen(clientId: clientId)),
                            );
                          }
                        },
                      ),

                      _ActionTile(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Effectuer un achat',
                        onTap: () async {
                          final clientId = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(builder: (_) => const SelectClientScreen()),
                          );
                          if (clientId != null && context.mounted) {
                            final client = _clients?.firstWhere((c) => c.id == clientId);
                            if (client != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AchatScreen(client: client)),
                              );
                            }
                          }
                        },
                      ),

                      _ActionTile(
                        icon: Icons.money_off,
                        label: 'Faire un retrait',
                        onTap: () async {
                          final clientId = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(builder: (_) => const SelectClientScreen()),
                          );
                          if (clientId != null && context.mounted) {
                            final client = _clients?.firstWhere((c) => c.id == clientId);
                            if (client != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RetraitScreen(client: client)),
                              );
                            }
                          }
                        },
                      ),
                      _ActionTile(
                        icon: Icons.handshake,
                        label: 'Accorder un prêt',
                        onTap: () async {
                          final clientId = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(builder: (_) => const SelectClientScreen()),
                          );
                          if (clientId != null && context.mounted) {
                            final client = _clients?.firstWhere((c) => c.id == clientId);
                            if (client != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PretScreen(client: client)),
                              );
                            }
                          }
                        },
                      ),
                      const _ActionTile(icon: Icons.bar_chart, label: 'Rapports'),
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
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label),
        ],
      );
}




class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      );
}