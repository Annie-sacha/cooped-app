import 'package:flutter/material.dart';
import 'dashboard/admin_dashboard_screen.dart';
import 'clients/admin_clients_screen.dart';
import 'promoteurs/admin_promoteurs_screen.dart';
import 'validations/validations_screen.dart';

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
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('COOPED\nAdmin', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
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