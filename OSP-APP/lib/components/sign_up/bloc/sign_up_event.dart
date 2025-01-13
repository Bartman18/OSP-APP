import 'package:equatable/equatable.dart';
import 'package:osp/components/sign_up/bloc/sign_up_state.dart';

sealed class SignInOrUpEvent extends Equatable {
  const SignInOrUpEvent();

  @override
  List<Object?> get props => [];
}

sealed class _VerificationEmailCode extends SignInOrUpEvent {
  final String emailCode;

  const _VerificationEmailCode(this.emailCode);

  @override
  List<Object?> get props => [emailCode];
}

final class SignUpVerifyVerificationCode extends _VerificationEmailCode {
  const SignUpVerifyVerificationCode(super.emailCode);

  @override
  List<Object?> get props => [emailCode];
}

final class ResetPasswordEmailCode extends _VerificationEmailCode {
  const ResetPasswordEmailCode(super.emailCode);

  @override
  List<Object?> get props => [emailCode];
}

final class SignUpResendVerificationCode extends SignInOrUpEvent {}

final class SignUpRegisterWithoutAuth extends SignInOrUpEvent {
  final String email;
  final String password;
  const SignUpRegisterWithoutAuth(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class SetContext extends SignInOrUpEvent {
  final SignInOrUpContext context;

  const SetContext({required this.context});

  @override
  List<Object?> get props => [context];
}

class SaveEmailAndPassword extends SignInOrUpEvent {
  final String email;
  final String password;
  const SaveEmailAndPassword(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class SignInWithCredentials extends SignInOrUpEvent {
  final String email;
  final String password;
  const SignInWithCredentials(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}


final class SendResetedPassword extends SignInOrUpEvent {
  final String password;
  const SendResetedPassword(this.password);

  @override
  List<Object?> get props => [password];
}

final class ResetPasswordEmailEvent extends SignInOrUpEvent {
  final String email;
  const ResetPasswordEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

final class SignInByIntegration extends SignInOrUpEvent {
  final bool isLoginEvent;
  final bool isRegisterEvent;
  const SignInByIntegration(this.isLoginEvent, this.isRegisterEvent);

  @override
  List<Object?> get props => [isLoginEvent, isRegisterEvent];
}
