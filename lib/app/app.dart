import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdtudy_flow/app/app_theme.dart';
import 'package:sdtudy_flow/app/router.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/bloc/splash_screen_event.dart';
import 'package:sdtudy_flow/data/remote/auth_service.dart';
import 'package:sdtudy_flow/presentation/pages/auth/bloc/auth_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MultiBlocProvider(
      providers: [
        // SplashBloc handles splash delay/navigation logic
        BlocProvider(create: (_) => SplashBloc()..add(StartSplash())),
        BlocProvider(create: (_) => AuthBloc(authService)),
      ],
      child: MaterialApp.router(
        title: 'StudyMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
