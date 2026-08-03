import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/api/client_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../promoteur/tontines/create_tontine_screen.dart';
import '../../promoteur/tontines/client_tontines_screen.dart';
import '../../promoteur/operations/retrait_screen.dart';
import '../../promoteur/operations/pret_screen.dart';
import '../../promoteur/operations/achat_screen.dart';
import '../../promoteur/suivi/client_suivi_screen.dart';
import '../../shared/client_frais_screen.dart';

class ClientAdminDetailScreen extends StatefulWidget {
  final ClientModel client;
  const ClientAdminDetailScreen({super.key, required this.client});
  @override
  State<ClientAdminDetailScreen> createState() => _ClientAdminDetailScreenState();
}

class _ClientAdminDetailScreenState extends State<ClientAdminDetailScreen> {
  late final TextEditingController _nom;
  late final TextEditingController _prenom;
  late final TextEditingController _telephone;
  late final TextEditingController _quartier;
  late final TextEditingController _depot;
  final _service = ClientService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _nom = TextEditingController(text: c.nomCli);
    _prenom = TextEditingController(text: c.prenomCli);
    _telephone = TextEditingController(text: c.telephone ?? '');
    _quartier = TextEditingController(text: c.quartier ?? '');
    _depot = TextEditingController(text: c.montantDepotRequis?.toStringAsFixed(0) ?? '');
    _verifierPenalites();
  }

  Future<void> _verifierPenalites() async {
    final penalites = await _service.verifierPenalites(widget.client.id);
    if (penalites.isNotEmpty && mounted) {
      for (final p in penalites) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '⚠️ Pénalité appliquée : ${p.montantPenalite?.toStringAsFixed(0)} FCFA — nouvelle échéance ${p.nouvelleEcheance}',
            ),
            backgroundColor: AppTheme.warning,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _enregistrerInfos() async {
    setState(() => _loading = true);
    try {
      await _service.update(
        id: widget.client.id,
        nomCli: _nom.text.trim(),
        prenomCli: _prenom.text.trim(),
        telephone: _telephone.text.trim().isEmpty ? null : _telephone.text.trim(),
        quartier: _quartier.text.trim().isEmpty ? null : _quartier.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client modifié')));
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _enregistrerDepot() async {
    final montant = _depot.text.trim().isEmpty ? null : double.tryParse(_depot.text.trim());
    await _service.definirDepotRequis(widget.client.id, montant);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dépôt requis mis à jour')));
    }
  }

  Future<void> _confirmerSuppression() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce client ?'),
        content: const Text('Cette action est irréversible.'),
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
        await _service.delete(widget.client.id);
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impossible de supprimer ce client (il a probablement des transactions).')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.client;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.nomComplet),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _confirmerSuppression),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Informations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _prenom, decoration: const InputDecoration(labelText: 'Prénom(s)', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _telephone, decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _quartier, decoration: const InputDecoration(labelText: 'Quartier', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _loading ? null : _enregistrerInfos,
                  child: const Text('Enregistrer les informations'),
                ),
              ),
              const Divider(height: 40),
              const Text('Éligibilité au prêt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                'Montant qu\'un nouveau client doit avoir cotisé pour être éligible à un prêt avant ses 3 mois d\'ancienneté.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _depot,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Dépôt requis (FCFA, vide = aucun)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _enregistrerDepot, child: const Text('Mettre à jour le dépôt requis')),
              ),
              const Divider(height: 40),
              const Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateTontineScreen(clientId: c.id))),
                    icon: const Icon(Icons.savings),
                    label: const Text('Nouvelle tontine'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientTontinesScreen(client: c))),
                    icon: const Icon(Icons.add_card),
                    label: const Text('Cotisation'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RetraitScreen(client: c))),
                    icon: const Icon(Icons.money_off),
                    label: const Text('Retrait'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PretScreen(client: c))),
                    icon: const Icon(Icons.handshake),
                    label: const Text('Prêt'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AchatScreen(client: c))),
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Achat'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientFraisScreen(client: c))),
                    icon: const Icon(Icons.percent),
                    label: const Text('Frais'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientSuiviScreen(client: c))),
                    icon: const Icon(Icons.history),
                    label: const Text('Suivi'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}