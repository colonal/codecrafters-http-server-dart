import 'dart:io';

import '../enum/http_method.dart';
import '../model/request.dart';

class FilesResponse {
  Future<String> response(List<String> arguments, Request request) async {
    if (request.requestLine.hTTPMethod == HttpMethod.GET) {
      return _get(arguments, request);
    } else if (request.requestLine.hTTPMethod == HttpMethod.POST) {
      return _post(arguments, request);
    } else {
      return 'HTTP/1.1 405 Method Not Allowed\r\n\r\n';
    }
  }

  Future<String> _get(List<String> arguments, Request request) async {
    String fileName = request.requestLine.requestTarget.split("/files/")[1];

    print("current.path: ${Directory.current.path}");
    print("arguments: ${arguments}");
    List<String> paths = [
      Directory.current.path,
      if (arguments.length > 1) arguments[1]
    ];

    for (var path in paths) {
      var myFile = File("$path$fileName");
      var isFileExists = await myFile.exists();
      if (isFileExists) {
        var fileSize = await myFile.length();
        var responseBody = await myFile.readAsString();

        // Prepare the HTTP response
        var response = 'HTTP/1.1 200 OK\r\n' +
            'Content-Type: application/octet-stream\r\n' +
            'Content-Length: ${fileSize}\r\n' +
            '\r\n' +
            '$responseBody';
        // Send the HTTP response back to the client

        return response;
      }
    }

    // Send a 404 Not Found response
    return 'HTTP/1.1 404 Not Found\r\n\r\n';
  }

  Future<String> _post(List<String> arguments, Request request) async {
    if (arguments.length < 2) return "HTTP/1.1 404 Not Found\r\n\r\n";

    String path = arguments[1];
    String fileName = request.requestLine.requestTarget.split("/files/")[1];
    File myFile = File("$path$fileName");

    await myFile.writeAsString(request.body.trim());

    return "HTTP/1.1 201 Created\r\n\r\n";
  }
}
