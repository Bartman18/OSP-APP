import 'package:fox_core/api/api_request.dart';
import 'package:fox_core/api/api_response.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Bets extends ApiRequest {
  String get url => '$v1/bets';

  Future<ApiResponse> getCurrentInfo() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/info');
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> getCurrentBets() async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse(url);
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> setCurrentBets({required int bet}) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/$bet');
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> getMatchStats({required int match}) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/$match/stats');
    return handleResponse(await get(uri, headers: headers));
  }

  Future<ApiResponse> getTeamStats({required int team}) async {
    Map<String, String> headers = await super.getHeaders();
    Uri uri = Uri.parse('$url/stats/$team');
    return handleResponse(await get(uri, headers: headers));
  }
}
