import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/api/promoteur_service.dart';

class AddPromoteurScreen extends StatefulWidget {
  const AddPromoteurScreen({super.key});
  @override
  State<AddPromoteurScreen> createState() => _AddPromoteurScreenState();
}

class _AddPromoteurScreenState extends State<AddPromoteurScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _telephone = TextEditingController();
  final _email = TextEditingController();
  final _motDePasse = TextEditingController();
  final _service = PromoteurService();
  bool _loading = false;

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.create(
        nom: _nom.text.trim(),
        telephone: _telephone.text.trim(),
        email: _email.text.trim(),
        motDePasse: _motDePasse.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        final message = e is DioException && e.response?.data is Map
            ? (e.response!.data['message'] ?? 'Erreur lors de la création.')
            : 'Erreur lors de la création.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un promoteur')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nom,
                    decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telephone,
                    decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _motDePasse,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Mot de passe', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().length < 4) ? 'Minimum 4 caractères' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _enregistrer,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Enregistrer le promoteur'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}