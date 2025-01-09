import 'package:fox_core/api/api_request.dart';
import 'package:fox_core/api/api_response.dart';
import 'package:http/http.dart';

class SettingsApi extends ApiRequest {
  String get url => '$v1/settings';

  Future<ApiResponse> public() async {
    Map<String, String> headers = await super.getNonAuthHeaders();
    Uri uri = Uri.parse('$url/public');

    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> private() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/private');

    return handleResponse(await get(uri, headers: headers));
  }

}