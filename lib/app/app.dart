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
    return MultiBlocProvider(
      providers: [
        // SplashBloc handles splash delay/navigation logic
        BlocProvider(create: (_) => SplashBloc()..add(StartSplash())),
        // ✅ You can add more blocs here in the future (e.g., AuthBloc, NotesBloc, etc.)
      ],
      child: MaterialApp.router(
        title: 'StudyMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router, // directly use the static router
      ),
    );
  }
}
