import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final SupabaseClient supabase;

  ForgetPasswordBloc(this.supabase) : super(ForgetPasswordInitial()) {
    on<SendResetEmailEvent>(_onSendResetEmail);
  }

  Future<void> _onSendResetEmail(
    SendResetEmailEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(ForgetPasswordLoading());
    try {
      // ✅ Send reset email
      await supabase.auth.resetPasswordForEmail(
        event.email,
        redirectTo:
            'io.supabase.flutter://reset-password-callback', // deep link
      );
      emit(
        ForgetPasswordSuccess("Password reset email sent! Check your inbox."),
      );
    } catch (e) {
      emit(ForgetPasswordFailure("Error: ${e.toString()}"));
    }
  }
}
