import 'package:flutter/material.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/tontine_model.dart';
import '../../../core/api/tontine_service.dart';
import 'create_tontine_screen.dart';
import 'tontine_detail_screen.dart';
import 'package:dio/dio.dart';

IconData _iconePourType(String type) {
  switch (type) {
    case 'Pret':
      return Icons.handshake;
    case 'Achat':
      return Icons.shopping_bag;
    default:
      return Icons.savings_outlined;
  }
}

Color _couleurPourType(String type) {
  switch (type) {
    case 'Pret':
      return Colors.orange;
    case 'Achat':
      return Colors.blue;
    default:
      return Colors.green;
  }
}

class ClientTontinesScreen extends StatefulWidget {
  final ClientModel client;
  const ClientTontinesScreen({super.key, required this.client});

  @override
  State<ClientTontinesScreen> createState() => _ClientTontinesScreenState();
}

class _ClientTontinesScreenState extends State<ClientTontinesScreen> {
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
    final tontines = await _service.getByClient(widget.client.id);
    setState(() {
      _tontines = tontines;
      _loading = false;
    });
  }

  Future<void> _confirmerSuppression(int tontineId) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette tontine ?'),
        content: const Text(
          'Uniquement possible si aucune cotisation n\'a été enregistrée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
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
              ? (e.response!.data['message'] ??
                  'Erreur lors de la suppression.')
              : 'Erreur lors de la suppression.';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tontines de ${widget.client.nomComplet}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tontines.isEmpty
              ? const Center(child: Text('Aucune tontine pour ce client'))
              : ListView.builder(
                  itemCount: _tontines.length,
                  itemBuilder: (context, i) {
                    final t = _tontines[i];
                    return ListTile(
                      leading: Icon(
                        _iconePourType(t.type),
                        color: _couleurPourType(t.type),
                      ),
                      title: Row(
                        children: [
                          Text(
                            '${t.mise.toStringAsFixed(0)} FCFA / cotisation',
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _couleurPourType(t.type)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              t.type,
                              style: TextStyle(
                                fontSize: 10,
                                color: _couleurPourType(t.type),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${t.nbreMise} cases — ${t.estActive ? "En cours" : "Clôturée"}\n${t.periode}',
                      ),
                      trailing: t.estActive
                          ? const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 12,
                            )
                          : const Icon(
                              Icons.circle,
                              color: Colors.grey,
                              size: 12,
                            ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TontineDetailScreen(tontine: t),
                        ),
                      ),
                      onLongPress: () =>
                          _confirmerSuppression(t.numero),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cree = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CreateTontineScreen(clientId: widget.client.id),
            ),
          );
          if (cree == true) _charger();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle cotisation'),
      ),
    );
  }
}