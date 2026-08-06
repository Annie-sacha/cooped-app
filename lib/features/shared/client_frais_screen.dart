import 'package:flutter/material.dart';
import '../../core/models/client_model.dart';
import '../../core/models/frais_model.dart';
import '../../core/models/penalite_model.dart';
import '../../core/api/frais_service.dart';
import '../../core/api/client_service.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/solde_header.dart';

class ClientFraisScreen extends StatefulWidget {
  final ClientModel client;
  const ClientFraisScreen({super.key, required this.client});
  @override
  State<ClientFraisScreen> createState() => _ClientFraisScreenState();
}

class _ClientFraisScreenState extends State<ClientFraisScreen> {
  final _fraisService = FraisService();
  final _clientService = ClientService();
  List<FraisModel> _frais = [];
  List<PenaliteModel> _penalites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final frais = await _fraisService.getByClient(widget.client.id);
    final penalites = await _clientService.getPenalites(widget.client.id);
    setState(() {
      _frais = frais;
      _penalites = penalites;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalFrais = _frais.fold<double>(0, (sum, f) => sum + f.montant);
    final totalPenalites = _penalites.fold<double>(0, (sum, p) => sum + p.montant);

    return Scaffold(
      appBar: AppBar(title: Text('Frais — ${widget.client.nomComplet}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SoldeHeader(clientId: widget.client.id),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: AppTheme.warning.withOpacity(0.15),
                        child: Column(
                          children: [
                            const Text('Total frais'),
                            Text('${totalFrais.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: AppTheme.danger.withOpacity(0.12),
                        child: Column(
                          children: [
                            const Text('Total pénalités'),
                            Text('${totalPenalites.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Frais de prêt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                if (_frais.isEmpty)
                  const Text('Aucun frais enregistré')
                else
                  ..._frais.map((f) => ListTile(
                        leading: const Icon(Icons.percent, color: AppTheme.warning),
                        title: Text('${f.montant.toStringAsFixed(0)} FCFA'),
                        subtitle: Text('${f.type} — ${f.date}'),
                      )),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Pénalités de retard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                if (_penalites.isEmpty)
                  const Text('Aucune pénalité appliquée')
                else
                  ..._penalites.map((p) => ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: AppTheme.danger),
                        title: Text('${p.montant.toStringAsFixed(0)} FCFA'),
                        subtitle: Text('Prêt #${p.pretId} — ${p.date}'),
                      )),
              ],
            ),
    );
  }
}