import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../views/_initial_views/_wrapper/store/wrapper_store.dart';
import '../views/_initial_views/auth_state_checker.dart';
import '../views/auth/create_account/_subviews/character_creation/view/character_creation_view.dart';
import '../views/auth/login/view/login_view.dart';
import '../views/auth/create_account/view/create_account_view.dart';
import '../views/auth/welcome_view.dart';
import '../views/home/_subviews/ar_camera/view/ar_camera_view.dart';
import '../views/home/_subviews/ar_combat/view/ar_combat_view.dart';
import '../views/home/_subviews/combat_training/view/combat_training_view.dart';
import '../views/home/view/home_view.dart';
import '../views/onboard/view/onboard_view.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

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
      ShellRoute(
        builder: (context, state, child) {
          return AuthStateChecker(child: child);
        },
        redirect: (context, state) {
          if (state.uri.fragment.isNotEmpty) {
            context.read<WrapperStore>().deepRedirect = state.uri.fragment;
          }
          return null;
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
            path: '/home',
            name: 'Home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'ar-combat',
                name: 'AR Combat',
                builder: (context, state) {
                  final Map<String, dynamic> extra =
                      state.extra as Map<String, dynamic>;
                  return ARCombatScreen(monster: extra['monster']);
                },
              ),
              GoRoute(
                path: 'ar-camera',
                name: 'AR Camera',
                builder: (context, state) => ARCameraScreen(),
              ),
              GoRoute(
                path: 'combat-training',
                name: 'Combat Training',
                builder: (context, state) => CombatTrainingScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/auth/create-account',
            name: 'Create Account',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: '/auth/login',
            name: 'Login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/auth/character-creation',
            name: 'Character Creation',
            builder: (context, state) {
              final Map<String, dynamic> extra =
                  state.extra as Map<String, dynamic>;
              return CharacterCreationScreen(
                email: extra['email'] ?? '',
                username: extra['username'] ?? '',
                password: extra['password'] ?? '',
              );
            },
          ),
          GoRoute(
            path: '/onboarding',
            name: 'Onboarding',
            builder: (context, state) => const OnboardView(),
          ),
        ],
      ),
    ],
  );
}
