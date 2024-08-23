import 'dart:io';

import 'model/request.dart';
import 'response/echo_response.dart';
import 'response/files_response.dart';
import 'response/home_response.dart';
import 'response/user_agent_response.dart';

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
    String requestStr = String.fromCharCodes(data);

    Request request = Request.fromString(requestStr);
    print("RequestLine: ${request.requestLine}");

    // Extract and print headers
    print("headers: ${request.headers}");

    print("\n${'-' * 20}\n");

    // Handle the request
    // ...

    // Send the HTTP response back to the client
    // ...
    if (request.requestLine.requestTarget == '/' ||
        request.requestLine.requestTarget == '/index.html') {
      // response body
      String response = homeResponse();

      // Send the HTTP response back to the client
      clientSocket.write(response);
    } else if (request.requestLine.requestTarget.contains("/echo/")) {
      // response body
      String response = echoResponse(request);

      // Send the HTTP response back to the client
      clientSocket.write(response);
    } else if (request.requestLine.requestTarget.contains("/user-agent")) {
      // response body
      String response = userAgentResponse(request);

      // Send the HTTP response back to the client
      clientSocket.write(response);
    } else if (request.requestLine.requestTarget.contains("/files/")) {
      // response body
      FilesResponse filesResponse = FilesResponse();
      String response = await filesResponse.response(arguments, request);

      // Send the HTTP response back to the client
      clientSocket.write(response);
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
