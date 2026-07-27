import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/pret_model.dart';
import '../../../core/api/pret_service.dart';

class PretScreen extends StatefulWidget {
  final ClientModel client;
  const PretScreen({super.key, required this.client});
  @override
  State<PretScreen> createState() => _PretScreenState();
}

class _PretScreenState extends State<PretScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mise = TextEditingController();
  final _service = PretService();
  TypePret _type = TypePret.quinzaine;
  bool _loading = false;

  double get _miseValue => double.tryParse(_mise.text.trim()) ?? 0;
  double get _coefFrais => _type == TypePret.quinzaine ? 1.0 : 1.5;
  int get _coefPret => _type == TypePret.quinzaine ? 30 : 60;
  int get _duree => _type == TypePret.quinzaine ? 15 : 30;

  double get _frais => _miseValue * _coefFrais;
  double get _montantPrete => _miseValue * _coefPret;

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer le prêt'),
        content: Text(
          'Mise : ${_miseValue.toStringAsFixed(0)} FCFA\n'
          'Frais prélevés : ${_frais.toStringAsFixed(0)} FCFA\n'
          'Montant prêté au client : ${_montantPrete.toStringAsFixed(0)} FCFA\n'
          'Remboursement dans $_duree jours',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmer')),
        ],
      ),
    );
    if (confirme != true) return;

    setState(() => _loading = true);
    try {
      final resultat = await _service.creer(
        clientId: widget.client.id,
        montantMise: _miseValue,
        type: _type,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prêt accordé : ${resultat.montantPrete.toStringAsFixed(0)} FCFA'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final message = e is DioException && e.response?.data is Map
            ? (e.response!.data['message'] ?? 'Erreur lors de la création du prêt.')
            : 'Erreur lors de la création du prêt.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prêt — ${widget.client.nomComplet}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SegmentedButton<TypePret>(
                segments: const [
                  ButtonSegment(value: TypePret.quinzaine, label: Text('Quinzaine')),
                  ButtonSegment(value: TypePret.mensuel, label: Text('Mensuel')),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mise,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Montant de la mise (FCFA)', border: OutlineInputBorder()),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_miseValue > 0)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frais : ${_frais.toStringAsFixed(0)} FCFA'),
                        Text('Montant prêté : ${_montantPrete.toStringAsFixed(0)} FCFA',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Remboursement dans $_duree jours'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _enregistrer,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Accorder le prêt'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}