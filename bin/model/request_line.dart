class RequestLine {
  final String hTTPMethod;
  final String requestTarget;
  final String hTTPVersion;

  RequestLine(
      {required this.hTTPMethod,
      required this.requestTarget,
      required this.hTTPVersion});

  factory RequestLine.fromString(String requestLine) {
    List<String> requestLineList = requestLine.split(' ');
    return RequestLine(
      hTTPMethod: requestLineList[0],
      requestTarget: requestLineList[1],
      hTTPVersion: requestLineList[2],
    );
  }

  @override
  String toString() {
    return 'hTTPMethod: $hTTPMethod, requestTarget: $requestTarget, hTTPVersion: $hTTPVersion';
  }
}
