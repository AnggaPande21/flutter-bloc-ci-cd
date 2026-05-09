/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  ServerException(super.message);
}

/// Exception thrown when there's a network issue
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Exception thrown when data parsing fails
class DataParsingException extends AppException {
  DataParsingException(super.message);
}
