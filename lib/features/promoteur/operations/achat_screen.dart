import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/achat_service.dart';

class AchatScreen extends StatefulWidget {
  final ClientModel client;
  const AchatScreen({super.key, required this.client});
  @override
  State<AchatScreen> createState() => _AchatScreenState();
}

class _AchatScreenState extends State<AchatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montant = TextEditingController();
  final _article = TextEditingController();
  final _service = AchatService();
  bool _loading = false;

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.creer(
        clientId: widget.client.id,
        montant: double.parse(_montant.text.trim()),
        article: _article.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Achat enregistré avec succès'), backgroundColor: Colors.green),
        );
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final message = e is DioException && e.response?.data is Map
            ? (e.response!.data['message'] ?? 'Erreur lors de l\'enregistrement.')
            : 'Erreur lors de l\'enregistrement.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Achat — ${widget.client.nomComplet}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _article,
                decoration: const InputDecoration(labelText: 'Article / Désignation', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montant,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Montant (FCFA)', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _enregistrer,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer l\'achat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}