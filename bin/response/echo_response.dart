import '../model/request.dart';

String echoResponse(Request request) {
  // response body
  String responseBody = request.requestLine.requestTarget.split("/echo/")[1];

  // Prepare the HTTP response
  String response = 'HTTP/1.1 200 OK\r\n' +
      'Content-Type: text/plain\r\n' +
      'Content-Length: ${responseBody.length}\r\n' +
      '\r\n' +
      '$responseBody';
  return response;
}
