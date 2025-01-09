import 'package:fox_core/api/api_request.dart';
import 'package:fox_core/api/api_response.dart';
import 'package:http/http.dart';

class SignInWithAppleApi extends ApiRequest {
  String get url => '$web/sign-in-with-apple';

  Future<ApiResponse> resolveAccessToken(String code) async {
    Map<String, String> headers = await super.getNonAuthHeaders(json: true);
    Uri uri = Uri.parse('$url/access/$code');

    return handleResponse(await get(uri, headers: headers));
  }

}