import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/widgets/solde_header.dart';
import 'acheter_simple_screen.dart';
import 'ouvrir_cotisation_achat_screen.dart';

class AchatScreen extends StatelessWidget {
  final ClientModel client;
  const AchatScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Achat — ${client.nomComplet}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SoldeHeader(clientId: client.id),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AcheterSimpleScreen(client: client))),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Acheter'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warning),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OuvrirCotisationAchatScreen(client: client))),
                icon: const Icon(Icons.savings),
                label: const Text('Ouvrir la cotisation d\'achat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}