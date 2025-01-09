import 'package:equatable/equatable.dart';
import 'package:fox_core/core/enums/statuses.dart';

enum SignInOrUpContext { signIn, signUp }

final class SignUpState extends Equatable {
  final SignInOrUpContext context;
  final StateStatus status;
  final String verificationToken;
  final String email;
  final String password;
  final String emailCode;
  final String errorMessage;
  final bool userSetName;
  final bool canLogIn;
  final bool loggedByIntegration;
  final bool isRegisterEvent;
  final bool isLoginEvent;

  const SignUpState({
    this.context = SignInOrUpContext.signUp,
    this.status = StateStatus.initial,
    this.verificationToken = '',
    this.email = '',
    this.password = '',
    this.emailCode = '',
    this.errorMessage = '',
    this.userSetName = false,
    this.canLogIn = false,
    this.loggedByIntegration = false,
    this.isRegisterEvent = false,
    this.isLoginEvent = false,
  });

  SignUpState copyWith({
    SignInOrUpContext? context,
    StateStatus? status,
    String? verificationToken,
    String? email,
    String? password,
    String? emailCode,
    String? errorMessage,
    bool? userSetName,
    bool? canLogIn,
    bool? loggedByIntegration,
    bool? isRegisterEvent,
    bool? isLoginEvent,
  }) =>
      SignUpState(
        context: context ?? this.context,
        status: status ?? this.status,
        verificationToken: verificationToken ?? this.verificationToken,
        email: email ?? this.email,
        password: password ?? this.password,
        emailCode: emailCode ?? this.emailCode,
        errorMessage: errorMessage ?? this.errorMessage,
        userSetName: userSetName ?? this.userSetName,
        canLogIn: canLogIn ?? this.canLogIn,
        loggedByIntegration: loggedByIntegration ?? this.loggedByIntegration,
        isRegisterEvent: isRegisterEvent ?? this.isRegisterEvent,
        isLoginEvent: isLoginEvent ?? this.isLoginEvent,
      );

  @override
  List<Object?> get props => [
        context,
        status,
        verificationToken,
        errorMessage,
        userSetName,
        email,
        emailCode,
        password,
        canLogIn,
        loggedByIntegration,
        isRegisterEvent,
        isLoginEvent,
      ];
}
