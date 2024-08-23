enum HttpMethod {
  GET('GET'),
  POST('POST'),
  PUT('PUT'),
  PATCH('PATCH'),
  DELETE('DELETE'),
  OPTIONS('OPTIONS'),
  HEAD('HEAD');

  final String name;

  factory HttpMethod.fromName(String name) {
    return HttpMethod.values.firstWhere(
      (method) => method.name == name,
      orElse: () => throw 'Unknown HTTP method: $name',
    );
  }

  const HttpMethod(this.name);
}
