import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:sdtudy_flow/data/remote/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);

    // Handle password toggle events - works for ALL states now
    on<TogglePasswordVisibility>((event, emit) {
      emit(
        AuthInitial(
          obscurePassword: !state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    });

    on<ToggleConfirmPasswordVisibility>((event, emit) {
      emit(
        AuthInitial(
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: !state.obscureConfirmPassword,
        ),
      );
    });
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
      ),
    );
    try {
      await authService.signIn(event.email, event.password);
      emit(
        AuthSuccess(
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    } catch (e) {
      emit(
        AuthFailure(
          e.toString(),
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
      ),
    );
    try {
      await authService.signUp(event.email, event.password);
      emit(
        AuthSuccess(
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    } catch (e) {
      emit(
        AuthFailure(
          e.toString(),
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    }
  }
}
