import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../main_application.dart';

/// BeeLearn API abstract implementation for high level abstraction
mixin ApiModelMixin {
  /// API Headers abstract getter
  Map<String, String>? get headers => {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        HttpHeaders.authorizationHeader: "Token ${MainApplication.accessToken ?? MainApplication.firebaseIdToken}",
      };

  /// Base API Url
  String get baseUrl => MainApplication.baseURL;

  /// Base pathname
  String? get basePath;

  /// api url
  String get apiUrl => "$baseUrl/$basePath/";

  /// detailed path builder
  String getDetailedPath(dynamic path) => "$apiUrl$path/";

  /// List
  Future<T> list<T, TJson>({
    String? url,
    Map<String, dynamic>? query,
    required T Function(TJson) fromJson,
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
    required T Function(Map<String, dynamic> json) fromJson,
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
    String? url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final response = await post(
      Uri.parse(url ?? apiUrl).replace(queryParameters: query),
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
    required dynamic path,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final response = await patch(
      Uri.parse(getDetailedPath(path)).replace(queryParameters: query),
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
  Future<T?> remove<T>({
    required dynamic path,
    Map<String, dynamic>? query,
    T Function(Map<String, dynamic> json)? fromJson,
  }) async {
    final response = await delete(
      Uri.parse(getDetailedPath(path)).replace(queryParameters: query),
      headers: headers,
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        if (fromJson != null) return fromJson(jsonDecode(response.body));
      default:
        return Future.error(response);
    }

    return null;
  }

  Future<T> multipartRequest<T>({
    Map<String, String>? fields,
    List<MultipartFile>? multipartFiles,
    required int id,
    required String method,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final request = MultipartRequest(method, Uri.parse(getDetailedPath(id)));

    if (headers != null) request.headers.addAll(headers!);
    if (fields != null) request.fields.addAll(fields);
    if (multipartFiles != null) request.files.addAll(multipartFiles);

    final response = await request.send();

    switch (response.statusCode) {
      case HttpStatus.ok:
        final completer = Completer<T>();
        response.stream.transform(utf8.decoder).listen(
          (response) {
            completer.complete(fromJson(jsonDecode(response)));
          },
        );

        return completer.future;
      default:
        return Future.error(response);
    }
  }
}
