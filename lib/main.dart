import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth/auth_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';


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
            theme: AppTheme.theme,
            routerConfig: buildRouter(auth),
        ),
      ),
    );
  }
}