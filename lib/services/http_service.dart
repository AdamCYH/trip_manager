import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/models/exceptions.dart';

typedef RequestCallBack = void Function(Map data);

class HttpService {
  Utf8Decoder decode = new Utf8Decoder();

  final String baseUrl;
  final http.Client _httpClient;

  HttpService(this.baseUrl, this._httpClient);

  Future<Map<String, dynamic>> get(String uri,
      {Map<String, String> headers}) async {
    try {
      http.Response response =
          await _httpClient.get(baseUrl + uri, headers: headers);
      final statusCode = response.statusCode;
      if (response.statusCode != 200) {
        handleHttpError(response);
      }
      final body = response.body;
      print('[uri=$uri][statusCode=$statusCode][response=$body]');
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return {'Status': 'Error'};
    }
  }

  Future<Map<String, dynamic>> post(String uri, dynamic body,
      {Map<String, String> headers}) async {
    try {
      http.Response response =
          await _httpClient.post(baseUrl + uri, body: body, headers: headers);
      final statusCode = response.statusCode;
      if (response.statusCode != 200 && response.statusCode != 201) {
        handleHttpError(response);
      }
      final responseBody = response.body;
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return {'Status': 'Error'};
    }
  }

  Future<Map<String, dynamic>> multipartPost(
      String uri, dynamic body, List<String> files,
      {Map<String, String> headers}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + uri));
      request.headers.addAll(headers);
      request.fields.addAll(body);
      files.forEach((fileName) async {
        request.files.add(await http.MultipartFile.fromPath('image', fileName));
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final statusCode = response.statusCode;

      if (response.statusCode != 200 && response.statusCode != 201) {
        handleHttpError(response);
      }
      final responseBody = response.body;
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return {'Status': 'Error'};
    }
  }

  Future<Map<String, dynamic>> multipartPut(
      String uri, dynamic body, List<String> files,
      {Map<String, String> headers}) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(baseUrl + uri));
      request.headers.addAll(headers);
      request.fields.addAll(body);
      files.forEach((fileName) async {
        request.files.add(await http.MultipartFile.fromPath('image', fileName));
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final statusCode = response.statusCode;

      if (response.statusCode != 200 && response.statusCode != 201) {
        handleHttpError(response);
      }
      final responseBody = response.body;
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return {'Status': 'Error'};
    }
  }

  Future<Map<String, dynamic>> delete(String uri,
      {Map<String, String> headers}) async {
    try {
      http.Response response =
          await _httpClient.delete(baseUrl + uri, headers: headers);
      if (response.statusCode != 204) {
        handleHttpError(response);
      }
      return {'Status': 'Delete successful.'};
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return {'Status': 'Error'};
    }
  }

  void handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw NotFoundException(response.body.toString());
      case 500:
      default:
        print(response.body);
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
