import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/statistique_promoteur_model.dart';
import '../../../core/theme/app_theme.dart';

class RapportsScreen extends StatefulWidget {
  const RapportsScreen({super.key});
  @override
  State<RapportsScreen> createState() => _RapportsScreenState();
}

class _RapportsScreenState extends State<RapportsScreen> {
  final _service = PromoteurService();
  StatistiquePromoteurModel? _stats;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final auth = context.read<AuthProvider>();
    final stats = await _service.getStatistiques(auth.utilisateurId!);
    setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    if (_stats == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final s = _stats!;
    final total = s.totalCollecte + s.totalRetire + s.totalPrete;

    return Scaffold(
      appBar: AppBar(title: const Text('Rapports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _Mini(label: 'Clients', value: '${s.totalClients}', color: AppTheme.primary)),
              const SizedBox(width: 12),
              Expanded(child: _Mini(label: 'Tontines actives', value: '${s.tontinesActives}', color: AppTheme.secondary)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Répartition financière', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          if (total > 0)
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      value: s.totalCollecte,
                      color: AppTheme.secondary,
                      title: '${((s.totalCollecte / total) * 100).toStringAsFixed(0)}%',
                      radius: 55,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    PieChartSectionData(
                      value: s.totalRetire,
                      color: AppTheme.danger,
                      title: '${((s.totalRetire / total) * 100).toStringAsFixed(0)}%',
                      radius: 55,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    PieChartSectionData(
                      value: s.totalPrete,
                      color: AppTheme.primaryDark,
                      title: '${((s.totalPrete / total) * 100).toStringAsFixed(0)}%',
                      radius: 55,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Aucune donnée à afficher'))),
          const SizedBox(height: 24),
          const Text('Prêts et retraits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Mini(label: 'Prêts validés', value: '${s.pretsValides}', color: Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _Mini(label: 'Prêts refusés', value: '${s.pretsRefuses}', color: AppTheme.danger)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Mini(label: 'Retraits validés', value: '${s.retraitsValides}', color: Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _Mini(label: 'Retraits refusés', value: '${s.retraitsRefuses}', color: AppTheme.danger)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            children: [
              _Legende(color: AppTheme.secondary, label: 'Collecté (${s.totalCollecte.toStringAsFixed(0)})'),
              _Legende(color: AppTheme.danger, label: 'Retiré (${s.totalRetire.toStringAsFixed(0)})'),
              _Legende(color: AppTheme.primaryDark, label: 'Prêté (${s.totalPrete.toStringAsFixed(0)})'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Mini({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      );
}

class _Legende extends StatelessWidget {
  final Color color;
  final String label;
  const _Legende({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
}