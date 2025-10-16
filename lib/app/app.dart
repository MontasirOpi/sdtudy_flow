import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdtudy_flow/app/app_theme.dart';
import 'package:sdtudy_flow/app/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return MultiBlocProvider(
      providers: [
        // ✅ Add your BLoCs here globally (if needed)
        // BlocProvider(create: (_) => AuthBloc()),
        // BlocProvider(create: (_) => ThemeCubit()),
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
