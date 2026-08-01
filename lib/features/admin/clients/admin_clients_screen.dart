import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/client_service.dart';
import '../../../core/theme/app_theme.dart';
import 'add_client_admin_screen.dart';
import 'client_admin_detail_screen.dart';

class AdminClientsScreen extends StatefulWidget {
  const AdminClientsScreen({super.key});
  @override
  State<AdminClientsScreen> createState() => _AdminClientsScreenState();
}

class _AdminClientsScreenState extends State<AdminClientsScreen> {
  final _service = ClientService();
  List<ClientModel> _clients = [];
  List<ClientModel> _filtres = [];
  bool _loading = true;
  final _recherche = TextEditingController();

  @override
  void initState() {
    super.initState();
    _charger();
    _recherche.addListener(_filtrer);
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final clients = await _service.getAll();
    setState(() {
      _clients = clients;
      _filtres = clients;
      _loading = false;
    });
  }

  void _filtrer() {
    final q = _recherche.text.trim().toLowerCase();
    setState(() {
      _filtres = q.isEmpty
          ? _clients
          : _clients.where((c) => c.nomComplet.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () async {
                final cree = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddClientAdminScreen()),
                );
                if (cree == true) _charger();
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _recherche,
              decoration: const InputDecoration(
                hintText: 'Rechercher un client...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtres.isEmpty
                      ? const Center(child: Text('Aucun client trouvé'))
                      : ListView.builder(
                          itemCount: _filtres.length,
                          itemBuilder: (context, i) {
                            final c = _filtres[i];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                                  child: Text(c.initiale, style: const TextStyle(color: AppTheme.primary)),
                                ),
                                title: Text(c.nomComplet),
                                subtitle: Text(c.telephone ?? c.quartier ?? 'Aucune info'),
                                trailing: c.montantDepotRequis != null
                                    ? Chip(label: Text('Dépôt: ${c.montantDepotRequis!.toStringAsFixed(0)}'))
                                    : null,
                                onTap: () async {
                                  final modifie = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ClientAdminDetailScreen(client: c)),
                                  );
                                  if (modifie == true) _charger();
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}