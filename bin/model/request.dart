import 'request_line.dart';

class Request {
  final RequestLine requestLine;
  final Map<String, String> headers;
  final String body;

  Request({
    required this.requestLine,
    required this.headers,
    required this.body,
  });

  factory Request.fromString(String request) {
    List<String> requestLines = request.split('\r\n');
    RequestLine requestLineObject = RequestLine.fromString(requestLines[0]);

    Map<String, String> extractHeaders(List<String> requestLines) {
      Map<String, String> headers = {};
      for (int i = 1; i < requestLines.length; i++) {
        String line = requestLines[i];
        if (line.isEmpty) break; // End of headers
        int separatorIndex = line.indexOf(':');
        if (separatorIndex != -1) {
          String headerName = line.substring(0, separatorIndex).trim();
          String headerValue = line.substring(separatorIndex + 1).trim();
          headers[headerName] = headerValue;
        }
      }
      return headers;
    }

    String extractBody(List<String> requestLines) {
      bool bodyStarted = false;
      StringBuffer bodyBuffer = StringBuffer();

      for (String line in requestLines) {
        if (bodyStarted) {
          bodyBuffer.writeln(line);
        } else if (line.isEmpty) {
          // The body starts after an empty line
          bodyStarted = true;
        }
      }

      return bodyBuffer.toString().trim();
    }

    Map<String, String> headers = extractHeaders(requestLines);
    String body = extractBody(requestLines);
    return Request(
        requestLine: requestLineObject, headers: headers, body: body);
  }
}
