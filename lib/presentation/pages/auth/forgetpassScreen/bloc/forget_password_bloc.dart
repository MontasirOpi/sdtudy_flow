import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final SupabaseClient supabase;

  ForgetPasswordBloc(this.supabase) : super(ForgetPasswordInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordWithOtpEvent>(_onResetPassword);
    on<ToggleNewPasswordVisibility>(_onToggleNewPassword);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPassword);
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(ForgetPasswordLoading());
    try {
      await supabase.auth.signInWithOtp(
        email: event.email,
        shouldCreateUser: false, // Don't create user if it doesn't exist
      );

      emit(ForgetPasswordOtpSent(event.email));
    } on AuthException catch (e) {
      if (e.message.contains('User not found')) {
        emit(ForgetPasswordFailure("No account found with this email"));
      } else {
        emit(ForgetPasswordFailure("Failed to send OTP: ${e.message}"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(ForgetPasswordLoading());
    try {
      final response = await supabase.auth.verifyOTP(
        email: event.email,
        token: event.otp,
        type: OtpType.email,
      );

      if (response.session != null) {
        // OTP verified
        emit(ForgetPasswordOtpVerified(event.email, event.otp));
      } else {
        emit(ForgetPasswordFailure("Invalid or expired OTP code"));
      }
    } on AuthException catch (e) {
      if (e.message.contains('Token has expired') ||
          e.message.contains('expired')) {
        emit(
          ForgetPasswordFailure(
            "OTP code has expired. Please request a new one.",
          ),
        );
      } else if (e.message.contains('Invalid') ||
          e.message.contains('invalid')) {
        emit(ForgetPasswordFailure("Invalid OTP code. Please try again."));
      } else {
        emit(ForgetPasswordFailure("Verification failed: ${e.message}"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("Error: ${e.toString()}"));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordWithOtpEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(ForgetPasswordLoading());
    try {
      // Update password
      await supabase.auth.updateUser(
        UserAttributes(password: event.newPassword),
      );

      // Sign out after resetting for security
      await supabase.auth.signOut();

      emit(
        ForgetPasswordSuccess(
          "Password reset successfully! Please login with your new password.",
        ),
      );
    } on AuthException catch (e) {
      emit(ForgetPasswordFailure("Failed to reset password: ${e.message}"));
    } catch (e) {
      emit(ForgetPasswordFailure("Error: ${e.toString()}"));
    }
  }

  void _onToggleNewPassword(
    ToggleNewPasswordVisibility event,
    Emitter<ForgetPasswordState> emit,
  ) {
    if (state is ForgetPasswordOtpVerified) {
      final current = state as ForgetPasswordOtpVerified;
      emit(current.copyWith(obscureNewPassword: !current.obscureNewPassword));
    }
  }

  void _onToggleConfirmPassword(
    ToggleConfirmPasswordVisibility event,
    Emitter<ForgetPasswordState> emit,
  ) {
    if (state is ForgetPasswordOtpVerified) {
      final current = state as ForgetPasswordOtpVerified;
      emit(
        current.copyWith(
          obscureConfirmPassword: !current.obscureConfirmPassword,
        ),
      );
    }
  }
}
