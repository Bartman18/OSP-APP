import 'dart:convert';

import 'package:osp/api/api_request.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/components/user_profile/models/user_profile.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class User extends ApiRequest {
  String get url => '$v1/user';

  Future<ApiResponse> verifyIntegration(String integration,
      {String? email, String? phoneNumber, Map<String, dynamic>? details}) async {
    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$url/verifyIntegration/$integration');

    Map<String, String> body = {};

    if (null != phoneNumber && phoneNumber.isNotEmpty) {
      body.putIfAbsent('phone_number', () => phoneNumber);
    }

    if (null != details && details.isNotEmpty) {
      body.putIfAbsent('details', () => jsonEncode(details));
    }

    if (body.isEmpty) {
      return ApiResponse.failure(content: {}, errorCode: 1011);
    }

    Request request = Request('GET', uri);
    request.body = jsonEncode(body);
    request.headers.addAll(headers);

    return handleStreamedResponse(await request.send());
  }

  Future<ApiResponse> integrate(String integration, Map<String, dynamic> body) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse('$url/integration/$integration');

    return handleResponse(await post(uri, headers: headers, body: jsonEncode({'details': body})));
  }

  Future<ApiResponse> logout() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$v1/logout');

    return handleResponse(await post(uri, headers: headers));
  }

  Future<ApiResponse> login(UserProfileModel model, {required String password}) async {
    if ('' == model.email) {
      return ApiResponse.failure(content: 'email_or_phone_is_required');
    }

    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$v1/login');

    Map<String, dynamic> body = {
      'password': password,
      "password_confirmation": password,
    };

    if ('' != model.email) {
      body.putIfAbsent('login', () => model.email);
      body.putIfAbsent('email', () => model.email);
    }

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> createAccount(UserProfileModel model,
      {required String password, bool requireMail = true}) async {
    if (requireMail && '' == model.email) {
      return ApiResponse.failure(content: 'email_is_required');
    }

    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$v1/register');

    Map<String, dynamic> body = {
      'name': '' == model.name ? const Uuid().v4() : model.name,
      'password': password,
      "password_confirmation": password,
    };

    if ('' != model.email) {
      body.putIfAbsent('email', () => model.email);
    }

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> updatePrivacy(bool newStatus) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse('$url/profile');

    Map<String, dynamic> body = {
      'incognito': newStatus,
    };

    return handleResponse(await patch(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> updateNotifications(bool newStatus) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse('$url/profile');

    Map<String, dynamic> body = {
      'notifications': newStatus,
    };

    return handleResponse(await patch(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> updateProfile(UserProfileModel model) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse('$url/profile');

    Map<String, dynamic> body = {
      'name': model.name,
    };

    return handleResponse(await patch(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> updateProfilePicture(String path) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/profilePicture');

    MultipartRequest request = MultipartRequest('POST', uri);

    request.headers.addAll(headers);
    request.files.add(await MultipartFile.fromPath('photo', path));

    return handleStreamedResponse(await request.send());
  }

  Future<ApiResponse> logInByIntegration(String integration, Map<String, dynamic> body) async {
    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$url/loginBy/$integration');

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> exists(String email) async {
    Map<String, String> headers = await super.getNonAuthHeaders();
    Uri uri = Uri.parse('$url/exists/email/$email');

    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> load() async {
    return handleResponse(await get(Uri.parse(url), headers: await super.getHeaders()));
  }

  Future<ApiResponse> support(String message) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse('$v1/support');

    Map<String, dynamic> body = {
      'content': message,
    };

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }

  Future<ApiResponse> getResetPasswordToken(String email) async {
    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$url/resetPassword/$email');

    ApiResponse response = handleResponse(await get(uri, headers: headers));

    return response;
  }

  Future<ApiResponse> resetPassword(String token, String code, String password) async {
    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$url/resetPassword');

    Map<String, dynamic> body = {
      'token': token,
      'code': code,
      'password': password,
      "password_confirmation": password,
    };

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }
}
