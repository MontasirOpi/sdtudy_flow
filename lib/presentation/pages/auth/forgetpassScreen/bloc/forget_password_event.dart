import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendResetEmailEvent extends ForgetPasswordEvent {
  final String email;
  SendResetEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}
