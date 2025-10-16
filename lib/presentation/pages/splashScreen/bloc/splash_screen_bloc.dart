import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/bloc/splash_screen_event.dart';
import 'package:sdtudy_flow/presentation/pages/splashScreen/bloc/splash_screen_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));
      emit(SplashLoaded());
    });
  }
}
