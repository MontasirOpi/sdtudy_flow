// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sdtudy_flow/presentation/pages/auth/forgetpassScreen/bloc/forget_password_bloc.dart';
// import 'package:sdtudy_flow/presentation/pages/auth/forgetpassScreen/bloc/forget_password_event.dart';
// import 'package:sdtudy_flow/presentation/pages/auth/forgetpassScreen/bloc/forget_password_state.dart';

// class VerifyCodeScreen extends StatelessWidget {
//   final String email;
//   VerifyCodeScreen({super.key, required this.email});

//   final codeController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify Code')),
//       body: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
//         listener: (context, state) {
//           if (state is PasswordResetSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message), backgroundColor: Colors.green),
//             );
//             Navigator.popUntil(context, (route) => route.isFirst);
//           } else if (state is ForgetPasswordFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error), backgroundColor: Colors.redAccent),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Verification code sent to $email', textAlign: TextAlign.center),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: codeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Code',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: 'New Password',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 state is ForgetPasswordLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: () {
//                           context.read<ForgetPasswordBloc>().add(
//                                 VerifyCodeAndResetPasswordEvent(
//                                   email: email,
//                                   code: codeController.text.trim(),
//                                   newPassword: passwordController.text.trim(),
//                                 ),
//                               );
//                         },
//                         child: const Text('Reset Password'),
//                       ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
