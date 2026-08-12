import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/suivi_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/widgets/solde_header.dart';

class SuiviPretScreen extends StatefulWidget {
  final ClientModel client;
  const SuiviPretScreen({super.key, required this.client});
  @override
  State<SuiviPretScreen> createState() => _SuiviPretScreenState();
}

class _SuiviPretScreenState extends State<SuiviPretScreen> {
  final _service = SuiviService();
  List<dynamic> _prets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final prets = await _service.getSuiviPret(widget.client.id);
    setState(() {
      _prets = prets;
      _loading = false;
    });
  }

  Color _couleurStatut(String statutValidation) {
    switch (statutValidation) {
      case 'Valide': return Colors.green;
      case 'Rejete': return AppTheme.danger;
      default: return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suivi Prêt — ${widget.client.nomComplet}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SoldeHeader(clientId: widget.client.id),
                if (_prets.isEmpty)
                  const Text('Aucun prêt enregistré')
                else
                  ..._prets.map((p) => Card(
                        child: ListTile(
                          leading: Icon(Icons.handshake, color: _couleurStatut(p.statutValidation)),
                          title: Text('${p.montant.toStringAsFixed(0)} FCFA — ${p.type}'),
                          subtitle: Text('${p.date} — ${p.statut}'),
                          trailing: Chip(
                            label: Text(p.statutValidation, style: const TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: _couleurStatut(p.statutValidation),
                          ),
                        ),
                      )),
              ],
            ),
    );
  }
}