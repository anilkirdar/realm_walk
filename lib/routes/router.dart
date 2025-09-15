import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/auth/login/view/login_view.dart';
import '../views/auth/create_account/view/create_account_view.dart';
import '../views/auth/user_choice/view/user_choice_view.dart';
import '../views/auth/welcome_view.dart';
import '../views/onboard/view/onboard_view.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _authNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return null; // Eğer auth kontrolü gerekiyorsa buraya eklenebilir.
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Page not found: ${state.uri.path}')),
      );
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'Welcome',
        redirect: (context, state) async {
          return null;
        },
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'Onboarding',
        builder: (context, state) => const OnboardView(),
      ),
      ShellRoute(
        navigatorKey: _authNavigatorKey,
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/auth/user-choice',
            name: 'User Choice',
            builder: (context, state) => const UserChoiceView(),
          ),
          GoRoute(
            path: '/auth/create-account',
            name: 'Create Account',
            builder: (context, state) => const CreateAccountView(),
          ),
          GoRoute(
            path: '/auth/login',
            name: 'Login',
            builder: (context, state) => const LoginView(),
          ),
        ],
      ),
    ],
  );
}
