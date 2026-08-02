import 'package:flutter/material.dart';
import 'dashboard/admin_dashboard_screen.dart';
import 'clients/admin_clients_screen.dart';
import 'promoteurs/admin_promoteurs_screen.dart';
import 'validations/validations_screen.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  final _screens = const [
    AdminDashboardScreen(),
    AdminClientsScreen(),
    AdminPromoteursScreen(),
    ValidationsScreen(),
  ];

  final _labels = const ['Tableau de bord', 'Clients', 'Promoteurs', 'Validations'];
  final _icons = const [Icons.dashboard_outlined, Icons.people_outline, Icons.badge_outlined, Icons.fact_check_outlined];

  @override
  Widget build(BuildContext context) {
    final estLarge = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: Row(
        children: [
          if (estLarge)
            NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                extended: true,
                labelType: NavigationRailLabelType.none,
                leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                    children: [
                    Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(gradient: AppTheme.gradientPrimary, shape: BoxShape.circle),
                        child: const Icon(Icons.savings_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(height: 8),
                    const Text('COOPED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text('Admin', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                trailing: Expanded(
                    child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextButton.icon(
                        onPressed: () async {
                            final confirme = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                title: const Text('Se déconnecter ?'),
                                actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Se déconnecter', style: TextStyle(color: AppTheme.danger)),
                                ),
                                ],
                            ),
                            );
                            if (confirme == true && context.mounted) {
                            await context.read<AuthProvider>().logout();
                            }
                        },
                        icon: const Icon(Icons.logout, color: AppTheme.danger),
                        label: const Text('Déconnexion', style: TextStyle(color: AppTheme.danger)),
                        ),
                    ),
                    ),
                ),
                destinations: List.generate(
                    _labels.length,
                    (i) => NavigationRailDestination(icon: Icon(_icons[i]), label: Text(_labels[i])),
                ),
                ),
          const VerticalDivider(width: 1),
          Expanded(child: _screens[_index]),
        ],
      ),
      bottomNavigationBar: estLarge
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: List.generate(
                _labels.length,
                (i) => NavigationDestination(icon: Icon(_icons[i]), label: _labels[i]),
              ),
            ),
    );
  }
}