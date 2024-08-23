String homeResponse() {
  // response body
  String responseBody = 'Hello, World!';

  // Prepare the HTTP response
  String response = 'HTTP/1.1 200 OK\r\n' +
      'Content-Type: text/plain\r\n' +
      'Content-Length: ${responseBody.length}\r\n' +
      '\r\n' +
      '$responseBody';
  return response;
}
