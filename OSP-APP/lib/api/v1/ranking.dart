import 'package:osp/api/api_request.dart';
import 'package:osp/api/api_response.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Ranking extends ApiRequest {
  String get url => '$v1/rankings';

  Future<ApiResponse> getGeneralLeague() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/general');
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> getPrivateLeague() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/private');
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> getTopLeague() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/top');
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> setTopLeague({required int bet}) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/top');
    return handleResponse(await get(uri, headers: headers));
  }
}
