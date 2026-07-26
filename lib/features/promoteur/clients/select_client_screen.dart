import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/client_model.dart';

class SelectClientScreen extends StatefulWidget {
  const SelectClientScreen({super.key});
  @override
  State<SelectClientScreen> createState() => _SelectClientScreenState();
}

class _SelectClientScreenState extends State<SelectClientScreen> {
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
      appBar: AppBar(title: const Text('Choisir un client')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _clients.length,
              itemBuilder: (context, i) {
                final c = _clients[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(c.prenomCli[0])),
                  title: Text(c.nomComplet),
                  onTap: () => Navigator.pop(context, c.id),
                );
              },
            ),
    );
  }
}