import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/api/client_service.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});
  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _telephone = TextEditingController();
  final _quartier = TextEditingController();
  final _service = ClientService();
  bool _loading = false;

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final auth = context.read<AuthProvider>();
    try {
      await _service.create(
        nomCli: _nom.text.trim(),
        prenomCli: _prenom.text.trim(),
        telephone: _telephone.text.trim().isEmpty ? null : _telephone.text.trim(),
        quartier: _quartier.text.trim().isEmpty ? null : _quartier.text.trim(),
        promoteurId: auth.utilisateurId!,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création du client.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un client')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nom,
                decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prenom,
                decoration: const InputDecoration(labelText: 'Prénom(s)', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Le prénom est requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telephone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Téléphone (optionnel)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quartier,
                decoration: const InputDecoration(labelText: 'Quartier (optionnel)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _enregistrer,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer le client'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}