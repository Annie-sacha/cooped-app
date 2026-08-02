import 'package:flutter/material.dart';
import '../../../core/api/statistique_service.dart';
import '../../../core/models/statistique_model.dart';
import '../../../core/theme/app_theme.dart';

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});
  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  final _service = StatistiqueService();
  StatistiqueGlobaleModel? _stats;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final stats = await _service.obtenir();
    setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    if (_stats == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final s = _stats!;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vue financière globale', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _Carte(label: 'Total cotisé', value: s.totalCotise, color: AppTheme.secondary, icon: Icons.savings),
                _Carte(label: 'Total retiré', value: s.totalRetire, color: AppTheme.danger, icon: Icons.money_off),
                _Carte(label: 'Total prêté', value: s.totalPrete, color: AppTheme.primaryDark, icon: Icons.handshake),
                _Carte(label: 'Frais perçus', value: s.totalFraisPercus, color: AppTheme.warning, icon: Icons.percent),
              ],
            ),
            const SizedBox(height: 28),
            const Text('Tontines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _MiniStat(label: 'Actives', value: '${s.tontinesActives}', color: Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _MiniStat(label: 'Clôturées', value: '${s.tontinesCloturees}', color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 28),
            const Text('Par promoteur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...s.parPromoteur.map((p) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined, color: AppTheme.primary),
                    title: Text(p.nomPromoteur),
                    subtitle: Text('${p.nombreClients} client(s)'),
                    trailing: Text(
                      '${p.totalCollecte.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Carte extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  const _Carte({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text('${value.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label),
        ],
      ),
    );
  }
}