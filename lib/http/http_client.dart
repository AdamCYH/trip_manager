import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile/models/exceptions.dart';

typedef RequestCallBack = void Function(Map data);

class MyHttpClient {
  Utf8Decoder decode = new Utf8Decoder();

  static requestGET(
      String authority, String unEncodedPath, RequestCallBack callBack,
      [Map<String, String> queryParameters]) async {
    try {
      var httpClient = new HttpClient();
      var uri = new Uri.http(authority, unEncodedPath, queryParameters);
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(Convert.utf8.decoder).join();
      Map data = Convert.jsonDecode(responseBody);
      callBack(data);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  final baseUrl;

  MyHttpClient(this.baseUrl);

  Future<dynamic> get(String uri, {Map<String, String> headers}) async {
    try {
      http.Response response = await http.get(baseUrl + uri, headers: headers);
      final statusCode = response.statusCode;
      if (response.statusCode != 200) {
        return handleExceptions(response);
      }
      final body = response.body;
      print('[uri=$uri][statusCode=$statusCode][response=$body]');
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return '';
    }
  }

  Future<dynamic> post(String uri, dynamic body,
      {Map<String, String> headers}) async {
    try {
      http.Response response =
          await http.post(baseUrl + uri, body: body, headers: headers);
      final statusCode = response.statusCode;
      if (response.statusCode != 200 && response.statusCode != 201) {
        return handleExceptions(response);
      }
      final responseBody = response.body;
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return '';
    }
  }

  Future<dynamic> multipartPost(String uri, dynamic body, List<String> files,
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
        return handleExceptions(response);
      }
      final responseBody = response.body;
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return '';
    }
  }

  Future<dynamic> multipartPut(String uri, dynamic body, List<String> files,
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
        return handleExceptions(response);
      }
      final responseBody = response.body;
      var result = Convert.jsonDecode(decode.convert(response.bodyBytes));
      print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return result;
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return '';
    }
  }

  Future<dynamic> delete(String uri, {Map<String, String> headers}) async {
    try {
      http.Response response =
          await http.delete(baseUrl + uri, headers: headers);
      if (response.statusCode != 204) {
        return handleExceptions(response);
      }
    } on SocketException catch (e) {
      print('[uri=$uri] exception e=${e.toString()}');
      return '';
    }
  }

  void handleExceptions(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        print(response.body);
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
