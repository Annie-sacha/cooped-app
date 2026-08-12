import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/achat_service.dart';
import '../../shared/widgets/solde_header.dart';

class OuvrirCotisationAchatScreen extends StatefulWidget {
  final ClientModel client;
  const OuvrirCotisationAchatScreen({super.key, required this.client});
  @override
  State<OuvrirCotisationAchatScreen> createState() => _OuvrirCotisationAchatScreenState();
}

class _OuvrirCotisationAchatScreenState extends State<OuvrirCotisationAchatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _article = TextEditingController();
  final _montant = TextEditingController();
  final _service = AchatService();
  bool _loading = false;

  double get _montantValue => double.tryParse(_montant.text.trim()) ?? 0;
  double get _miseCalculee => _montantValue > 0 ? (_montantValue / 31).ceilToDouble() : 0;

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.creerCotisation(
        clientId: widget.client.id,
        article: _article.text.trim(),
        montant: _montantValue,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotisation d\'achat ouverte avec succès'), backgroundColor: Colors.green),
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
      appBar: AppBar(title: const Text('Ouvrir une cotisation d\'achat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SoldeHeader(clientId: widget.client.id),
              TextFormField(
                controller: _article,
                decoration: const InputDecoration(labelText: 'Article', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montant,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Montant total de l\'article (FCFA)', border: OutlineInputBorder()),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_montantValue > 0)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mise par jour : ${_miseCalculee.toStringAsFixed(0)} FCFA'),
                        const Text('Sur 31 cases'),
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
                      : const Text('Ouvrir la cotisation d\'achat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}