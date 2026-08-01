import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/ligne_suivi_model.dart';
import '../../../core/api/suivi_service.dart';
import '../../../core/theme/app_theme.dart';

class ClientSuiviScreen extends StatefulWidget {
  final ClientModel client;
  const ClientSuiviScreen({super.key, required this.client});
  @override
  State<ClientSuiviScreen> createState() => _ClientSuiviScreenState();
}

class _ClientSuiviScreenState extends State<ClientSuiviScreen> {
  final _service = SuiviService();
  List<LigneSuiviModel> _lignes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final lignes = await _service.getSuivi(widget.client.id);
    setState(() {
      _lignes = lignes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final soldeActuel = _lignes.isNotEmpty ? _lignes.last.solde : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text('Suivi — ${widget.client.nomComplet}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _charger,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Column(
                      children: [
                        const Text('Solde actuel'),
                        Text(
                          '${soldeActuel.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _lignes.isEmpty
                        ? const Center(child: Text('Aucune opération enregistrée'))
                        : SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Désignation')),
                                  DataColumn(label: Text('Sortie'), numeric: true),
                                  DataColumn(label: Text('Entrée'), numeric: true),
                                  DataColumn(label: Text('Solde'), numeric: true),
                                ],
                                rows: _lignes.map((l) => DataRow(cells: [
                                  DataCell(Text(l.date)),
                                  DataCell(Text(l.designation)),
                                  DataCell(Text(l.sortie > 0 ? l.sortie.toStringAsFixed(0) : '-',
                                      style: const TextStyle(color: AppTheme.danger))),
                                  DataCell(Text(l.entree > 0 ? l.entree.toStringAsFixed(0) : '-',
                                      style: const TextStyle(color: AppTheme.secondary))),
                                  DataCell(Text(l.solde.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold))),
                                ])).toList(),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}