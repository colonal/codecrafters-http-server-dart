import 'dart:io';

void main() async {
  var serverSocket = await ServerSocket.bind('0.0.0.0', 4221);

  await for (var clientSocket in serverSocket) {
    print("Client connected");
    print("Address: ${clientSocket.address.address}");
    print("name: ${clientSocket.address.type.name}");
    print("host: ${clientSocket.address.host}");

    // Read the client's request data
    List<int> data = await clientSocket.first;
    String request = String.fromCharCodes(data);
    print("Request: " + request.trim());

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

    // Close the connection
    await clientSocket.close();
  }
}
