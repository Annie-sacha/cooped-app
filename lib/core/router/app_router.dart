import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/admin/dashboard/admin_dashboard_screen.dart';
import '../../features/promoteur/promoteur_shell.dart';



GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    refreshListenable: auth,
    initialLocation: '/login',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';

      if (!auth.isAuthenticated) return loggingIn ? null : '/login';
      if (loggingIn) {
        return auth.role == 'Administrateur' ? '/admin' : '/promoteur';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
      GoRoute(path: '/promoteur', builder: (context, state) => const PromoteurShell()),

    ],
  );
}

