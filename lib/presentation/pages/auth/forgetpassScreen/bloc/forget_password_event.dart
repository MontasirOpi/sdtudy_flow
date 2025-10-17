import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Update password
class UpdatePasswordEvent extends ResetPasswordEvent {
  final String newPassword;
  UpdatePasswordEvent(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

// Toggle visibility for fields
class ToggleNewPasswordVisibility extends ResetPasswordEvent {}

class ToggleConfirmPasswordVisibility extends ResetPasswordEvent {}
