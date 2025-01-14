import 'dart:convert';
import 'dart:developer';

import 'package:osp/api/api_request.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/components/user_profile/models/user_profile.dart';
import 'package:osp/components/sign_up/models/sign_up_register.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class User extends ApiRequest {
  String get url => '$v1/user';

  Future<ApiResponse> getUser(int userId) async
  {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/$userId');

    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> register({required SignUpRegisterModel userData}) async
  {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/register');

    Map<String, dynamic> body = userData.toJSON();
    
    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> login({required SignUpRegisterModel userData}) async
  {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/login');

    Map<String, dynamic> body = {
      'email': userData.email ,
      'password': userData.password ,
    };

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> logout() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/logout');

    return handleResponse(await post(uri, headers: headers));
  }

  Future<ApiResponse> protected() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/protected');

    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> confirmed() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/confirmed');

    return handleResponse(await get(uri, headers: headers));
  }
}
