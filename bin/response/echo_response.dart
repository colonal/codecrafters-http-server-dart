import 'dart:convert';
import 'dart:io';

import '../model/request.dart';

String echoResponse(Request request) {
  // response body
  String responseBody = request.requestLine.requestTarget.split("/echo/")[1];
  String response = "";

  List<String> acceptEncoding =
      request.headers['Accept-Encoding']?.replaceAll(' ', '').split(',') ?? [];
  print("acceptEncoding: $acceptEncoding");
  if (acceptEncoding.contains('gzip')) {
    List<int> stringBytes = utf8.encode(responseBody);
    List<int> stringGZip = GZipCodec().encode(stringBytes);

    String body = compressString(responseBody);
    print("body: ${body}");

    // Prepare the HTTP response
    response = 'HTTP/1.1 200 OK\r\n' +
        'Content-Type: text/plain\r\n' +
        'Content-Encoding: gzip\r\n' +
        'Content-Length: ${body.length}\r\n' +
        '\r\n' +
        String.fromCharCodes(stringGZip);
  } else {
    // Prepare the HTTP response
    response = 'HTTP/1.1 200 OK\r\n' +
        'Content-Type: text/plain\r\n' +
        'Content-Length: ${responseBody.length}\r\n' +
        '\r\n' +
        '$responseBody';
  }

  return response;
}

String compressString(String content) {
  final gzip = GZipCodec();

  List<int> contentBytes = utf8.encode(content);

  List<int> compressedBytes = gzip.encode(contentBytes);

  String compressedString = String.fromCharCodes(compressedBytes);

  return compressedString;
}
