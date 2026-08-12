import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/theme/app_theme.dart';
import 'suivi_normal_screen.dart';
import 'suivi_achat_screen.dart';
import 'suivi_pret_screen.dart';

class ClientSuiviScreen extends StatelessWidget {
  final ClientModel client;
  const ClientSuiviScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suivi — ${client.nomComplet}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Categorie(
              label: 'Suivi Normal',
              icon: Icons.savings_outlined,
              color: AppTheme.secondary,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuiviNormalScreen(client: client))),
            ),
            const SizedBox(height: 16),
            _Categorie(
              label: 'Suivi Prêt',
              icon: Icons.handshake,
              color: AppTheme.primaryDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuiviPretScreen(client: client))),
            ),
            const SizedBox(height: 16),
            _Categorie(
              label: 'Suivi Achat',
              icon: Icons.shopping_bag_outlined,
              color: AppTheme.warning,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuiviAchatScreen(client: client))),
            ),
          ],
        ),
      ),
    );
  }
}

class _Categorie extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Categorie({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}