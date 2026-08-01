import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/promoteur_model.dart';
import '../../../core/theme/app_theme.dart';

class PromoteurProfilScreen extends StatefulWidget {
  const PromoteurProfilScreen({super.key});
  @override
  State<PromoteurProfilScreen> createState() => _PromoteurProfilScreenState();
}

class _PromoteurProfilScreenState extends State<PromoteurProfilScreen> {
  final _service = PromoteurService();
  PromoteurModel? _promoteur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final auth = context.read<AuthProvider>();
    final promoteur = await _service.getById(auth.utilisateurId!);
    setState(() => _promoteur = promoteur);
  }

  Future<void> _confirmerDeconnexion() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Se déconnecter', style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
    if (confirme == true && mounted) {
      await context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_promoteur == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final p = _promoteur!;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppTheme.primary.withOpacity(0.15),
              child: Text(
                p.nom.isNotEmpty ? p.nom[0] : '?',
                style: const TextStyle(fontSize: 32, color: AppTheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text(p.nom, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Promoteur',
                style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('Téléphone'), subtitle: Text(p.telephone)),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.email_outlined), title: const Text('Email'), subtitle: Text(p.email)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _confirmerDeconnexion,
              icon: const Icon(Icons.logout, color: AppTheme.danger),
              label: const Text('Se déconnecter', style: TextStyle(color: AppTheme.danger)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.danger)),
            ),
          ),
        ],
      ),
    );
  }
}