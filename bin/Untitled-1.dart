import 'dart:convert';
import 'dart:io';

void main() async {
  var serverSocket = await ServerSocket.bind('0.0.0.0', 4221);
  Stream.value("test\r\ntest\r\n\r\ntest").transform(LineSplitter());
  await for (var clientSocket in serverSocket) {
    clientSocket.write('HTTP/1.1 200 OK\r\n\r\n');
    var lines = clientSocket
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(LineSplitter());
    String? request;
    List<String> headers = [];
    List<String> body = [];
    var state = ReadState.request;
    loop:
    await for (var line in lines) {
      switch (state) {
        case ReadState.request:
          request = line;
          state = ReadState.headers;
        case ReadState.headers:
          if (line.isNotEmpty) {
            headers.add(line);
          } else {
            state = ReadState.body;
            // We only want to read body when we know there is some, otherwise
            // we'll wait here forever because the client doesn't close
            // the stream.
            break loop;
          }
        case ReadState.body:
          body.add(line);
      }
    }
    var [method, path, http] = request!.split(' ');
    if (path == '/') {
      clientSocket.write('HTTP/1.1 200 OK\r\n\r\n');
    } else {
      clientSocket.write('HTTP/1.1 404 Not Found\r\n\r\n');
    }
    await clientSocket.close();
  }
}

enum ReadState {
  request,
  headers,
  body,
}
