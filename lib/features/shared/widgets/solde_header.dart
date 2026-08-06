import 'package:flutter/material.dart';
import '../../../core/api/suivi_service.dart';
import '../../../core/theme/app_theme.dart';

class SoldeHeader extends StatefulWidget {
  final int clientId;
  const SoldeHeader({super.key, required this.clientId});
  @override
  State<SoldeHeader> createState() => _SoldeHeaderState();
}

class _SoldeHeaderState extends State<SoldeHeader> {
  double? _solde;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final suivi = await SuiviService().getSuivi(widget.clientId);
    if (mounted) setState(() => _solde = suivi.isNotEmpty ? suivi.last.solde : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Text(
        'Solde : ${_solde?.toStringAsFixed(0) ?? "..."} FCFA',
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
        textAlign: TextAlign.center,
      ),
    );
  }
}