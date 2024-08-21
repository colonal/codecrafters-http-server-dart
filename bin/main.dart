import 'dart:io';

import 'model/request_line.dart';

void main(List<String> arguments) async {
  var serverSocket = await ServerSocket.bind('0.0.0.0', 4221);

  await for (var clientSocket in serverSocket) {
    handleClient(clientSocket, arguments);
  }
}

void handleClient(Socket clientSocket, List<String> arguments) async {
  print("Client connected");
  print("Address: ${clientSocket.address.address}");
  print("name: ${clientSocket.address.type.name}");
  print("host: ${clientSocket.address.host}");

  try {
    // Read the client's request data
    List<int> data = await clientSocket.first;
    String request = String.fromCharCodes(data);
    List<String> requestLines = request.split('\r\n');
    print("length: ${requestLines.length}");

    RequestLine requestLineObject = RequestLine.fromString(requestLines[0]);
    print("RequestLine: ${requestLineObject}");

    // Extract and print headers
    Map<String, String> headers = extractHeaders(requestLines);
    print("headers: ${headers}");

    print("\n${'-' * 20}\n");

    // Handle the request
    // ...

    // Send the HTTP response back to the client
    // ...
    if (requestLineObject.requestTarget == '/' ||
        requestLineObject.requestTarget == '/index.html') {
      // response body
      String responseBody = 'Hello, World!';

      // Prepare the HTTP response
      String response = 'HTTP/1.1 200 OK\r\n' +
          'Content-Type: text/plain\r\n' +
          'Content-Length: ${responseBody.length}\r\n' +
          '\r\n' +
          '$responseBody';

      // Send the HTTP response back to the client
      clientSocket.write(response);
    } else if (requestLineObject.requestTarget.contains("/echo/")) {
      // response body
      String responseBody = requestLineObject.requestTarget.split("/echo/")[1];

      // Prepare the HTTP response
      String response = 'HTTP/1.1 200 OK\r\n' +
          'Content-Type: text/plain\r\n' +
          'Content-Length: ${responseBody.length}\r\n' +
          '\r\n' +
          '$responseBody';

      // Send the HTTP response back to the client
      clientSocket.write(response);
    } else if (requestLineObject.requestTarget.contains("/user-agent")) {
      // response body
      String responseBody = headers["User-Agent"] ?? "";

      // Prepare the HTTP response
      String response = 'HTTP/1.1 200 OK\r\n' +
          'Content-Type: text/plain\r\n' +
          'Content-Length: ${responseBody.length}\r\n' +
          '\r\n' +
          '$responseBody';

      // Send the HTTP response back to the client
      clientSocket.write(response);
    } else if (requestLineObject.requestTarget.contains("/files/")) {
      // response body
      String fileName = requestLineObject.requestTarget.split("/files/")[1];

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
          clientSocket.write(response);
          return;
        }
      }

      // Send a 404 Not Found response
      clientSocket.write('HTTP/1.1 404 Not Found\r\n\r\n');
    } else {
      // Send a 404 Not Found response
      clientSocket.write('HTTP/1.1 404 Not Found\r\n\r\n');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    // Close the connection
    await clientSocket.close();
  }
}

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
