import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/retrait_service.dart';
import '../../../core/api/pret_service.dart';
import '../../../core/theme/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _retraitService = RetraitService();
  final _pretService = PretService();
  int _retraitsEnAttente = 0;
  int _pretsEnAttente = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final retraits = await _retraitService.getEnAttente();
    final prets = await _pretService.getEnAttente();
    setState(() {
      _retraitsEnAttente = retraits.length;
      _pretsEnAttente = prets.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Bonjour monsieur')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _charger,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _StatCard(
                      label: 'Retraits en attente',
                      value: '$_retraitsEnAttente',
                      icon: Icons.money_off,
                      color: AppTheme.danger,
                    ),
                    _StatCard(
                      label: 'Prêts en attente',
                      value: '$_pretsEnAttente',
                      icon: Icons.handshake,
                      color: AppTheme.primaryDark,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}