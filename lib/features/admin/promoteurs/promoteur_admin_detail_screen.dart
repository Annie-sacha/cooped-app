import 'package:flutter/material.dart';
import '../../../core/models/promoteur_model.dart';
import '../../../core/api/promoteur_service.dart';
import '../../../core/theme/app_theme.dart';

class PromoteurAdminDetailScreen extends StatefulWidget {
  final PromoteurModel promoteur;
  const PromoteurAdminDetailScreen({super.key, required this.promoteur});
  @override
  State<PromoteurAdminDetailScreen> createState() => _PromoteurAdminDetailScreenState();
}

class _PromoteurAdminDetailScreenState extends State<PromoteurAdminDetailScreen> {
  late final TextEditingController _nom;
  late final TextEditingController _telephone;
  late final TextEditingController _email;
  final _service = PromoteurService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nom = TextEditingController(text: widget.promoteur.nom);
    _telephone = TextEditingController(text: widget.promoteur.telephone);
    _email = TextEditingController(text: widget.promoteur.email);
  }

  Future<void> _enregistrer() async {
    setState(() => _loading = true);
    try {
      await _service.update(
        id: widget.promoteur.id,
        nom: _nom.text.trim(),
        telephone: _telephone.text.trim(),
        email: _email.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promoteur modifié')));
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmerSuppression() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce promoteur ?'),
        content: const Text('Impossible si des clients lui sont encore rattachés.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer', style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
    );
    if (confirme == true) {
      try {
        await _service.delete(widget.promoteur.id);
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Suppression impossible — ce promoteur a probablement des clients rattachés.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.promoteur.nom),
        actions: [IconButton(icon: const Icon(Icons.delete_outline), onPressed: _confirmerSuppression)],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _telephone, decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _enregistrer,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}