import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sdtudy_flow/data/remote/auth_service.dart';
import 'package:sdtudy_flow/presentation/pages/auth/bloc/auth_bloc.dart';
import 'package:sdtudy_flow/presentation/pages/auth/bloc/auth_event.dart';
import 'package:sdtudy_flow/presentation/pages/auth/bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => AuthBloc(AuthService()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful!')),
                  );
                  context.go('/home'); // ✅ GoRouter navigation
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Back 👋',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: state.obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              TogglePasswordVisibility(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.go('/reset-password'); // GoRouter path
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              context.read<AuthBloc>().add(
                                LoginRequested(email, password),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      child: const Text("Don't have an account? Sign up"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
