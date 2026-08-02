import 'package:flutter/material.dart';
import '../../../core/models/pret_list_model.dart';
import '../../../core/api/pret_service.dart';
import '../../../core/theme/app_theme.dart';

class ValidationsPretsTab extends StatefulWidget {
  const ValidationsPretsTab({super.key});
  @override
  State<ValidationsPretsTab> createState() => _ValidationsPretsTabState();
}

class _ValidationsPretsTabState extends State<ValidationsPretsTab> {
  final _service = PretService();
  List<PretListModel> _prets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final prets = await _service.getEnAttente();
    setState(() {
      _prets = prets;
      _loading = false;
    });
  }

  Future<void> _valider(int id) async {
    await _service.valider(id);
    _charger();
  }

  Future<void> _rejeter(int id) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rejeter ce prêt ?'),
        content: const Text('La tontine et les frais associés seront supprimés.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Rejeter', style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
    if (confirme == true) {
      await _service.rejeter(id);
      _charger();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_prets.isEmpty) return const Center(child: Text('Aucun prêt en attente'));

    return RefreshIndicator(
      onRefresh: _charger,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prets.length,
        itemBuilder: (context, i) {
          final p = _prets[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.handshake, color: AppTheme.primaryDark),
              title: Text('${p.montant.toStringAsFixed(0)} FCFA'),
              subtitle: Text('${p.type} — ${p.date}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () => _valider(p.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: AppTheme.danger),
                    onPressed: () => _rejeter(p.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}