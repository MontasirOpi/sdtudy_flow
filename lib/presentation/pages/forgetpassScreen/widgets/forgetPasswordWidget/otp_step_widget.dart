import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../bloc/forget_password_bloc.dart';
import '../../bloc/forget_password_event.dart';

class OtpStepWidget extends StatefulWidget {
  final String email;
  final bool isLoading;

  const OtpStepWidget({
    super.key,
    required this.email,
    required this.isLoading,
  });

  @override
  State<OtpStepWidget> createState() => _OtpStepWidgetState();
}

class _OtpStepWidgetState extends State<OtpStepWidget> {
  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;
  String currentOtp = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resendOtp() {
    context.read<ForgetPasswordBloc>().add(SendOtpEvent(widget.email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent to your email'),
        backgroundColor: Colors.green,
      ),
    );
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_user,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Enter Verification Code',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a 6-digit code to\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white70,
                      selectedFillColor: Colors.blue[50]!,
                      activeColor: Colors.blueAccent,
                      selectedColor: Colors.blueAccent,
                      inactiveColor: Colors.grey,
                    ),
                    cursorColor: Colors.blueAccent,
                    animationType: AnimationType.fade,
                    enableActiveFill: true,
                    onChanged: (value) {
                      setState(() {
                        currentOtp = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              if (currentOtp.length != 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter the 6-digit code',
                                    ),
                                  ),
                                );
                                return;
                              }
                              context.read<ForgetPasswordBloc>().add(
                                VerifyOtpEvent(widget.email, currentOtp),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: widget.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Verify Code',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _canResend ? _resendOtp : null,
                    child: Text(
                      _canResend
                          ? 'Resend Code'
                          : 'Resend in $_secondsRemaining s',
                      style: TextStyle(
                        color: _canResend ? Colors.white : Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
