import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const AuthState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  @override
  List<Object?> get props => [obscurePassword, obscureConfirmPassword];
}

class AuthInitial extends AuthState {
  const AuthInitial({super.obscurePassword, super.obscureConfirmPassword});

  AuthInitial copyWith({bool? obscurePassword, bool? obscureConfirmPassword}) {
    return AuthInitial(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}

class AuthLoading extends AuthState {
  const AuthLoading({super.obscurePassword, super.obscureConfirmPassword});
}

class AuthSuccess extends AuthState {
  const AuthSuccess({super.obscurePassword, super.obscureConfirmPassword});
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(
    this.message, {
    super.obscurePassword,
    super.obscureConfirmPassword,
  });

  @override
  List<Object?> get props => [message, obscurePassword, obscureConfirmPassword];
}
