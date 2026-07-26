import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/retrait_service.dart';

class RetraitScreen extends StatefulWidget {
  final ClientModel client;
  const RetraitScreen({super.key, required this.client});
  @override
  State<RetraitScreen> createState() => _RetraitScreenState();
}

class _RetraitScreenState extends State<RetraitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montant = TextEditingController();
  final _motif = TextEditingController();
  final _service = RetraitService();
  bool _loading = false;

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.creer(
        clientId: widget.client.id,
        montantTotal: double.parse(_montant.text.trim()),
        motif: _motif.text.trim().isEmpty ? null : _motif.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        final message = e is DioException && e.response?.data is Map
            ? (e.response!.data['message'] ?? 'Erreur lors du retrait.')
            : 'Erreur lors du retrait.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Retrait — ${widget.client.nomComplet}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _montant,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Montant à retirer (FCFA)', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _motif,
                decoration: const InputDecoration(labelText: 'Motif (optionnel)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _enregistrer,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer le retrait'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}