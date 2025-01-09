import 'dart:convert';

import 'package:fox_core/api/api_request.dart';
import 'package:fox_core/api/api_response.dart';
import 'package:http/http.dart';

class Subscription extends ApiRequest {
  String get url => '$v1/subscription';

  Future<ApiResponse> apply(int type) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse('$url/');

    Map<String, dynamic> body = {
      'type': type.toString(),
    };

    return handleResponse(await patch(
      uri,
      headers: headers,
      body: jsonEncode(body)
    ));
  }

}
