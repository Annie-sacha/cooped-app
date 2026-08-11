import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/tontine_model.dart';
import '../../../core/api/tontine_service.dart';
import '../../shared/widgets/solde_header.dart';
import 'create_tontine_screen.dart';
import 'tontine_detail_screen.dart';

class TontinesParTypeScreen extends StatefulWidget {
  final ClientModel client;
  final String type;
  const TontinesParTypeScreen({super.key, required this.client, required this.type});

  @override
  State<TontinesParTypeScreen> createState() => _TontinesParTypeScreenState();
}

class _TontinesParTypeScreenState extends State<TontinesParTypeScreen> {
  final _service = TontineService();
  List<TontineModel> _tontines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);
    final toutes = await _service.getByClient(widget.client.id);
    setState(() {
      _tontines = toutes.where((t) => t.type == widget.type).toList();
      _loading = false;
    });
  }

  Future<void> _confirmerSuppression(int tontineId) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette tontine ?'),
        content: const Text('Uniquement possible si aucune cotisation n\'a été enregistrée.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirme == true) {
      try {
        await _service.supprimer(tontineId);
        _charger();
      } catch (e) {
        if (mounted) {
          final message = e is DioException && e.response?.data is Map
              ? (e.response!.data['message'] ?? 'Erreur lors de la suppression.')
              : 'Erreur lors de la suppression.';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titre = widget.type == 'Normale'
        ? 'Tontines Normales'
        : widget.type == 'Pret'
            ? 'Tontines de Prêt'
            : 'Tontines d\'Achat';

    return Scaffold(
      appBar: AppBar(title: Text('$titre — ${widget.client.nomComplet}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SoldeHeader(clientId: widget.client.id),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _tontines.isEmpty
                    ? const Center(child: Text('Aucune tontine dans cette catégorie'))
                    : ListView.builder(
                        itemCount: _tontines.length,
                        itemBuilder: (context, i) {
                          final t = _tontines[i];
                          return ListTile(
                            title: Text('${t.mise.toStringAsFixed(0)} FCFA / cotisation'),
                            subtitle: Text('${t.nbreMise} cases — ${t.estActive ? "En cours" : "Clôturée"}\n${t.periode}'),
                            trailing: Icon(Icons.circle, color: t.estActive ? Colors.green : Colors.grey, size: 12),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TontineDetailScreen(tontine: t))),
                            onLongPress: () => _confirmerSuppression(t.numero),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: (widget.type == 'Normale' && _tontines.isEmpty)
      ? FloatingActionButton.extended(
          onPressed: () async {
            final cree = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateTontineScreen(clientId: widget.client.id)),
            );
            if (cree == true) _charger();
          },
          icon: const Icon(Icons.add),
          label: const Text('Nouvelle cotisation'),
        )
      : null,
    );
  }
}