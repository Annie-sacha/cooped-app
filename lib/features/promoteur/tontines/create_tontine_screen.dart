import 'package:flutter/material.dart';
import '../../../core/api/tontine_service.dart';

class CreateTontineScreen extends StatefulWidget {
  final int clientId;
  const CreateTontineScreen({super.key, required this.clientId});
  @override
  State<CreateTontineScreen> createState() => _CreateTontineScreenState();
}

class _CreateTontineScreenState extends State<CreateTontineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mise = TextEditingController();
  final _service = TontineService();
  bool _loading = false;

  Future<void> _creer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.creer(
        clientId: widget.clientId,
        mise: double.parse(_mise.text.trim()),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création de la tontine.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une cotisation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mise,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant de la mise (FCFA)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'La mise est requise';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _creer,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Créer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}