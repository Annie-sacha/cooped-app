import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/pret_model.dart';
import '../../../core/api/pret_service.dart';
import '../../shared/widgets/solde_header.dart';
class PretScreen extends StatefulWidget {
  final ClientModel client;
  const PretScreen({super.key, required this.client});
  @override
  State<PretScreen> createState() => _PretScreenState();
}

class _PretScreenState extends State<PretScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montantSouhaite = TextEditingController();
  final _service = PretService();
  TypePret _type = TypePret.quinzaine;
  bool _loading = false;

  double get _montantValue => double.tryParse(_montantSouhaite.text.trim()) ?? 0;
  int get _coefPret => _type == TypePret.quinzaine ? 30 : 60;
  double get _coefFrais => _type == TypePret.quinzaine ? 1.0 : 1.5;
  int get _duree => _type == TypePret.quinzaine ? 15 : 30;

  double get _mise => _coefPret > 0 ? _montantValue / _coefPret : 0;
  double get _frais => _mise * _coefFrais;

  Future<void> _demander() async {
    if (!_formKey.currentState!.validate()) return;

    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la demande'),
        content: Text(
          'Montant demandé : ${_montantValue.toStringAsFixed(0)} FCFA\n'
          'Mise calculée : ${_mise.toStringAsFixed(0)} FCFA\n'
          'Frais : ${_frais.toStringAsFixed(0)} FCFA\n'
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
      await _service.creer(clientId: widget.client.id, montantMise: _mise, type: _type);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demande de prêt envoyée — en attente de validation admin'), backgroundColor: Colors.green),
        );
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final message = e is DioException && e.response?.data is Map
            ? (e.response!.data['message'] ?? 'Erreur lors de la demande.')
            : 'Erreur lors de la demande.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demande de prêt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(widget.client.nomComplet, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              SoldeHeader(clientId: widget.client.id),
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
                controller: _montantSouhaite,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Montant que le client veut emprunter (FCFA)', border: OutlineInputBorder()),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_montantValue > 0)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mise calculée : ${_mise.toStringAsFixed(0)} FCFA'),
                        Text('Frais : ${_frais.toStringAsFixed(0)} FCFA'),
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
                  onPressed: _loading ? null : _demander,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Demande de prêt'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}