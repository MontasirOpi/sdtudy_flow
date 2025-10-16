import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ✅ Import all your screens
import 'package:sdtudy_flow/presentation/pages/auth/login_screen.dart';
import 'package:sdtudy_flow/presentation/pages/auth/sign_up_screen.dart';
import 'package:sdtudy_flow/presentation/pages/home/home_screen.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/splash_screen.dart';

/// Centralized router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Start with SplashScreen
    routes: [
      /// Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      /// Login Screen
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      /// Sign Up Screen
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),

      /// Home Screen
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // ✅ (Optional) Future routes
      // GoRoute(
      //   path: '/schedule',
      //   name: 'schedule',
      //   builder: (context, state) => const SchedulePage(),
      // ),
      // GoRoute(
      //   path: '/assignments',
      //   name: 'assignments',
      //   builder: (context, state) => const AssignmentsPage(),
      // ),
      // GoRoute(
      //   path: '/notes',
      //   name: 'notes',
      //   builder: (context, state) => const NotesPage(),
      // ),
    ],
  );
}
