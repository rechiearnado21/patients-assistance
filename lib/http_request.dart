// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_keys.dart';

class HttpRequest {
  final Map<String, dynamic>? parameters;

  const HttpRequest({this.parameters});

  Future<dynamic> get() async {
    final response = await http.get(
      Uri.parse(
          Uri.decodeFull(Uri.https(ApiKey.apiKey, ApiKey.subApi).toString())),
    );
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> post() async {
    final response = await http.post(
        Uri.parse(
            Uri.decodeFull(Uri.https(ApiKey.apiKey, ApiKey.subApi).toString())),
        headers: {"Content-Type": "application/json"},
        body: json.encode(parameters)); 
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> put() async {
    final response = await http.put(
        Uri.parse(
            Uri.decodeFull(Uri.https(ApiKey.apiKey, ApiKey.subApi).toString())),
        headers: {"Content-Type": "application/json"},
        body: json.encode(parameters));
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
