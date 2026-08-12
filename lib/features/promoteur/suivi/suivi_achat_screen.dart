import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/suivi_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/widgets/solde_header.dart';

class SuiviAchatScreen extends StatefulWidget {
  final ClientModel client;
  const SuiviAchatScreen({super.key, required this.client});
  @override
  State<SuiviAchatScreen> createState() => _SuiviAchatScreenState();
}

class _SuiviAchatScreenState extends State<SuiviAchatScreen> {
  final _service = SuiviService();
  List<dynamic> _lignes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final lignes = await _service.getSuiviAchat(widget.client.id);
    setState(() {
      _lignes = lignes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suivi Achat — ${widget.client.nomComplet}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SoldeHeader(clientId: widget.client.id),
                if (_lignes.isEmpty)
                  const Text('Aucune opération enregistrée')
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Désignation')),
                        DataColumn(label: Text('Sortie'), numeric: true),
                        DataColumn(label: Text('Entrée'), numeric: true),
                        DataColumn(label: Text('Solde'), numeric: true),
                      ],
                      rows: _lignes.map<DataRow>((l) => DataRow(cells: [
                        DataCell(Text(l.date)),
                        DataCell(Text(l.designation)),
                        DataCell(Text(l.sortie > 0 ? l.sortie.toStringAsFixed(0) : '-', style: const TextStyle(color: AppTheme.danger))),
                        DataCell(Text(l.entree > 0 ? l.entree.toStringAsFixed(0) : '-', style: const TextStyle(color: AppTheme.secondary))),
                        DataCell(Text(l.solde.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold))),
                      ])).toList(),
                    ),
                  ),
              ],
            ),
    );
  }
}