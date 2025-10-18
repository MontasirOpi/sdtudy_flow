import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sdtudy_flow/presentation/pages/forgetpassScreen/bloc/forget_password_bloc.dart';
import 'package:sdtudy_flow/presentation/pages/forgetpassScreen/bloc/forget_password_state.dart';
import 'package:sdtudy_flow/presentation/pages/forgetpassScreen/widgets/forgetPasswordWidget/email_step_widget.dart';
import 'package:sdtudy_flow/presentation/pages/forgetpassScreen/widgets/forgetPasswordWidget/otp_step_widget.dart';
import 'package:sdtudy_flow/presentation/pages/forgetpassScreen/widgets/forgetPasswordWidget/password_reset_step_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordBloc(Supabase.instance.client),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
            listener: (context, state) {
              if (state is ForgetPasswordOtpSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Verification code sent to ${state.email}'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ForgetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) context.go('/login');
                });
              } else if (state is ForgetPasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is ForgetPasswordInitial ||
                  (state is ForgetPasswordLoading &&
                      state is! ForgetPasswordOtpSent)) {
                return EmailStepWidget(
                  isLoading: state is ForgetPasswordLoading,
                );
              } else if (state is ForgetPasswordOtpSent ||
                  (state is ForgetPasswordLoading &&
                      state is ForgetPasswordOtpSent)) {
                final email = state is ForgetPasswordOtpSent ? state.email : '';
                return OtpStepWidget(
                  email: email,
                  isLoading: state is ForgetPasswordLoading,
                );
              } else if (state is ForgetPasswordOtpVerified) {
                return PasswordResetStepWidget(state: state);
              } else if (state is ForgetPasswordFailure) {
                return OtpStepWidget(email: '', isLoading: false);
              }
              return EmailStepWidget(isLoading: false);
            },
          ),
        ),
      ),
    );
  }
}
