import 'package:equatable/equatable.dart';

abstract class ForgetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

// Email sent successfully, waiting for OTP
class ForgetPasswordOtpSent extends ForgetPasswordState {
  final String email;
  ForgetPasswordOtpSent(this.email);

  @override
  List<Object?> get props => [email];
}

// OTP verified, show password reset form
class ForgetPasswordOtpVerified extends ForgetPasswordState {
  final String email;
  final String token;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;

  ForgetPasswordOtpVerified(
    this.email,
    this.token, {
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
  });

  ForgetPasswordOtpVerified copyWith({
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
  }) {
    return ForgetPasswordOtpVerified(
      email,
      token,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    email,
    token,
    obscureNewPassword,
    obscureConfirmPassword,
  ];
}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;
  ForgetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;
  ForgetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
