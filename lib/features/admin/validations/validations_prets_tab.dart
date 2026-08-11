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

  Future<String?> _demanderMotif(String titre) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titre),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Motif', hintText: 'Justification de la décision'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Le motif est requis' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, controller.text.trim());
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  Future<void> _valider(int id) async {
    final motif = await _demanderMotif('Valider ce prêt');
    if (motif == null) return;
    await _service.valider(id, motif);
    _charger();
  }

  Future<void> _rejeter(int id) async {
    final motif = await _demanderMotif('Rejeter ce prêt');
    if (motif == null) return;
    await _service.rejeter(id, motif);
    _charger();
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.handshake, color: AppTheme.primaryDark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.clientNom, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Solde actuel : ${p.solde.toStringAsFixed(0)} FCFA', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text('${p.montant.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${p.type} — ${p.date}'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _rejeter(p.id),
                        icon: const Icon(Icons.cancel, color: AppTheme.danger),
                        label: const Text('Rejeter', style: TextStyle(color: AppTheme.danger)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _valider(p.id),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Valider'),
                      ),
                    ],
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