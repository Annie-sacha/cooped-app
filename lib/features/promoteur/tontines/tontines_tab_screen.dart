import 'package:flutter/material.dart';
import '../clients/select_client_screen.dart';
import 'client_tontines_screen.dart';
import '../../../core/models/client_model.dart';

class TontinesTabScreen extends StatelessWidget {
  const TontinesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tontines')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.savings_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Choisis un client pour voir ou créer ses tontines', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
              onPressed: () async {
                final client = await Navigator.push<ClientModel>(
                    context,
                    MaterialPageRoute(builder: (_) => const SelectClientScreen()),
                );
                if (client != null && context.mounted) {
                    await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientTontinesScreen(client: client)),
                    );
                }
            },
                icon: const Icon(Icons.person_search),
                label: const Text('Choisir un client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}