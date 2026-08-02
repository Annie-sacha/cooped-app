import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/client_model.dart';
import 'client_detail_screen.dart';

class PromoteurClientsScreen extends StatefulWidget {
  const PromoteurClientsScreen({super.key});
  @override
  State<PromoteurClientsScreen> createState() => _PromoteurClientsScreenState();
}

class _PromoteurClientsScreenState extends State<PromoteurClientsScreen> {
  final _service = PromoteurService();
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
    final auth = context.read<AuthProvider>();
    final clients = await _service.getClients(auth.utilisateurId!);
    setState(() {
      _clients = clients;
      _filtres = clients;
      _loading = false;
    });
  }

  void _filtrer() {
    final q = _recherche.text.trim().toLowerCase();
    setState(() {
      _filtres = q.isEmpty ? _clients : _clients.where((c) => c.nomComplet.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Clients')),
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
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtres.isEmpty
                      ? const Center(child: Text('Aucun client trouvé'))
                      : ListView.builder(
                          itemCount: _filtres.length,
                          itemBuilder: (context, i) {
                            final c = _filtres[i];
                            return ListTile(
                              leading: CircleAvatar(child: Text(c.initiale)),
                              title: Text(c.nomComplet),
                              subtitle: Text(c.telephone ?? c.quartier ?? ''),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ClientDetailScreen(clientId: c.id)),
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