import 'dart:convert';
import 'dart:io';

import '../model/request.dart';

(String, List<int>) echoResponse(Request request, Socket clientSocket) {
  // response body
  String responseBody =
      request.requestLine.requestTarget.split("/echo/")[1].trim();
  print("responseBody: ${responseBody}");

  String response = "";

  List<String> acceptEncoding =
      request.headers['Accept-Encoding']?.replaceAll(' ', '').split(',') ?? [];

  List<int> body;

  if (acceptEncoding.contains('gzip')) {
    List<int> stringBytes = utf8.encode(responseBody);
    List<int> bodyEncoded = GZipCodec().encode(stringBytes);
    int bodyEncodedLength = bodyEncoded.length;

    // Prepare the HTTP response
    response = 'HTTP/1.1 200 OK\r\n' +
        'Content-Type: text/plain\r\n' +
        'Content-Encoding: gzip\r\n' +
        'Content-Length: $bodyEncodedLength\r\n' +
        '\r\n';

    body = bodyEncoded;
  } else {
    // Prepare the HTTP response
    response = 'HTTP/1.1 200 OK\r\n' +
        'Content-Type: text/plain\r\n' +
        'Content-Length: ${responseBody.length}\r\n' +
        '\r\n';
    body = utf8.encode(responseBody);
  }
  return (response, body);
}
