// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:transform_your_mind/core/utils/toast_message.dart';

class HttpService {
  static Future<http.Response?> getApi({
    required String url,
    Map<String, String>? header,
  }) async {
    try {
      if (kDebugMode) {
        print("Url => $url");
        print("Header => $header");
      }
      return http.get(
        Uri.parse(url),
        headers: header,
      );
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> postApi({
    required String url,
    dynamic body,
    Map<String, String>? header,
    bool? isEncodeAndPass,
  }) async {
    try {
      if (kDebugMode) {
        print("Url => $url");
        print("Header => $header");
        print("Body => $body");
      }
      if (isEncodeAndPass == true) {
        return http.post(
          Uri.parse(url),
          headers: header,
          body: jsonEncode(body),
        );
      } else {
        return http.post(
          Uri.parse(url),
          headers: header,
          body: body,
        );
      }
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> postApiForSocialMedia({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? header,
    bool? isEncodeAndPass,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      if (kDebugMode) {
        print("Url => $url");
        print("Header => $header");
        print("Body => $body");
      }

      return http.post(
        Uri.parse(url),
        headers: header ?? headers,
        body: json.encode(body),
      );
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> deleteApi({
    required String url,
    Map<String, String>? header,
    dynamic body,
  }) async {
    try {
      if (kDebugMode) {
        print("Url => $url");
        print("Header => $header");
        print("Body => $body");
      }
      return http.delete(
        Uri.parse(url),
        headers: header,
        body: body,
      );
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> putApi({
    required String url,
    dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      if (kDebugMode) {
        print("Url => $url");
        print("Header => $header");
        print("Body => $body");
      }
      if (body == null) {
        return http.put(Uri.parse(url));
      } else {
        return http.put(
          Uri.parse(url),
          headers: header,
          body: body,
        );
      }
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> patchApi({
    required String url,
    dynamic body,
    Map<String, String>? header,
  }) async {
    try {
      if (kDebugMode) {
        print("Url => $url");
        print("Header => $header");
        print("Body => $body");
      }
      var headers = {'Content-Type': 'application/json'};
      return http.patch(
        Uri.parse(url),
        headers: header ?? headers,
        body: json.encode(body),
      );
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> postMultipart({
    required String url,
    required Map<String, String> headers,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);
      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      errorToast(e.toString());
      return null;
    }
  }

  static Future<http.Response?> multipartRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    required Map<String, String> body,
    required List<String> filePaths,
  }) async {
    try {
      final request = http.MultipartRequest(method, Uri.parse(url));

      // Add headers if provided
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add fields
      request.fields.addAll(body);

      // Add files
      for (int i = 0; i < filePaths.length; i++) {
        String element = filePaths[i];
        String mediaType = "";
        String extension = element.split(".").last.toLowerCase();
        if (extension == "mp4") {
          mediaType = "video";
        } else if (extension == "mov") {
          mediaType = "video";
        } else if (extension == "png" ||
            extension == "jpg" ||
            extension == "jpeg") {
          mediaType = "image";
        }

        request.files.add(await http.MultipartFile.fromPath(
          'add_pic_or_video',
          element,
          contentType: MediaType(mediaType, extension),
        ));

        print("Uploaded file: $element");
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      print("Error uploading files: $e");
      return null;
    }
  }
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}