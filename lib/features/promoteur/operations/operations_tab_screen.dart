import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/theme/app_theme.dart';
import '../clients/select_client_screen.dart';
import 'retrait_screen.dart';
import 'pret_screen.dart';
import 'achat_screen.dart';

class OperationsTabScreen extends StatelessWidget {
  const OperationsTabScreen({super.key});

  Future<void> _choisirEtOuvrir(BuildContext context, Widget Function(ClientModel) builder) async {
    final client = await Navigator.push<ClientModel>(
      context,
      MaterialPageRoute(builder: (_) => const SelectClientScreen()),
    );
    if (client != null && context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => builder(client)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opérations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.money_off, color: AppTheme.danger),
              title: const Text('Faire un retrait'),
              onTap: () => _choisirEtOuvrir(context, (c) => RetraitScreen(client: c)),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.handshake, color: AppTheme.primaryDark),
              title: const Text('Accorder un prêt'),
              onTap: () => _choisirEtOuvrir(context, (c) => PretScreen(client: c)),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: AppTheme.warning),
              title: const Text('Effectuer un achat'),
              onTap: () => _choisirEtOuvrir(context, (c) => AchatScreen(client: c)),
            ),
          ),
        ],
      ),
    );
  }
}