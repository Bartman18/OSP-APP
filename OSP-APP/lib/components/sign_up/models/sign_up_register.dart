import 'package:uuid/uuid.dart';

class SignUpRegisterModel {
  String? name;
  String email;
  String password;
  String passwordConfirmation;

  SignUpRegisterModel({
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
  }) : name = const Uuid().v4();

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };
  }
}
