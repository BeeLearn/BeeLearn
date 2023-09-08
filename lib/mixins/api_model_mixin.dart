import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

/// BeeLearn API abstract implementation for high level abstraction
mixin ApiModel {
  /// API Headers abstract getter
  Map<String, String>? get headers;

  /// Base API Url
  String get baseUrl;

  /// Base pathname
  String? get basePath;

  /// api url
  String get apiUrl => "$baseUrl/$basePath/";

  /// detailed path builder
  String getDetailedPath(int id) => "$apiUrl/$id/";

  /// List
  Future<T> list<T>({
    String? url,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await get(
      Uri.parse(url ?? apiUrl).replace(queryParameters: query),
      headers: headers,
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return fromJson(jsonDecode(response.body));
      default:
        return Future.error(response);
    }
  }

  /// Retrieve
  Future<T> retrieve<T>({
    required int id,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await get(
      Uri.parse(getDetailedPath(id)).replace(queryParameters: query),
      headers: headers,
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return fromJson(jsonDecode(response.body));
      default:
        return Future.error(response);
    }
  }

  /// Retrieve
  Future<T> create<T>({
    Map<String, dynamic>? query,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    headers?.putIfAbsent(
      HttpHeaders.contentTypeHeader,
      () => ContentType.json.mimeType,
    );

    final response = await post(
      Uri.parse(apiUrl).replace(queryParameters: query),
      headers: headers,
      body: jsonEncode(body),
    );

    switch (response.statusCode) {
      case HttpStatus.created:
        return fromJson(jsonDecode(response.body));
      default:
        return Future.error(response);
    }
  }

  /// Update
  Future<T> update<T>({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    headers?.putIfAbsent(
      HttpHeaders.contentTypeHeader,
      () => ContentType.json.mimeType,
    );

    final response = await patch(
      Uri.parse(getDetailedPath(id)).replace(queryParameters: query),
      body: jsonEncode(body),
      headers: headers,
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return fromJson(jsonDecode(response.body));
      default:
        return Future.error(response);
    }
  }

  /// Retrieve
  Future<T> remove<T>({
    required int id,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await delete(
      Uri.parse(getDetailedPath(id)).replace(queryParameters: query),
      headers: headers,
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return fromJson(jsonDecode(response.body));
      default:
        return Future.error(response);
    }
  }
}
