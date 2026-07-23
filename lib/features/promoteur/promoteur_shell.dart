import 'package:flutter/material.dart';
import 'dashboard/promoteur_dashboard_screen.dart';
import 'clients/promoteur_clients_screen.dart';

class PromoteurShell extends StatefulWidget {
  const PromoteurShell({super.key});
  @override
  State<PromoteurShell> createState() => _PromoteurShellState();
}

class _PromoteurShellState extends State<PromoteurShell> {
  int _index = 0;

  final _screens = const [
    PromoteurDashboardScreen(),
    PromoteurClientsScreen(),
    Center(child: Text('Tontines (à venir)')),
    Center(child: Text('Opérations (à venir)')),
    Center(child: Text('Profil (à venir)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Clients'),
          NavigationDestination(icon: Icon(Icons.savings_outlined), selectedIcon: Icon(Icons.savings), label: 'Tontines'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Opérations'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}