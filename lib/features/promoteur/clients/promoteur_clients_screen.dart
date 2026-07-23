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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final auth = context.read<AuthProvider>();
    final clients = await _service.getClients(auth.utilisateurId!);
    setState(() {
      _clients = clients;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Clients')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _clients.isEmpty
              ? const Center(child: Text('Aucun client pour le moment'))
              : ListView.builder(
                  itemCount: _clients.length,
                  itemBuilder: (context, i) {
                    final c = _clients[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text(c.prenomCli[0])),
                      title: Text(c.nomComplet),
                      subtitle: Text(c.telephone ?? c.quartier ?? ''),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ClientDetailScreen(clientId: c.id)),
                        ), // TODO : écran détail client
                    );
                  },
                ),
    );
  }
}