import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;

  ResetPasswordInitial({
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
  });

  ResetPasswordInitial copyWith({
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
  }) {
    return ResetPasswordInitial(
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [obscureNewPassword, obscureConfirmPassword];
}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;
  ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
