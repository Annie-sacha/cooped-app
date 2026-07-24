import 'package:flutter/material.dart';
import '../../../core/models/tontine_model.dart';
import '../../../core/models/carnet_model.dart';
import '../../../core/api/tontine_service.dart';

class TontineDetailScreen extends StatefulWidget {
  final TontineModel tontine;
  const TontineDetailScreen({super.key, required this.tontine});
  @override
  State<TontineDetailScreen> createState() => _TontineDetailScreenState();
}

class _TontineDetailScreenState extends State<TontineDetailScreen> {
  final _service = TontineService();
  CarnetModel? _carnet;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final carnet = await _service.getCarnet(widget.tontine.numero);
    setState(() => _carnet = carnet);
  }

  Future<void> _ajouterCotisation() async {
    await _service.ajouterCotisation(tontineId: widget.tontine.numero, montant: widget.tontine.mise);
    _charger();
  }


  Future<void> _confirmerSuppression(int cotisationId) async {
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


  @override
  Widget build(BuildContext context) {
    if (_carnet == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final c = _carnet!;

    return Scaffold(
      appBar: AppBar(title: Text('Tontine ${c.mise.toStringAsFixed(0)} FCFA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(c.cloturee ? 'Clôturée' : 'En cours', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  onTap: case_.suppressible ? () => _confirmerSuppression(case_.cotisationId!) : null,
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
          ],
        ),
      ),
      floatingActionButton: c.cloturee
          ? null
          : FloatingActionButton.extended(
              onPressed: _ajouterCotisation,
              icon: const Icon(Icons.add),
              label: const Text('Cotisation'),
            ),
    );
  }
}