import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
    final total = s.totalCotise + s.totalRetire + s.totalPrete + s.totalFraisPercus;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vue financière globale', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                int colonnes = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
                return GridView.count(
                  crossAxisCount: colonnes,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.6,
                  children: [
                    _Carte(label: 'Total cotisé', value: s.totalCotise, color: AppTheme.secondary, icon: Icons.savings),
                    _Carte(label: 'Total retiré', value: s.totalRetire, color: AppTheme.danger, icon: Icons.money_off),
                    _Carte(label: 'Total prêté', value: s.totalPrete, color: AppTheme.primaryDark, icon: Icons.handshake),
                    _Carte(label: 'Frais perçus', value: s.totalFraisPercus, color: AppTheme.warning, icon: Icons.percent),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            const Text('Répartition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            if (total > 0)
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 55,
                    sections: [
                      PieChartSectionData(value: s.totalCotise, color: AppTheme.secondary, title: '${((s.totalCotise / total) * 100).toStringAsFixed(0)}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(value: s.totalRetire, color: AppTheme.danger, title: '${((s.totalRetire / total) * 100).toStringAsFixed(0)}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(value: s.totalPrete, color: AppTheme.primaryDark, title: '${((s.totalPrete / total) * 100).toStringAsFixed(0)}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(value: s.totalFraisPercus, color: AppTheme.warning, title: '${((s.totalFraisPercus / total) * 100).toStringAsFixed(0)}%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
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
            const Text('Collecte par promoteur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            if (s.parPromoteur.isNotEmpty)
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= s.parPromoteur.length) return const SizedBox();
                            final nom = s.parPromoteur[i].nomPromoteur.split(' ').first;
                            return Padding(padding: const EdgeInsets.only(top: 6), child: Text(nom, style: const TextStyle(fontSize: 10)));
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(s.parPromoteur.length, (i) {
                      return BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: s.parPromoteur[i].totalCollecte, color: AppTheme.primary, width: 18, borderRadius: BorderRadius.circular(4)),
                      ]);
                    }),
                  ),
                ),
              ),
            const SizedBox(height: 28),
            const Text('Détail par promoteur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...s.parPromoteur.map((p) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined, color: AppTheme.primary),
                    title: Text(p.nomPromoteur),
                    subtitle: Text('${p.nombreClients} client(s)'),
                    trailing: Text('${p.totalCollecte.toStringAsFixed(0)} FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text('${value.toStringAsFixed(0)} FCFA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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