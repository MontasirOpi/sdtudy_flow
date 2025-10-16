import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sdtudy_flow/presentation/pages/auth/login_screen.dart';
import 'package:sdtudy_flow/presentation/pages/home/home_screen.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/splash_screen.dart';

// ✅ Import your pages
// import 'package:your_app_name/presentation/pages/home/home_page.dart';
// import 'package:your_app_name/presentation/pages/schedule/schedule_page.dart';
// import 'package:your_app_name/presentation/pages/assignments/assignments_page.dart';
// import 'package:your_app_name/presentation/pages/notes/notes_page.dart';
// import 'package:your_app_name/presentation/pages/auth/login_page.dart';

class AppRouter {
  GoRouter get router => GoRouter(
    routes: [
      // GoRoute(
      //   path: '/',
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
      GoRoute(
        path: '/',
        name: 'splashscreen',
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
