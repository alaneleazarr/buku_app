import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:buku/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  // POST request
  Future<dynamic> post(String url, dynamic data, {Map<String, String>? headers}) async {
    var token = await UserInfo().getToken();
    final requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      ...?headers,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: requestHeaders,
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // GET request
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    var token = await UserInfo().getToken();
    final requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      ...?headers,
    };
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: requestHeaders,
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // PUT request
  Future<dynamic> put(String url, dynamic data, {Map<String, String>? headers}) async {
    var token = await UserInfo().getToken();
    final requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      ...?headers,
    };
    try {
      final response = await http.put(
        Uri.parse(url),
        body: data,
        headers: requestHeaders,
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // DELETE request
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    var token = await UserInfo().getToken();
    final requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      ...?headers,
    };
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: requestHeaders,
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Handle response
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server. StatusCode: ${response.statusCode}');
    }
  }
}
