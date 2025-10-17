import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sdtudy_flow/presentation/pages/auth/forgetpassScreen/bloc/forget_password_bloc.dart';
import 'package:sdtudy_flow/presentation/pages/auth/forgetpassScreen/bloc/forget_password_event.dart';
import 'package:sdtudy_flow/presentation/pages/auth/forgetpassScreen/bloc/forget_password_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return BlocProvider(
      create: (_) => ResetPasswordBloc(Supabase.instance.client),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                listener: (context, state) {
                  if (state is ResetPasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.go('/login');
                  } else if (state is ResetPasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  bool obscureNew = true;
                  bool obscureConfirm = true;

                  if (state is ResetPasswordInitial) {
                    obscureNew = state.obscureNewPassword;
                    obscureConfirm = state.obscureConfirmPassword;
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color:
                              Colors.transparent, // optional, background color
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/logo/applogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Reset Your Password',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please enter your new password below',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // New Password
                      TextField(
                        controller: passwordController,
                        obscureText: obscureNew,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon: Icon(
                                obscureNew
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                context.read<ResetPasswordBloc>().add(
                                  ToggleNewPasswordVisibility(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextField(
                        controller: confirmController,
                        obscureText: obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon: Icon(
                                obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                context.read<ResetPasswordBloc>().add(
                                  ToggleConfirmPasswordVisibility(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Update Button
                      state is ResetPasswordLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  final pass = passwordController.text.trim();
                                  final confirm = confirmController.text.trim();

                                  if (pass.isEmpty || confirm.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please fill all fields'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  } else if (pass != confirm) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Passwords do not match'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  } else {
                                    context.read<ResetPasswordBloc>().add(
                                      UpdatePasswordEvent(pass),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
