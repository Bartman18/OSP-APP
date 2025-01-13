import 'package:osp/api/api_request.dart';
import 'package:osp/api/api_response.dart';
import 'package:http/http.dart';

class AppSettings extends ApiRequest {
  String get url => '$v1/settings/app';

  Future<ApiResponse> version() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/version');

    return handleResponse(await get(uri, headers: headers));
  }

}