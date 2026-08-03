import 'package:flutter/material.dart';
import '../../core/models/client_model.dart';
import '../../core/models/frais_model.dart';
import '../../core/api/frais_service.dart';
import '../../core/theme/app_theme.dart';

class ClientFraisScreen extends StatefulWidget {
  final ClientModel client;
  const ClientFraisScreen({super.key, required this.client});
  @override
  State<ClientFraisScreen> createState() => _ClientFraisScreenState();
}

class _ClientFraisScreenState extends State<ClientFraisScreen> {
  final _service = FraisService();
  List<FraisModel> _frais = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final frais = await _service.getByClient(widget.client.id);
    setState(() {
      _frais = frais;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _frais.fold<double>(0, (sum, f) => sum + f.montant);

    return Scaffold(
      appBar: AppBar(title: Text('Frais — ${widget.client.nomComplet}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.warning.withOpacity(0.15),
                  child: Column(
                    children: [
                      const Text('Total des frais prélevés'),
                      Text('${total.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: _frais.isEmpty
                      ? const Center(child: Text('Aucun frais enregistré'))
                      : ListView.builder(
                          itemCount: _frais.length,
                          itemBuilder: (context, i) {
                            final f = _frais[i];
                            return ListTile(
                              leading: const Icon(Icons.percent, color: AppTheme.warning),
                              title: Text('${f.montant.toStringAsFixed(0)} FCFA'),
                              subtitle: Text('${f.type} — ${f.date}'),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}