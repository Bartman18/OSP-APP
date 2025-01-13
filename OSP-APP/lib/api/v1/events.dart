import 'dart:convert';

import 'package:osp/api/api_request.dart';
import 'package:osp/api/api_response.dart';
import 'package:osp/components/add_event/model/add_event_model.dart';
import 'package:osp/shared/models/products_api_models.dart';
import 'package:http/http.dart';

class EventsAPI extends ApiRequest {
  String get url => '$v1/events';

  Future<ApiResponse> addNewEvent(AddEventModel addEventModel) async {
    Map<String, String> headers = await super.getHeaders(json: true);
    Uri uri = Uri.parse(url);

    Map<String, dynamic> body = addEventModel.toJson();

    return handleResponse(await post(uri, headers: headers, body: jsonEncode(body)));
  }


  Future<ApiResponse> getEventCount() async {
    Map<String, String> headers = await super.getHeaders();

    Uri uri = Uri.parse('$url/count');

    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> getAllEvents() async {
    Map<String, String> headers = await super.getHeaders();

    Uri uri = Uri.parse(url);

    return handleResponse(await get(uri, headers: headers));
  }
}
