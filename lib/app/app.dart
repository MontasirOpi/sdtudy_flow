import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdtudy_flow/app/app_theme.dart';
import 'package:sdtudy_flow/app/router.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/bloc/splash_screen_bloc.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/bloc/splash_screen_event.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc()..add(StartSplash())),
      ],
      child: MaterialApp.router(
        title: 'StudyMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
