import 'package:flutter/material.dart';
import '../../../core/models/retrait_model.dart';
import '../../../core/api/retrait_service.dart';
import '../../../core/theme/app_theme.dart';

class ValidationsRetraitsTab extends StatefulWidget {
  const ValidationsRetraitsTab({super.key});
  @override
  State<ValidationsRetraitsTab> createState() => _ValidationsRetraitsTabState();
}

class _ValidationsRetraitsTabState extends State<ValidationsRetraitsTab> {
  final _service = RetraitService();
  List<RetraitModel> _retraits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final retraits = await _service.getEnAttente();
    setState(() {
      _retraits = retraits;
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
        title: const Text('Rejeter ce retrait ?'),
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
    if (_retraits.isEmpty) return const Center(child: Text('Aucun retrait en attente'));

    return RefreshIndicator(
      onRefresh: _charger,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _retraits.length,
        itemBuilder: (context, i) {
          final r = _retraits[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.money_off, color: AppTheme.danger),
              title: Text('${r.montantTotal.toStringAsFixed(0)} FCFA'),
              subtitle: Text('${r.date}${r.motif != null ? " — ${r.motif}" : ""}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () => _valider(r.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: AppTheme.danger),
                    onPressed: () => _rejeter(r.id),
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