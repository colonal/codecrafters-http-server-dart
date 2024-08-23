import '../enum/http_method.dart';

class RequestLine {
  final HttpMethod hTTPMethod;
  final String requestTarget;
  final String hTTPVersion;

  RequestLine(
      {required this.hTTPMethod,
      required this.requestTarget,
      required this.hTTPVersion});

  factory RequestLine.fromString(String requestLine) {
    List<String> requestLineList = requestLine.split(' ');
    return RequestLine(
      hTTPMethod: HttpMethod.fromName(requestLineList[0]),
      requestTarget: requestLineList[1],
      hTTPVersion: requestLineList[2],
    );
  }

  @override
  String toString() {
    return 'hTTPMethod: $hTTPMethod, requestTarget: $requestTarget, hTTPVersion: $hTTPVersion';
  }
}
