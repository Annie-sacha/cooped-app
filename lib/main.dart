import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth/auth_provider.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const CoopedApp());
}

class CoopedApp extends StatelessWidget {
  const CoopedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..tryAutoLogin(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp.router(
          title: 'COOPED',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          routerConfig: buildRouter(auth),
        ),
      ),
    );
  }
}