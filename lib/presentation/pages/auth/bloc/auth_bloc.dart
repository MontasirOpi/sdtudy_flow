import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthApiException;
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:sdtudy_flow/data/remote/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  String? _lastEmail; // Store email for resend

  AuthBloc(this.authService) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ResendVerificationEmail>(_onResendVerificationEmail);

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
    print('🔵 Login requested for: ${event.email}');

    emit(
      AuthLoading(
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
      ),
    );

    try {
      _lastEmail = event.email;
      final user = await authService.signIn(event.email, event.password);

      print('🟢 Email verified, login successful');
      emit(
        AuthSuccess(
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    } catch (e) {
      print('🔴 Login error: $e');

      // Check if it's an AuthApiException
      if (e is AuthApiException) {
        print('🔴 AuthApiException - code: ${e.code}, message: ${e.message}');

        // Check for email_not_confirmed error code
        if (e.code == 'email_not_confirmed') {
          print('⚠️ Email not verified');
          emit(
            AuthEmailNotVerified(
              obscurePassword: state.obscurePassword,
              obscureConfirmPassword: state.obscureConfirmPassword,
            ),
          );
          return;
        }

        // Handle other API errors
        emit(
          AuthFailure(
            e.message,
            obscurePassword: state.obscurePassword,
            obscureConfirmPassword: state.obscureConfirmPassword,
          ),
        );
      } else {
        // Handle other errors
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

  Future<void> _onResendVerificationEmail(
    ResendVerificationEmail event,
    Emitter<AuthState> emit,
  ) async {
    if (_lastEmail == null) return;

    try {
      await authService.resendVerificationEmail(_lastEmail!);
      // Stay in the same state after resending
    } catch (e) {
      emit(
        AuthFailure(
          'Failed to resend verification email',
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    }
  }
}
