import 'package:flutter/material.dart';
import '../../../core/models/promoteur_model.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/theme/app_theme.dart';
import 'add_promoteur_screen.dart';
import 'promoteur_admin_detail_screen.dart';

class AdminPromoteursScreen extends StatefulWidget {
  const AdminPromoteursScreen({super.key});
  @override
  State<AdminPromoteursScreen> createState() => _AdminPromoteursScreenState();
}

class _AdminPromoteursScreenState extends State<AdminPromoteursScreen> {
  final _service = PromoteurService();
  List<PromoteurModel> _promoteurs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final promoteurs = await _service.getAll();
    setState(() {
      _promoteurs = promoteurs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promoteurs'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () async {
                final cree = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPromoteurScreen()),
                );
                if (cree == true) _charger();
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _promoteurs.isEmpty
              ? const Center(child: Text('Aucun promoteur'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _promoteurs.length,
                  itemBuilder: (context, i) {
                    final p = _promoteurs[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primary.withOpacity(0.15),
                          child: Text(p.nom.isNotEmpty ? p.nom[0] : '?', style: const TextStyle(color: AppTheme.primary)),
                        ),
                        title: Text(p.nom),
                        subtitle: Text('${p.email} — ${p.telephone}'),
                        onTap: () async {
                          final modifie = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PromoteurAdminDetailScreen(promoteur: p)),
                          );
                          if (modifie == true) _charger();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}