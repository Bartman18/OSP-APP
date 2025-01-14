import 'package:uuid/uuid.dart';

class SignUpRegisterModel {
  String name;
  String lastName;
  String email;
  String phone;
  String password;

  SignUpRegisterModel({
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
  });

  Map<String, dynamic> toJSON() {
    return {
      'first_name': name,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
