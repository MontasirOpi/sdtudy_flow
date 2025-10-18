import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Step 1: Send OTP to email
class SendOtpEvent extends ForgetPasswordEvent {
  final String email;
  SendOtpEvent(this.email);

  @override
  List<Object?> get props => [email];
}

// Step 2: Verify OTP
class VerifyOtpEvent extends ForgetPasswordEvent {
  final String email;
  final String otp;
  VerifyOtpEvent(this.email, this.otp);

  @override
  List<Object?> get props => [email, otp];
}

// Step 3: Reset password
class ResetPasswordWithOtpEvent extends ForgetPasswordEvent {
  final String newPassword;

  ResetPasswordWithOtpEvent(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

// Toggle password visibility
class ToggleNewPasswordVisibility extends ForgetPasswordEvent {}

class ToggleConfirmPasswordVisibility extends ForgetPasswordEvent {}
