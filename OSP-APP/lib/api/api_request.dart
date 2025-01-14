import 'dart:convert';
import 'dart:developer';

import 'package:osp/api/api_response.dart';
import 'package:osp/config/urls_config.dart';
import 'package:osp/core/settings_dict.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class ApiRequest {
  final String v1 = URLSConfig.api;

  static String statusKey = 'status';
  static String dataKey = 'data';
  static String errorCodeKey = 'code';

  static int successStatus = 1;
  static int failureStatus = 0;

  Future<Map<String, String>> getNonAuthHeaders({bool json = false}) async {
    Map<String, String> headers = {'Accept': 'application/json'};

    if (json) {
      headers.putIfAbsent('Content-Type', () => 'application/json');
    }

    return headers;
  }

  Future<Map<String, String>> getHeaders({bool json = false}) async {
    String token = GetStorage().read(SettingsDictionary.userToken) ?? '-1';
    Map<String, String> headers = {'Content-Type': 'application/json', // Kluczowe!
    'Accept': 'application/json',};

    if (json) {
      headers.putIfAbsent('Content-Type', () => 'application/json');
    }

    return headers;
  }

  ApiResponse handleResponse(Response response) {
    log(response.body);
    Map<String, dynamic> body = jsonDecode(response.body);
    log(body.toString());
    if (200 != response.statusCode) {
      String message = body['message'] ?? 'unknown error';
      int errorCode = body['code'] ?? 0;

      return ApiResponse.failure(content: message, statusCode: response.statusCode, errorCode: errorCode);
    }

    dynamic data = body['data'] ?? body;

    if (data is List<dynamic>) {
      List<dynamic> content = body['data'] ?? data;
      return ApiResponse.success(content: content);
    }

    if (data is String) {
      return ApiResponse.success(content: data);
    }

    Map<String, dynamic> content = body['data'] ?? body;

    return ApiResponse.success(content: content);
  }

  Future<ApiResponse> handleStreamedResponse(StreamedResponse response) async {
    Map<String, dynamic> body = jsonDecode(await response.stream.bytesToString());

    if (200 != response.statusCode) {
      String message = body['message'] ?? 'unknown error';
      int errorCode = body['code'] ?? 0;

      return ApiResponse.failure(
          content: message, statusCode: response.statusCode, errorCode: errorCode);
    }

    Map<String, dynamic> content = body['data'] ?? body;

    return ApiResponse.success(content: content);
  }
}