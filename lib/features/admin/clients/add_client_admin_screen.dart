import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/api/client_service.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/models/promoteur_model.dart';

class AddClientAdminScreen extends StatefulWidget {
  const AddClientAdminScreen({super.key});
  @override
  State<AddClientAdminScreen> createState() => _AddClientAdminScreenState();
}

class _AddClientAdminScreenState extends State<AddClientAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _telephone = TextEditingController();
  final _quartier = TextEditingController();
  final _clientService = ClientService();
  final _promoteurService = PromoteurService();
  List<PromoteurModel> _promoteurs = [];
  int? _promoteurSelectionne;
  bool _loading = false;
  bool _chargementPromoteurs = true;

  @override
  void initState() {
    super.initState();
    _chargerPromoteurs();
  }

  Future<void> _chargerPromoteurs() async {
    final promoteurs = await _promoteurService.getAll();
    setState(() {
      _promoteurs = promoteurs;
      _chargementPromoteurs = false;
    });
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_promoteurSelectionne == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisis un promoteur')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await _clientService.create(
        nomCli: _nom.text.trim(),
        prenomCli: _prenom.text.trim(),
        telephone: _telephone.text.trim().isEmpty ? null : _telephone.text.trim(),
        quartier: _quartier.text.trim().isEmpty ? null : _quartier.text.trim(),
        promoteurId: _promoteurSelectionne!,
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
      appBar: AppBar(title: const Text('Ajouter un client')),
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
                    decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _prenom,
                    decoration: const InputDecoration(labelText: 'Prénom(s)', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telephone,
                    decoration: const InputDecoration(labelText: 'Téléphone (optionnel)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _quartier,
                    decoration: const InputDecoration(labelText: 'Quartier (optionnel)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  _chargementPromoteurs
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Promoteur', border: OutlineInputBorder()),
                          value: _promoteurSelectionne,
                          items: _promoteurs
                              .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nom)))
                              .toList(),
                          onChanged: (v) => setState(() => _promoteurSelectionne = v),
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
        ),
      ),
    );
  }
}