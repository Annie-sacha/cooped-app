import 'package:flutter/material.dart';
import 'validations_retraits_tab.dart';
import 'validations_prets_tab.dart';

class ValidationsScreen extends StatelessWidget {
  const ValidationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Validations'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Retraits'),
              Tab(text: 'Prêts'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ValidationsRetraitsTab(),
            ValidationsPretsTab(),
          ],
        ),
      ),
    );
  }
}