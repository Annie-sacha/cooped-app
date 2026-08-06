import 'package:flutter/material.dart';
import '../../../core/api/client_service.dart';
import '../../../core/models/client_model.dart';
import '../../../core/theme/app_theme.dart';
import '../tontines/client_tontines_screen.dart';
import '../operations/pret_screen.dart';
import '../operations/retrait_screen.dart';
import '../operations/achat_screen.dart';
import '../suivi/client_suivi_screen.dart';
import '../../shared/client_frais_screen.dart';
import '../../../core/api/suivi_service.dart';

class ClientDetailScreen extends StatefulWidget {
  final int clientId;
  const ClientDetailScreen({super.key, required this.clientId});
  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final _service = ClientService();
  ClientModel? _client;

  @override
  void initState() {
    super.initState();
    _charger();
    _verifierPenalites();
    _chargerSolde();
  }

  Future<void> _charger() async {
    final client = await _service.getById(widget.clientId);
    setState(() => _client = client);
  }

  double? _solde;

  Future<void> _chargerSolde() async {
    final suivi = await SuiviService().getSuivi(widget.clientId);
    setState(() => _solde = suivi.isNotEmpty ? suivi.last.solde : 0);
  }

  Future<void> _verifierPenalites() async {
    final penalites = await _service.verifierPenalites(widget.clientId);
    if (penalites.isNotEmpty && mounted) {
      for (final p in penalites) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '⚠️ Pénalité appliquée : ${p.montantPenalite?.toStringAsFixed(0)} FCFA — nouvelle échéance ${p.nouvelleEcheance}',
            ),
            backgroundColor: AppTheme.warning,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_client == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final c = _client!;

    return Scaffold(
      appBar: AppBar(title: Text(c.nomComplet)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(radius: 40, child: Text(c.initiale, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(height: 12),
          Center(child: Text(c.nomComplet, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Solde : ${_solde?.toStringAsFixed(0) ?? "..."} FCFA',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
            ),
          ),
          if (c.telephone != null) Center(child: Text(c.telephone!)),
          const SizedBox(height: 24),
          const Text('Informations', style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          if (c.quartier != null) ListTile(leading: const Icon(Icons.location_on_outlined), title: Text(c.quartier!)),
          const SizedBox(height: 16),
          const Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientTontinesScreen(client: c))),
                icon: const Icon(Icons.savings_outlined),
                label: const Text('Tontines'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientSuiviScreen(client: c))),
                icon: const Icon(Icons.history),
                label: const Text('Suivi'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RetraitScreen(client: c))),
                icon: const Icon(Icons.money_off),
                label: const Text('Retrait'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PretScreen(client: c))),
                icon: const Icon(Icons.handshake),
                label: const Text('Prêt'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AchatScreen(client: c))),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Achat'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientFraisScreen(client: c))),
                icon: const Icon(Icons.percent),
                label: const Text('Frais'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}