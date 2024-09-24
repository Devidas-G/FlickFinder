class ApiException implements Exception {
  final String message;
  final int? statuscode;

  ApiException({required this.message, this.statuscode});
}

class CacheException implements Exception {
  final String? message;

  CacheException([this.message]);
}
