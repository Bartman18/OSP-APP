import 'package:osp/api/api_request.dart';
import 'package:http/http.dart';

class AppSignUp extends ApiRequest {
  String get url => '$v1/sms/code';

  Future<dynamic> sendPhoneNumber(String phoneNumber) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/$phoneNumber');
    return handleResponse(await post(uri, headers: headers));
  }

  Future<dynamic> verifyVerificationCode(String userId, String pinCode) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/verify/$userId/$pinCode');
    return handleResponse(await get(uri, headers: headers));
  }
}
