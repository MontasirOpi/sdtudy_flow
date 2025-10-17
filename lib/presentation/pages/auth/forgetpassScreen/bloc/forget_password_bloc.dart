import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final SupabaseClient supabase;

  ResetPasswordBloc(this.supabase) : super(ResetPasswordInitial()) {
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<ToggleNewPasswordVisibility>(_onToggleNewPasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: event.newPassword),
      );
      emit(ResetPasswordSuccess('Password updated successfully!'));
    } catch (e) {
      emit(ResetPasswordFailure('Error: ${e.toString()}'));
    }
  }

  void _onToggleNewPasswordVisibility(
    ToggleNewPasswordVisibility event,
    Emitter<ResetPasswordState> emit,
  ) {
    if (state is ResetPasswordInitial) {
      final current = state as ResetPasswordInitial;
      emit(current.copyWith(obscureNewPassword: !current.obscureNewPassword));
    }
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibility event,
    Emitter<ResetPasswordState> emit,
  ) {
    if (state is ResetPasswordInitial) {
      final current = state as ResetPasswordInitial;
      emit(
        current.copyWith(
          obscureConfirmPassword: !current.obscureConfirmPassword,
        ),
      );
    }
  }
}
