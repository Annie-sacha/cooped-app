import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/tontine_model.dart';
import '../../../core/models/carnet_model.dart';
import '../../../core/models/pret_info_tontine_model.dart';
import '../../../core/api/tontine_service.dart';
import '../../../core/api/pret_service.dart';
import '../../../core/theme/app_theme.dart';

class TontineDetailScreen extends StatefulWidget {
  final TontineModel tontine;
  const TontineDetailScreen({super.key, required this.tontine});
  @override
  State<TontineDetailScreen> createState() => _TontineDetailScreenState();
}

class _TontineDetailScreenState extends State<TontineDetailScreen> {
  final _service = TontineService();
  final _pretService = PretService();
  CarnetModel? _carnet;
  PretInfoTontineModel? _infoPret;

  @override
  void initState() {
    super.initState();
    _charger();
    if (widget.tontine.type == 'Pret') _chargerInfoPret();
  }

  Future<void> _charger() async {
    final carnet = await _service.getCarnet(widget.tontine.numero);
    setState(() => _carnet = carnet);
  }

  Future<void> _chargerInfoPret() async {
    final info = await _pretService.getInfoParTontine(widget.tontine.numero);
    if (mounted) setState(() => _infoPret = info);
  }

  Future<void> _confirmerSuppressionCase(int cotisationId) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette cotisation ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirme == true) {
      await _service.supprimerCotisation(cotisationId);
      _charger();
    }
  }

  Future<void> _ouvrirFormulaireCotisation() async {
    final miseController = TextEditingController(text: widget.tontine.mise.toStringAsFixed(0));
    final nbreMiseController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enregistrer une cotisation'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: miseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mise par case (FCFA)',
                  helperText: 'Si ça change définitivement la mise de la tontine',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (double.tryParse(v.trim()) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nbreMiseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nombre de cases couvertes',
                  helperText: 'Mettre 2 ou plus si le client rattrape plusieurs jours',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requis';
                  if (int.tryParse(v.trim()) == null) return 'Nombre invalide';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (confirme == true) {
      final mise = double.parse(miseController.text.trim());
      final nbreMise = int.parse(nbreMiseController.text.trim());
      final montantTotal = mise * nbreMise;

      try {
        await _service.ajouterCotisation(
          tontineId: widget.tontine.numero,
          montant: montantTotal,
          nbreMise: nbreMise,
        );
        _charger();
      } catch (e) {
        if (mounted) {
          final message = e is DioException && e.response?.data is Map
              ? (e.response!.data['message'] ?? 'Erreur lors de l\'enregistrement.')
              : 'Erreur lors de l\'enregistrement.';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carnet == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final c = _carnet!;
    final casesRemplies = c.cases.where((cs) => cs.remplie).length;
    final montantCotise = casesRemplies * c.mise;
    final montantTotal = c.mise * c.nbreMise;
    final montantVerse = montantTotal - c.mise;

    return Scaffold(
      appBar: AppBar(title: Text('Cotisation ${c.mise.toStringAsFixed(0)} FCFA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_infoPret != null) ...[
              Card(
                color: AppTheme.primaryDark.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _infoPret!.phase == 'Collecte' ? Icons.arrow_upward : Icons.arrow_downward,
                            color: AppTheme.primaryDark,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _infoPret!.phase == 'Collecte' ? 'Collecte du prêt' : 'Remboursement du prêt',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Type : ${_infoPret!.type}'),
                      Text('Montant à prêter : ${_infoPret!.montantPrete.toStringAsFixed(0)} FCFA'),
                      Text('Frais : ${_infoPret!.frais.toStringAsFixed(0)} FCFA'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(c.cloturee ? 'Clôturée' : 'En cours', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Du ${widget.tontine.dateCreation} au ${c.cloturee ? (widget.tontine.dateFin ?? "?") : (widget.tontine.dateFinPrevue ?? "?")}',
            ),
            const SizedBox(height: 4),
            Text(
              'Montant cotisé : ${montantCotise.toStringAsFixed(0)} FCFA',
              style: const TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemCount: c.cases.length,
              itemBuilder: (context, i) {
                final case_ = c.cases[i];
                return GestureDetector(
                  onTap: case_.suppressible ? () => _confirmerSuppressionCase(case_.cotisationId!) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: case_.remplie ? Colors.green.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: case_.suppressible ? Colors.orange : Colors.grey.shade400),
                    ),
                    child: Center(
                      child: Text(
                        case_.remplie ? (case_.date ?? '✓') : '${case_.position}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (c.cloturee) ...[
              const Divider(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Montant total'),
                        Text('${montantTotal.toStringAsFixed(0)} FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Montant versé au client'),
                        Text('${montantVerse.toStringAsFixed(0)} FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: c.cloturee
          ? null
          : FloatingActionButton.extended(
              onPressed: _ouvrirFormulaireCotisation,
              icon: const Icon(Icons.add),
              label: const Text('Cotisation'),
            ),
    );
  }
}